-- 0002 · Outbox de eventos, idempotencia, bitácora, archivos, secretos, aprobaciones, alertas
-- Referencia: docs/02-arquitectura.md, docs/05-catalogo-eventos.md

create table plataforma.eventos_outbox (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  tipo text not null,
  version int not null default 1,
  agregado text not null,
  agregado_id uuid not null,
  actor_id uuid,
  payload jsonb not null,
  ocurrido_en timestamptz not null default now(),
  estado text not null default 'pendiente' check (estado in ('pendiente','procesado','error')),
  intentos int not null default 0,
  siguiente_intento_en timestamptz not null default now(),
  ultimo_error text
);
create index on plataforma.eventos_outbox (estado, siguiente_intento_en);

create table plataforma.eventos_procesados (
  evento_id uuid not null references plataforma.eventos_outbox(id),
  suscriptor text not null,
  procesado_en timestamptz not null default now(),
  primary key (evento_id, suscriptor)
);

create or replace function plataforma.publicar_evento(p_tipo text, p_agregado text, p_agregado_id uuid, p_payload jsonb, p_version int default 1)
returns uuid language plpgsql as $$
declare v_id uuid;
begin
  insert into plataforma.eventos_outbox (empresa_id, tipo, version, agregado, agregado_id, actor_id, payload)
  values (plataforma.empresa_actual(), p_tipo, p_version, p_agregado, p_agregado_id, auth.uid(), p_payload)
  returning id into v_id;
  return v_id;
end $$;

create table plataforma.bitacora (
  id bigint generated always as identity primary key,
  empresa_id uuid not null,
  usuario_id uuid,
  accion text not null,
  entidad text not null,
  entidad_id uuid,
  antes jsonb,
  despues jsonb,
  ocurrido_en timestamptz not null default now()
);

create or replace function plataforma.registrar_bitacora() returns trigger
language plpgsql security definer set search_path = plataforma as $$
begin
  insert into plataforma.bitacora (empresa_id, usuario_id, accion, entidad, entidad_id, antes, despues)
  values (coalesce((case when tg_op = 'DELETE' then old.empresa_id else new.empresa_id end), plataforma.empresa_actual()),
          auth.uid(), tg_op, tg_table_schema || '.' || tg_table_name,
          (case when tg_op = 'DELETE' then old.id else new.id end),
          (case when tg_op in ('UPDATE','DELETE') then to_jsonb(old) end),
          (case when tg_op in ('INSERT','UPDATE') then to_jsonb(new) end));
  return coalesce(new, old);
end $$;
-- Uso en cada tabla de negocio:
-- create trigger bitacora after insert or update or delete on <tabla> for each row execute function plataforma.registrar_bitacora();

create or replace function plataforma.bloquear_modificacion() returns trigger
language plpgsql as $$ begin raise exception 'Tabla de solo inserción: % no permitido en %', tg_op, tg_table_name; end $$;
create trigger solo_insercion before update or delete on plataforma.bitacora for each row execute function plataforma.bloquear_modificacion();

create table plataforma.archivos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  bucket text not null check (bucket in ('cfdi','evidencias','contratos','expedientes','bancos','general')),
  ruta text not null,
  nombre text not null,
  tipo_mime text not null,
  tamano_bytes bigint not null,
  hash_sha256 text not null,
  entidad text,
  entidad_id uuid,
  version int not null default 1,
  reemplaza_a_id uuid references plataforma.archivos(id),
  creado_en timestamptz not null default now(),
  creado_por uuid
);

create table plataforma.secretos_ref (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  tipo text not null check (tipo in ('csd','efirma','pac','sat','gps','banco','clabe','correo')),
  vault_secret_id uuid not null,
  descripcion text,
  rfc text,
  vigencia_fin date,
  creado_en timestamptz not null default now()
);

create table plataforma.integraciones (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  tipo text not null check (tipo in ('pac','sat','gps','correo','banco')),
  proveedor text not null,
  configuracion jsonb not null default '{}',
  secreto_ref_id uuid references plataforma.secretos_ref(id),
  activa boolean not null default false
);

create table plataforma.reglas_aprobacion (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  tipo text not null,
  monto_desde numeric(18,2) not null default 0,
  monto_hasta numeric(18,2),
  rol_aprobador text not null
);

create table plataforma.aprobaciones (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  tipo text not null,
  entidad text not null,
  entidad_id uuid not null,
  monto numeric(18,2),
  solicitado_por uuid not null,
  estado text not null default 'pendiente' check (estado in ('pendiente','aprobada','rechazada')),
  rol_aprobador text not null,
  resuelto_por uuid,
  comentario text,
  creado_en timestamptz not null default now(),
  resuelto_en timestamptz
);

create table plataforma.alertas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  tipo text not null,
  severidad text not null check (severidad in ('info','advertencia','critica')),
  entidad text,
  entidad_id uuid,
  mensaje text not null,
  vence_en timestamptz,
  rol_destino text,
  estado text not null default 'abierta' check (estado in ('abierta','atendida','descartada')),
  creado_en timestamptz not null default now(),
  unique (empresa_id, tipo, entidad_id, vence_en)
);

alter table plataforma.eventos_outbox enable row level security;
alter table plataforma.eventos_procesados enable row level security;
alter table plataforma.bitacora enable row level security;
alter table plataforma.archivos enable row level security;
alter table plataforma.secretos_ref enable row level security;
alter table plataforma.integraciones enable row level security;
alter table plataforma.reglas_aprobacion enable row level security;
alter table plataforma.aprobaciones enable row level security;
alter table plataforma.alertas enable row level security;

-- Outbox: solo inserción vía publicar_evento; lectura/proceso con service role (despachador)
create policy insertar on plataforma.eventos_outbox for insert with check (empresa_id = plataforma.empresa_actual());
create policy lectura_admin on plataforma.bitacora for select
  using (empresa_id = plataforma.empresa_actual() and (plataforma.tiene_rol('administrador') or plataforma.tiene_rol('propietario') or plataforma.tiene_rol('direccion')));
create policy por_empresa on plataforma.archivos using (empresa_id = plataforma.empresa_actual());
create policy admin on plataforma.secretos_ref using (empresa_id = plataforma.empresa_actual() and (plataforma.tiene_rol('administrador') or plataforma.tiene_rol('propietario')));
create policy admin on plataforma.integraciones using (empresa_id = plataforma.empresa_actual() and (plataforma.tiene_rol('administrador') or plataforma.tiene_rol('propietario')));
create policy por_empresa on plataforma.reglas_aprobacion using (empresa_id = plataforma.empresa_actual());
create policy por_empresa on plataforma.aprobaciones using (empresa_id = plataforma.empresa_actual());
create policy por_empresa on plataforma.alertas using (empresa_id = plataforma.empresa_actual());
