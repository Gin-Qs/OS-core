# HANDOFF — punto de partida para una sesión nueva

Este documento existe para que una conversación nueva de Claude Code retome el proyecto sin haber visto la planeación. Léelo completo antes de escribir código. Después: **`docs/srs/00-indice.md`** (la especificación completa, en 20 documentos: qué hace el sistema, cómo se comporta y por qué), `CLAUDE.md`, `docs/01-alcance.md` y el archivo del área en la que vayas a trabajar.

---

## 1. Qué se está construyendo

Un **sistema operativo de negocio** para empresas mexicanas: ERP + CRM + contabilidad + fiscal + nómina + operación en un solo lugar, multiempresa, con permisos por rol y **contabilidad y timbrado propios** — no una integración con un sistema contable de terceros.

La arquitectura de producto es **núcleo universal + satélites de industria**. Este repositorio es **solo el núcleo**: las 402 funciones que sirven a cualquier empresa sin importar su giro. Los satélites se diseñarán cuando el núcleo esté terminado y no están aquí.

**Modelo comercial:** tres planes por nivel de función — Basic 118 · Pro 281 · Max 402 — más add-ons por paquete de modelo de negocio. No es prioridad todavía; el producto va primero.

**Quién construye:** una persona con ayuda de IA y apoyo puntual de desarrolladores. Eso condiciona todo: servicios administrados en vez de infraestructura propia, límites de módulo explícitos, y pruebas automáticas obligatorias en los motores fiscal, contable y de nómina.

---

## 2. Cómo está organizado el catálogo

Las 402 funciones están divididas por área, un archivo por área en `docs/areas/`. **Ese es el documento que se edita cuando cambia el alcance.**

| Área | Archivo | Prefijo | Deptos. | E | P | A | Total |
|---|---|---|---|---|---|---|---|
| Finanzas | `areas/01-finanzas.md` | `FIN` | 6 | 27 | 24 | 16 | 67 |
| Personas | `areas/02-personas.md` | `PER` | 6 | 25 | 27 | 11 | 63 |
| Comercial | `areas/03-comercial.md` | `COM` | 8 | 21 | 30 | 19 | 70 |
| Operaciones y Abastecimiento | `areas/04-operaciones.md` | `OPE` | 8 | 23 | 32 | 21 | 76 |
| Legal y Riesgo | `areas/05-legal-riesgo.md` | `LEG` | 7 | 8 | 21 | 21 | 50 |
| Dirección | `areas/06-direccion.md` | `DIR` | 7 | 7 | 13 | 19 | 39 |
| Tecnología y Datos | `areas/07-tecnologia-datos.md` | `TEC` | 4 | 7 | 16 | 14 | 37 |
| **Total** | | | **46** | **118** | **163** | **121** | **402** |

Reglas del catálogo, cortas y firmes:

- Una función pertenece a **un área y un departamento**. Si parece pertenecer a dos, está mal definida o son dos funciones.
- **Las claves son permanentes.** Se agregan al final de su área; nunca se renumeran ni se reciclan. Viven en commits, tareas y pruebas.
- El nivel (`E`/`P`/`A`) decide **en qué plan** aparece la función, no cuándo se construye.
- Nada legalmente obligatorio ni de la línea base de seguridad sale del nivel Esencial.
- Una función que solo sirve a una industria no es núcleo.

Add-ons fuera del núcleo: `docs/areas/08-paquetes-de-modelo.md` (140 funciones en 4 paquetes).

---

## 3. Qué hay en este repositorio

Especificación completa y tres migraciones SQL. **Todavía no hay código de aplicación**: la tarea `T-PLT-01` es la que inicializa el proyecto Next.js.

```
CLAUDE.md                 reglas no negociables de arquitectura y convenciones
HANDOFF.md                este documento
CONTRIBUTING.md           flujo de trabajo, ramas, commits, revisión
SECURITY.md               manejo de secretos y reporte de vulnerabilidades
docs/srs/                 especificación de requisitos en 20 documentos — la línea base
docs/SRS.md               la misma especificación en un solo archivo
docs/00 … docs/18         especificación de detalle (ver README.md para el mapa)
docs/areas/               catálogo de funciones por área — lo que más se edita
docs/adr/                 decisiones de arquitectura registradas
docs/modulos/             especificación por módulo de código
supabase/migrations/      tres migraciones base, ya probadas contra PostgreSQL 16
.claude/commands/         /siguiente-tarea · /revisar-modulo · /agregar-funcion
.github/workflows/ci.yml  CI (se activa cuando exista código)
```

Las tres migraciones ya se ejecutaron contra PostgreSQL 16 y pasaron: se crean los esquemas, la póliza descuadrada se rechaza, el `UPDATE` sobre pólizas se rechaza y un periodo cerrado bloquea escrituras.

---

## 4. Reglas de arquitectura que no se negocian

Completas en `CLAUDE.md`. Las que más se rompen por descuido:

1. **Monolito modular.** Un módulo no importa internals de otro, solo su `contracts/`. Lo verifica `eslint-plugin-boundaries`.
2. **Un esquema de base de datos por módulo.** Un módulo solo escribe en su esquema.
3. **Eventos en la misma transacción.** Patrón outbox. Los suscriptores registran `eventos_procesados`: procesar dos veces no duplica.
4. **Libro contable inmutable.** Solo el motor contable escribe en `contabilidad.*`. Nada de UPDATE ni DELETE; se corrige con póliza de reversa.
5. **Multiempresa desde la primera migración.** `empresa_id` y RLS en toda tabla de negocio. RLS nunca se desactiva.
6. **Secretos en Vault.** CSD, e.firma, credenciales, CLABE. Salarios en tabla con RLS restringida al rol Personas.
7. **Parámetros fiscales como datos con vigencia**, jamás en código.
8. **Extensibilidad.** Orden de trabajo, cotización, activo y empleado se diseñan genéricos para que un satélite los extienda después sin tocar el núcleo.

---

## 5. Por dónde seguir

1. Resolver la checklist **"Antes de construir"** de `docs/11-plan-de-construccion.md`.
2. Ejecutar `/siguiente-tarea`, que arranca en **T-PLT-01**.
3. Respetar el orden del plan:

| Fase | Contenido |
|---|---|
| **0 · Fundación** | Plataforma, roles y RLS · bus de eventos · libro contable · motores fiscal, contable, flujos, documentos, alertas · PWA |
| **1 · Nivel Esencial (118)** | Tecnología → Comercial → Finanzas → Operaciones → Personas → Legal → Dirección |
| **2 · Nivel Profesional (163)** | Mismo orden entre áreas |
| **3 · Nivel Avanzado (121)** | Mismo orden entre áreas |

Dirección va al final en las tres fases: no captura datos propios, lee de las demás. Un tablero construido antes que sus fuentes muestra ceros.

**Criterio para cerrar la fase 1:** una empresa real opera un mes calendario completo dentro del sistema —vende, factura, cobra, compra, paga, paga nómina, contabiliza, cierra y declara— sin una sola hoja de cálculo paralela, y las cifras coinciden con lo presentado ante el SAT.

---

## 6. Decisiones abiertas — pregunta, no inventes

| # | Pendiente | Impacto |
|---|---|---|
| 1 | **Validación del contador** de `docs/07-reglas-contables.md` (catálogo con código agrupador SAT y reglas R-01 a R-16) y de los casos dorados CD-01 a CD-10 | Bloquea la semilla del catálogo contable. El motor se puede construir antes: las reglas son datos, no código |
| 2 | **Stack**: Next.js App Router + TypeScript + Supabase + Vercel + PWA (Serwist) es un supuesto, no una decisión firmada | Bloquea `T-PLT-01` |
| 3 | **PAC** elegido y credenciales de sandbox | Bloquea `T-PLT-15` |
| 4 | **Atajo T4**: que el PAC selle el CFDI (el CSD se carga en el PAC) en vez de implementar cadena original, XSLT y criptografía propia | Ahorra semanas. Va detrás de un adaptador: reversible |
| 5 | **Atajo T5**: descarga masiva del SAT vía proveedor en vez del SOAP con e.firma | Igual que el anterior. Si se rechaza, `T-FIN-06` crece bastante |
| 6 | **Nombre del producto** (se usa "OS" como nombre de trabajo) | Cosmético hasta que haya interfaz pública |
| 7 | Prerrequisitos externos: RFC, e.firma, CSD y cuenta bancaria de la empresa | Bloquean producción, no el desarrollo |

---

## 7. Glosario mínimo

- **CFDI 4.0** — la factura electrónica mexicana. Se emite en XML, la sella un **PAC** (proveedor autorizado de certificación) y solo entonces es válida.
- **Complemento de pagos 2.0** — comprobante adicional que se emite al cobrar una factura PPD (pago en parcialidades o diferido).
- **Póliza** — el asiento contable: partidas con cargos y abonos que deben sumar igual. Aquí las genera el motor contable a partir de eventos, no una persona.
- **DIOT** — declaración informativa mensual de operaciones con terceros; se arma desde los CFDI recibidos.
- **IVA en flujo** — en México el IVA se causa al cobrar y se acredita al pagar, no al facturar. Por eso tesorería y contabilidad no pueden construirse por separado.
- **Núcleo / satélite** — universal para cualquier empresa / específico de una industria.
- **Casos dorados** — los escenarios de `docs/12-pruebas-y-calidad.md` (CD-01 a CD-10) que los motores fiscal, contable y de nómina tienen que pasar siempre.

El glosario completo está en `docs/18-glosario.md`.
