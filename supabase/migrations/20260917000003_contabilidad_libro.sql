-- 0003 · Libro contable inmutable
-- Referencia: docs/07-reglas-contables.md, docs/modulos/contabilidad.md
-- Solo el rol del motor contable (service role / función security definer) inserta.

create table contabilidad.cuentas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  codigo text not null,
  nombre text not null,
  nivel int not null,
  padre_id uuid references contabilidad.cuentas(id),
  naturaleza text not null check (naturaleza in ('deudora','acreedora')),
  tipo text not null check (tipo in ('activo','pasivo','capital','ingreso','costo','gasto','orden')),
  codigo_agrupador_sat text,
  afectable boolean not null default true,
  activa boolean not null default true,
  unique (empresa_id, codigo)
);

create table contabilidad.periodos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  ejercicio int not null,
  mes int not null check (mes between 1 and 13),
  estado text not null default 'abierto' check (estado in ('abierto','en_cierre','cerrado')),
  cerrado_por uuid,
  cerrado_en timestamptz,
  unique (empresa_id, ejercicio, mes)
);

create table contabilidad.reglas_contables (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  evento_tipo text not null,
  version int not null default 1,
  condicion jsonb not null default '{}',
  partidas jsonb not null,
  activa boolean not null default true,
  vigencia_desde date not null default current_date
);

create table contabilidad.polizas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  periodo_id uuid not null references contabilidad.periodos(id),
  tipo text not null check (tipo in ('I','E','D')),
  numero bigint not null,
  fecha date not null,
  concepto text not null,
  origen text not null check (origen in ('evento','manual','cierre','reversa')),
  evento_id uuid unique references plataforma.eventos_outbox(id),
  reversa_de_id uuid references contabilidad.polizas(id),
  total_cargos numeric(18,2) not null,
  total_abonos numeric(18,2) not null,
  hash text not null,
  hash_anterior text,
  creado_por uuid,
  creado_en timestamptz not null default now(),
  unique (empresa_id, periodo_id, tipo, numero),
  check (total_cargos = total_abonos)
);

create table contabilidad.partidas (
  id uuid primary key default gen_random_uuid(),
  poliza_id uuid not null references contabilidad.polizas(id),
  orden int not null,
  cuenta_id uuid not null references contabilidad.cuentas(id),
  cargo numeric(18,2) not null default 0 check (cargo >= 0),
  abono numeric(18,2) not null default 0 check (abono >= 0),
  concepto text,
  tercero_id uuid,
  dimensiones jsonb not null default '{}',
  cfdi_uuid text,
  rfc_tercero text,
  monto_total_cfdi numeric(18,2),
  check ((cargo = 0) <> (abono = 0))
);

create trigger inmutable before update or delete on contabilidad.polizas
  for each row execute function plataforma.bloquear_modificacion();
create trigger inmutable before update or delete on contabilidad.partidas
  for each row execute function plataforma.bloquear_modificacion();

-- Solo periodos abiertos
create or replace function contabilidad.validar_periodo_abierto() returns trigger
language plpgsql as $$
begin
  if (select estado from contabilidad.periodos where id = new.periodo_id) <> 'abierto' then
    raise exception 'El periodo de la póliza no está abierto';
  end if;
  return new;
end $$;
create trigger periodo_abierto before insert on contabilidad.polizas
  for each row execute function contabilidad.validar_periodo_abierto();

-- Verificación de cuadre al finalizar la transacción
create or replace function contabilidad.validar_cuadre() returns trigger
language plpgsql as $$
declare c numeric; a numeric; p contabilidad.polizas;
begin
  select * into p from contabilidad.polizas where id = new.poliza_id;
  select coalesce(sum(cargo),0), coalesce(sum(abono),0) into c, a from contabilidad.partidas where poliza_id = new.poliza_id;
  if c <> a or c <> p.total_cargos then
    raise exception 'Póliza % descuadrada: cargos % abonos % total %', p.id, c, a, p.total_cargos;
  end if;
  return null;
end $$;
create constraint trigger cuadre after insert on contabilidad.partidas
  deferrable initially deferred for each row execute function contabilidad.validar_cuadre();

create table contabilidad.saldos (
  empresa_id uuid not null references plataforma.empresas(id),
  cuenta_id uuid not null references contabilidad.cuentas(id),
  periodo_id uuid not null references contabilidad.periodos(id),
  saldo_inicial numeric(18,2) not null default 0,
  cargos numeric(18,2) not null default 0,
  abonos numeric(18,2) not null default 0,
  saldo_final numeric(18,2) not null default 0,
  primary key (cuenta_id, periodo_id)
);

alter table contabilidad.cuentas enable row level security;
alter table contabilidad.periodos enable row level security;
alter table contabilidad.reglas_contables enable row level security;
alter table contabilidad.polizas enable row level security;
alter table contabilidad.partidas enable row level security;
alter table contabilidad.saldos enable row level security;

create policy lectura on contabilidad.cuentas for select using (empresa_id = plataforma.empresa_actual());
create policy lectura on contabilidad.periodos for select using (empresa_id = plataforma.empresa_actual());
create policy lectura on contabilidad.reglas_contables for select using (empresa_id = plataforma.empresa_actual() and plataforma.tiene_rol('contabilidad'));
create policy lectura on contabilidad.polizas for select using (empresa_id = plataforma.empresa_actual());
create policy lectura on contabilidad.partidas for select using (exists (select 1 from contabilidad.polizas p where p.id = poliza_id and p.empresa_id = plataforma.empresa_actual()));
create policy lectura on contabilidad.saldos for select using (empresa_id = plataforma.empresa_actual());
-- Sin políticas de escritura: las inserciones las hace el motor contable con service role.
