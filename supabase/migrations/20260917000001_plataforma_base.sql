-- 0001 · Plataforma base: esquemas, empresa, identidad, permisos, maestros
-- Referencia: docs/04-modelo-de-datos.md, docs/06-matriz-roles.md

create extension if not exists pgcrypto;

create schema if not exists plataforma;
create schema if not exists comercial;
create schema if not exists operaciones;
create schema if not exists transporte;
create schema if not exists finanzas;
create schema if not exists contabilidad;
create schema if not exists personas;
create schema if not exists legal;
create schema if not exists direccion;
create schema if not exists analitica;

-- Empresa activa desde el JWT (app_metadata.empresa_id, asignada al seleccionar empresa)
create or replace function plataforma.empresa_actual() returns uuid
language sql stable as $$
  select nullif(auth.jwt() -> 'app_metadata' ->> 'empresa_id', '')::uuid
$$;

create table plataforma.empresas (
  id uuid primary key default gen_random_uuid(),
  razon_social text not null,
  rfc text not null unique,
  regimen_fiscal text not null,
  codigo_postal_fiscal text not null,
  nombre_comercial text,
  plan text not null default 'basic' check (plan in ('basic','pro','max')),
  activa boolean not null default true,
  creado_en timestamptz not null default now()
);

create table plataforma.sucursales (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  nombre text not null,
  codigo_postal text not null,
  estado text not null,
  es_matriz boolean not null default false,
  creado_en timestamptz not null default now()
);

create table plataforma.usuarios (
  id uuid primary key references auth.users(id),
  nombre text not null,
  email text not null,
  activo boolean not null default true,
  ultimo_acceso timestamptz,
  creado_en timestamptz not null default now()
);

create table plataforma.roles (
  id uuid primary key default gen_random_uuid(),
  clave text not null unique check (clave in ('propietario','administrador','direccion','tesoreria','contabilidad','personas','comercial','despacho','operador','colaborador')),
  nombre text not null,
  es_sistema boolean not null default true
);

create table plataforma.permisos (
  id uuid primary key default gen_random_uuid(),
  rol_id uuid not null references plataforma.roles(id),
  recurso text not null,
  accion text not null check (accion in ('ver','crear','editar','aprobar','eliminar','exportar')),
  alcance text not null default 'empresa' check (alcance in ('propios','empresa')),
  unique (rol_id, recurso, accion)
);

create table plataforma.usuario_empresas (
  usuario_id uuid not null references plataforma.usuarios(id),
  empresa_id uuid not null references plataforma.empresas(id),
  empleado_id uuid,
  activo boolean not null default true,
  primary key (usuario_id, empresa_id)
);

create table plataforma.usuario_roles (
  usuario_id uuid not null references plataforma.usuarios(id),
  empresa_id uuid not null references plataforma.empresas(id),
  rol_id uuid not null references plataforma.roles(id),
  primary key (usuario_id, empresa_id, rol_id)
);

create or replace function plataforma.tiene_rol(p_clave text) returns boolean
language sql stable security definer set search_path = plataforma as $$
  select exists (
    select 1 from plataforma.usuario_roles ur
    join plataforma.roles r on r.id = ur.rol_id
    where ur.usuario_id = auth.uid()
      and ur.empresa_id = plataforma.empresa_actual()
      and r.clave = p_clave)
$$;

create table plataforma.terceros (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  tipo_persona text not null check (tipo_persona in ('fisica','moral')),
  rfc text not null,
  razon_social text not null,
  regimen_fiscal text,
  codigo_postal_fiscal text,
  uso_cfdi_default text,
  email_facturacion text,
  es_cliente boolean not null default false,
  es_proveedor boolean not null default false,
  activo boolean not null default true,
  creado_en timestamptz not null default now(),
  creado_por uuid,
  actualizado_en timestamptz,
  actualizado_por uuid,
  unique (empresa_id, rfc, razon_social)
);

create table plataforma.productos_servicios (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null references plataforma.empresas(id),
  clave_interna text not null,
  descripcion text not null,
  clave_prod_serv_sat text not null,
  clave_unidad_sat text not null,
  objeto_impuesto text not null default '02',
  tasa_iva numeric(9,6) not null default 0.16,
  tasa_retencion_iva numeric(9,6) not null default 0,
  tasa_retencion_isr numeric(9,6) not null default 0,
  activo boolean not null default true,
  unique (empresa_id, clave_interna)
);

create table plataforma.catalogos_sat (
  catalogo text not null,
  clave text not null,
  descripcion text not null,
  vigencia_inicio date,
  vigencia_fin date,
  datos jsonb not null default '{}',
  primary key (catalogo, clave)
);

create table plataforma.parametros_fiscales (
  id uuid primary key default gen_random_uuid(),
  clave text not null,
  vigencia_inicio date not null,
  vigencia_fin date,
  valor jsonb not null,
  fuente text not null,
  unique (clave, vigencia_inicio)
);

create or replace function plataforma.parametro_vigente(p_clave text, p_fecha date) returns jsonb
language sql stable as $$
  select valor from plataforma.parametros_fiscales
  where clave = p_clave and vigencia_inicio <= p_fecha and (vigencia_fin is null or vigencia_fin >= p_fecha)
  order by vigencia_inicio desc limit 1
$$;

create table plataforma.folios (
  empresa_id uuid not null references plataforma.empresas(id),
  tipo text not null,
  serie text not null default '',
  siguiente bigint not null default 1,
  primary key (empresa_id, tipo, serie)
);

create or replace function plataforma.siguiente_folio(p_tipo text, p_serie text default '') returns bigint
language plpgsql as $$
declare v bigint;
begin
  insert into plataforma.folios (empresa_id, tipo, serie) values (plataforma.empresa_actual(), p_tipo, p_serie)
  on conflict do nothing;
  update plataforma.folios set siguiente = siguiente + 1
  where empresa_id = plataforma.empresa_actual() and tipo = p_tipo and serie = p_serie
  returning siguiente - 1 into v;
  return v;
end $$;

create table plataforma.configuracion (
  empresa_id uuid not null references plataforma.empresas(id),
  clave text not null,
  valor jsonb not null,
  primary key (empresa_id, clave)
);

-- RLS
alter table plataforma.empresas enable row level security;
alter table plataforma.sucursales enable row level security;
alter table plataforma.usuarios enable row level security;
alter table plataforma.roles enable row level security;
alter table plataforma.permisos enable row level security;
alter table plataforma.usuario_empresas enable row level security;
alter table plataforma.usuario_roles enable row level security;
alter table plataforma.terceros enable row level security;
alter table plataforma.productos_servicios enable row level security;
alter table plataforma.catalogos_sat enable row level security;
alter table plataforma.parametros_fiscales enable row level security;
alter table plataforma.folios enable row level security;
alter table plataforma.configuracion enable row level security;

create policy empresa_miembro on plataforma.empresas for select
  using (exists (select 1 from plataforma.usuario_empresas ue where ue.empresa_id = id and ue.usuario_id = auth.uid() and ue.activo));
create policy por_empresa on plataforma.sucursales using (empresa_id = plataforma.empresa_actual());
create policy propio on plataforma.usuarios for select using (id = auth.uid() or exists (
  select 1 from plataforma.usuario_empresas ue where ue.usuario_id = plataforma.usuarios.id and ue.empresa_id = plataforma.empresa_actual()));
create policy lectura on plataforma.roles for select using (true);
create policy lectura on plataforma.permisos for select using (true);
create policy propio on plataforma.usuario_empresas for select using (usuario_id = auth.uid() or empresa_id = plataforma.empresa_actual());
create policy por_empresa on plataforma.usuario_roles for select using (empresa_id = plataforma.empresa_actual());
create policy admin_escribe on plataforma.usuario_roles for all
  using (empresa_id = plataforma.empresa_actual() and (plataforma.tiene_rol('administrador') or plataforma.tiene_rol('propietario')));
create policy por_empresa on plataforma.terceros using (empresa_id = plataforma.empresa_actual());
create policy por_empresa on plataforma.productos_servicios using (empresa_id = plataforma.empresa_actual());
create policy lectura on plataforma.catalogos_sat for select using (true);
create policy lectura on plataforma.parametros_fiscales for select using (true);
create policy por_empresa on plataforma.folios using (empresa_id = plataforma.empresa_actual());
create policy por_empresa on plataforma.configuracion using (empresa_id = plataforma.empresa_actual());

insert into plataforma.roles (clave, nombre) values
 ('propietario','Propietario'),('administrador','Administrador del sistema'),('direccion','Dirección'),
 ('tesoreria','Tesorería'),('contabilidad','Contabilidad'),('personas','Personas'),('comercial','Comercial'),
 ('despacho','Despacho / Operaciones'),('operador','Operador'),('colaborador','Colaborador');
