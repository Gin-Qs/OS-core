# ADR-0005 · Stack tecnológico y reparto de la ejecución

- **Fecha:** 2026-09-24
- **Estado:** aceptada
- **Cierra:** la decisión abierta `DA-02` del SRS §16 y el supuesto `T1` de `docs/00-vision-y-decisiones.md`

## Contexto
El sistema es un OS de negocio multiempresa con contabilidad y timbrado propios. Antes de escribir la primera línea había que fijar el stack, porque tres reglas del sistema no se pueden implementar igual en cualquier tecnología:

1. **Aislamiento entre empresas.** Debe aplicarlo la base de datos, no la aplicación (`ADR-0004`). Eso exige aislamiento por fila nativo en el motor de base de datos.
2. **Libro contable inmutable.** El rechazo del `UPDATE` y el bloqueo de periodos cerrados deben vivir dentro de la base (`ADR-0002`), no en una capa que se pueda saltar.
3. **Tareas que corren solas.** Descarga masiva del SAT, conciliación, cálculo de provisiones y alertas por vencimiento necesitan un programador de tareas confiable, sin un servidor permanentemente encendido.

A esto se suma una restricción de operación: lo construye principalmente una persona con ayuda de IA. Todo componente que haya que administrar a mano (un servidor, un motor de base de datos, un programador de tareas propio) es tiempo que no se dedica a construir funciones.

## Decisión

| Capa | Elección | Por qué esta |
|---|---|---|
| Base de datos | **PostgreSQL 16+ sobre Supabase** | Es el único motor gestionado accesible con aislamiento por fila (RLS) nativo, `numeric` exacto para dinero, restricciones y disparadores suficientemente expresivos para el libro inmutable, y `pg_cron` dentro de la propia base |
| Secretos | **Supabase Vault** | CSD, e.firma, credenciales de banco y PAC cifrados aparte de las tablas; en las tablas solo la referencia (`CLAUDE.md` regla 6) |
| Archivos | **Supabase Storage** | XML, PDF y evidencia de campo separados de los datos, con carpeta por empresa |
| Tareas programadas | **pg_cron + Edge Functions** | El programador vive dentro de la base; no hay un servidor encendido esperando la medianoche |
| Aplicación | **Next.js (App Router) + TypeScript estricto** | Un solo lenguaje de la pantalla al servidor; acciones de servidor donde viven las decisiones y los secretos; tipado estricto sobre un dominio fiscal donde un error de tipo es un error de dinero |
| Despliegue | **Vercel** | Servidores sin estado que aparecen y desaparecen con la carga (SRS §10.7.2); despliegue automático desde GitHub; tres entornos sin administrar máquinas |
| Interfaz | **Tailwind + shadcn/ui + React Hook Form + Zod + TanStack Table** | Componentes propios en el repositorio, no una dependencia que decida por nosotros; Zod valida en la frontera de cada acción de servidor |
| Uso en campo | **PWA (Serwist)** | Órdenes de trabajo y evidencia sin señal, sin dos aplicaciones nativas que mantener |
| Pruebas | **Vitest + Playwright** | Unitarias sobre los motores (casos dorados del doc 12) y de extremo a extremo sobre los flujos críticos |
| Paquetes | **pnpm** | Instalaciones reproducibles y rápidas |
| Dinero | **`numeric(18,2)` en BD; entero en centavos o `decimal.js` en TypeScript** | Nunca punto flotante |

El reparto de qué corre dónde —navegador, Vercel, dentro de la base— está en el SRS §10.7.1, y lo ordena un principio: **cuanto más grave sea que una regla falle, más abajo vive.**

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| MySQL o SQL Server | Sin aislamiento por fila equivalente y gratuito; el filtro por empresa terminaría en la aplicación, que es exactamente lo que `ADR-0004` prohíbe |
| MongoDB u otro documental | Sin transacciones multi-tabla cómodas ni restricciones declarativas; el libro contable y el patrón outbox dependen de escribir el hecho y su evento en la misma transacción |
| PostgreSQL administrado por nosotros (VPS) | Ahorra unos dólares al mes y cuesta respaldos, actualizaciones, vigilancia y noches. Una persona no puede operar eso y además construir |
| Backend separado (Node/Nest, Django) con un front aparte | Dos proyectos, dos despliegues, dos juegos de tipos y una frontera que hay que mantener a mano. El monolito modular (`ADR-0001`) ya da la separación sin el costo |
| Servidores propios o contenedores permanentes | Estado pegado a máquinas, escalado manual y parcheo. El diseño ya exige servidores sin estado (SRS §10.7.2), así que no hay nada que ganar |
| Aplicación nativa iOS + Android para campo | Tres bases de código y dos tiendas para pantallas que son formularios con fotos. La PWA cubre el caso sin señal |
| Supabase Auth reemplazado por un proveedor externo | Se pierde la integración directa entre la identidad y las políticas de fila, que es el mecanismo del aislamiento |

## Consecuencias
- **Más fácil:** una sola persona puede construir y operar; cada regla crítica queda donde no se puede saltar; los tres entornos (local, desarrollo, producción) existen sin administrar máquinas.
- **Dependencia:** Supabase y Vercel son proveedores. El riesgo real está acotado porque lo irremplazable es **PostgreSQL estándar y el repositorio en GitHub** (SRS §10.7.5): una base de datos de Postgres se mueve a otro proveedor gestionado, y Next.js corre en cualquier sitio que ejecute Node. Lo que sí es propio de Supabase —Vault, `pg_cron`, Storage, Edge Functions— se usa **detrás de adaptadores**, igual que los atajos fiscales de `ADR-0003`.
- **Límite conocido:** la ejecución sin estado impone un tope de duración por petición. Todo proceso largo (descarga masiva del SAT, cálculo de nómina de una empresa grande, contabilidad electrónica del periodo) se diseña como trabajo en cola, no como una petición que espera.
- **Costo:** crece con el uso, no con el número de clientes, porque todas las empresas comparten la instalación (`ADR-0004`).

## Cómo se revierte
Cambiar de proveedor de base de datos es una migración de datos de Postgres a Postgres más reescribir los adaptadores de Vault, Storage, tareas programadas y Auth: días, no meses, y solo si los adaptadores se respetaron. Cambiar de plataforma de despliegue es reconstruir el mismo repositorio en otro sitio que ejecute Node.

Lo que **no** se revierte con facilidad es abandonar PostgreSQL: el aislamiento por fila, el libro inmutable y el patrón outbox están escritos contra sus garantías. Esa es la elección de fondo de este ADR; las demás son intercambiables.

## Detalle
Stack y convenciones: `docs/03-stack-y-convenciones.md`. Reparto de la ejecución y los tres entornos: SRS §10.7. Por qué esta arquitectura y no otra: SRS §10.11.
