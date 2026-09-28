# OS — Sistema Operativo de Negocio

ERP + CRM + contabilidad + fiscal + nómina + operación para empresas mexicanas, en un solo lugar, multiempresa, con permisos por rol y **contabilidad y timbrado propios**.

Este repositorio construye el **núcleo universal: 402 funciones** que sirven a cualquier empresa sin importar su giro. Los satélites de industria se diseñan después y no están aquí.

Este repositorio todavía no tiene código de aplicación: la tarea `T-PLT-01` es la que inicializa el proyecto Next.js. Lo que sí está completo es la especificación —catálogo de funciones, modelo de datos, eventos, roles, reglas contables, motor fiscal, pantallas, pruebas, seguridad y operación— y tres migraciones SQL ya probadas contra PostgreSQL 16.

## Cómo empezar
1. Abre esta carpeta en VS Code con Claude Code.
2. Lee **`HANDOFF.md`** — resume el proyecto completo y dice por dónde seguir.
3. Lee el **SRS** — la especificación de requisitos: qué hace el sistema, cómo se comporta y por qué. Es la línea base contra la que se verifica todo.
   - Por partes, para leer y editar: **`docs/srs/00-indice.md`** (20 documentos)
   - Todo junto, para buscar o imprimir: `docs/SRS.md`
4. Lee **`CLAUDE.md`** — las reglas no negociables de arquitectura.
5. Resuelve la checklist "Antes de construir" de `docs/11-plan-de-construccion.md`.
6. Ejecuta `/siguiente-tarea`.

## El catálogo de funciones

Dividido por área, un archivo editable por área, en `docs/areas/`.

| # | Área | Archivo | Prefijo | Deptos. | E | P | A | Total |
|---|---|---|---|---|---|---|---|---|
| 1 | Finanzas | `areas/01-finanzas.md` | `FIN` | 6 | 27 | 24 | 16 | 67 |
| 2 | Personas | `areas/02-personas.md` | `PER` | 6 | 25 | 27 | 11 | 63 |
| 3 | Comercial | `areas/03-comercial.md` | `COM` | 8 | 21 | 30 | 19 | 70 |
| 4 | Operaciones y Abastecimiento | `areas/04-operaciones.md` | `OPE` | 8 | 23 | 32 | 21 | 76 |
| 5 | Legal y Riesgo | `areas/05-legal-riesgo.md` | `LEG` | 7 | 8 | 21 | 21 | 50 |
| 6 | Dirección | `areas/06-direccion.md` | `DIR` | 7 | 7 | 13 | 19 | 39 |
| 7 | Tecnología y Datos | `areas/07-tecnologia-datos.md` | `TEC` | 4 | 7 | 16 | 14 | 37 |
| | **Total** | | | **46** | **118** | **163** | **121** | **402** |

Planes: **Basic** = nivel E (118) · **Pro** = E+P (281) · **Max** = E+P+A (402).
Add-ons fuera del núcleo: `areas/08-paquetes-de-modelo.md` (140 funciones en 4 paquetes de modelo de negocio).

## Mapa de documentos
| Doc | Contenido |
|---|---|
| `00` | Visión, decisiones y supuestos |
| `01` | Alcance del núcleo y los tres niveles |
| `02` | Arquitectura: capas, módulos, 6 almacenes, bus de eventos |
| `03` | Stack y convenciones de código |
| `04` | Modelo de datos |
| `05` | Catálogo de eventos |
| `06` | Matriz de roles y permisos |
| `07` | Catálogo de cuentas y reglas contables — **pendiente de validar con el contador** |
| `08` | Motor fiscal: CFDI 4.0, pagos 2.0, nómina 1.2, descarga masiva, impuestos |
| `09` | Integraciones |
| `10` | Pantallas y navegación |
| `11` | **Plan de construcción por fases y áreas** |
| `12` | Pruebas y calidad: casos dorados CD-01 a CD-10 |
| `16` | Seguridad y cumplimiento |
| `17` | Operación y despliegue |
| `18` | Glosario |
| **`srs/`** | **Especificación de requisitos, dividida en 20 documentos — la línea base** |
| `SRS.md` | La misma especificación en un solo archivo |
| `areas/` | **Catálogo de funciones — lo que más se edita** |
| `adr/` | Decisiones de arquitectura registradas |
| `srs/20` | Multiempresa, licencias y distribución comercial |
| `modulos/` | Especificación por módulo de código |

## Estructura
```
CLAUDE.md               reglas para Claude Code
HANDOFF.md              punto de partida para una sesión nueva
CONTRIBUTING.md         ramas, commits, revisión, cómo cambiar el catálogo
SECURITY.md             secretos y reporte de vulnerabilidades
CHANGELOG.md            bitácora de cambios
.claude/commands/       /siguiente-tarea · /agregar-funcion · /revisar-area · /revisar-modulo
.github/workflows/      CI: lint, typecheck, pruebas y migraciones
docs/                   especificación completa
supabase/migrations/    tres migraciones base, ya probadas
```
