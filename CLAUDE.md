# CLAUDE.md — Reglas para construir el OS

## Qué es
Sistema operativo de negocio multiempresa para México: ERP + CRM + contabilidad + fiscal + nómina + operación en un solo lugar, con permisos por rol y **contabilidad y timbrado propios**.

Este repositorio construye el **núcleo universal: 402 funciones**, en 7 áreas y 46 departamentos. El catálogo vive en `docs/areas/`, un archivo por área. Los satélites de industria no se construyen ni se documentan aquí.

Fuente de verdad: el **SRS** (`docs/srs/`, o `docs/SRS.md` completo) y el resto de la carpeta `docs/`. Cuando el código y el SRS difieran, gana el SRS. Si algo no está en los docs, pregunta antes de inventar.

| Área | Archivo del catálogo | Prefijo | Funciones |
|---|---|---|---|
| Finanzas | `docs/areas/01-finanzas.md` | `FIN` | 67 |
| Personas | `docs/areas/02-personas.md` | `PER` | 63 |
| Comercial | `docs/areas/03-comercial.md` | `COM` | 70 |
| Operaciones y Abastecimiento | `docs/areas/04-operaciones.md` | `OPE` | 76 |
| Legal y Riesgo | `docs/areas/05-legal-riesgo.md` | `LEG` | 50 |
| Dirección | `docs/areas/06-direccion.md` | `DIR` | 39 |
| Tecnología y Datos | `docs/areas/07-tecnologia-datos.md` | `TEC` | 37 |

Niveles: `E` Esencial (plan Basic, 118) · `P` Profesional (Pro, 281 acumuladas) · `A` Avanzado (Max, 402).

## Stack
Next.js (App Router) + TypeScript estricto · Supabase (PostgreSQL, Auth, Storage, Vault, RLS, pg_cron, Edge Functions) · Tailwind + shadcn/ui · Zod · React Hook Form · TanStack Table · Vitest · Playwright · PWA (Serwist) · Vercel · pnpm.

## Reglas de arquitectura (no negociables)
1. **Monolito modular.** Código por módulo en `src/modules/<modulo>`. Un módulo NO importa internals de otro; solo su `contracts/` (tipos y funciones públicas). Lo verifica `eslint-plugin-boundaries`.
2. **Un esquema de base de datos por módulo.** Un módulo solo escribe en su esquema. Nada de JOIN escribiendo cruzado.
3. **Comunicación por eventos.** Todo cambio relevante publica un evento en `plataforma.eventos_outbox` dentro de la MISMA transacción (patrón outbox). Ver `docs/05-catalogo-eventos.md`.
4. **Libro contable inmutable.** Solo el motor contable escribe en `contabilidad.*`. Prohibido UPDATE y DELETE en pólizas y partidas —la restricción vive en la base y no distingue quién pregunta: no hay credencial ni rol que la abra.
   La corrección se resuelve en tres zonas (SRS §11.3.1): ① el **documento origen** se edita libre mientras no se contabilice (`RF-044`); ② la **póliza en borrador** se edita y se borra sin rastro contable (`RF-041`); ③ el **libro** solo crece: *corregir* escribe reversa + sustituta en una transacción (`RF-042`), *reclasificar* genera póliza de ajuste (`RF-043`), y la cadena completa es consultable y no ocultable (`RF-045`).
   Nunca se implementa un registro de cambios oculto, cifrado aparte o accesible por contraseña maestra: eso no es un control, es una vía de alteración. Si una petición pide editar el libro sin dejar rastro, detente y pregunta.
5. **Multiempresa desde la primera migración.** Toda tabla de negocio tiene `empresa_id` y política RLS. Nunca se desactiva RLS, ni "un momento para probar".
6. **Datos sensibles.** CSD, e.firma, credenciales, CLABE: en Supabase Vault; en las tablas solo la referencia. Salarios: tabla con RLS restringida al rol Personas.
7. **Fiscal nunca en código.** Tres niveles, todos como datos con vigencia:
   - **Parámetros** (UMA, salario mínimo, tablas ISR, subsidio, cuotas IMSS, tasas ISN): `plataforma.parametros_fiscales`.
   - **Regímenes**: `plataforma.regimenes_fiscales`, con su base de acumulación (devengado/flujo). **Ningún archivo menciona un régimen por nombre**; un `if (regimen === '601')` es un defecto bloqueante, igual que el `if` por cliente.
   - **Cálculos**: `plataforma.definiciones_calculo`, versionadas, interpretadas por el motor, con papel de trabajo obligatorio y casos dorados firmados antes de activarse. Ver `ADR-0006` y SRS §3.4 y §7.4.1.
8. **Idempotencia.** Los suscriptores de eventos registran `plataforma.eventos_procesados`; procesar dos veces no duplica.
9. **Bitácora.** Toda escritura de negocio deja rastro en `plataforma.bitacora`.
10. **Nada por cliente.** No existe una rama, un archivo ni una condición por nombre de empresa. Lo que un cliente necesita distinto se resuelve con configuración, campos adicionales o un módulo contratable. Un `if (empresa === '...')` en el código es un defecto bloqueante. Ver `ADR-0004`.
11. **Extensibilidad.** La orden de trabajo, la cotización, el activo y el empleado se diseñan genéricos: algún día un satélite de industria los extenderá agregando tablas en su propio esquema, sin modificar ninguna tabla del núcleo.

## Estructura
```
src/
  app/                  # rutas Next.js (UI) agrupadas por área
  platform/             # auth, tenant, permisos, eventos, bitácora, archivos, alertas
  engines/
    fiscal/             # CFDI, PAC, SAT, cálculos de impuestos
    contable/           # reglas evento→póliza, periodos, contabilidad electrónica
    nomina/             # ISR, subsidio, SDI, IMSS, INFONAVIT
    flujos/             # aprobaciones
    documentos/         # plantillas y PDF
  modules/
    comercial/ finanzas/ contabilidad/ operaciones/ personas/ legal/ direccion/ tecnologia/
      contracts/  domain/  application/  infra/  ui/  subscribers/  __tests__/
supabase/migrations/    # SQL versionado
docs/                   # especificación; docs/areas/ = catálogo de funciones
```

Los módulos de código corresponden uno a uno con las áreas del catálogo. Una función `FIN-xxx` se implementa en `src/modules/finanzas` (o `contabilidad`), nunca repartida entre módulos.

## Convenciones
- Dominio en español (factura, poliza, cobranza); SQL snake_case; TypeScript camelCase; UI en español de México.
- Dinero: `numeric(18,2)` en BD; en TS entero en centavos o decimal.js, nunca float.
- Fechas en UTC en BD; se muestran en America/Mexico_City.
- Validación de entrada con Zod en cada acción de servidor.
- **Interfaz: cinco patrones y una sola costura visual.** Toda pantalla es Lista, Ficha, Captura, Tablero o Asistente (SRS §12.1.1); no se inventa un sexto ni se construye una tabla propia. Toda pantalla resuelve sus cuatro estados —cargando, vacío, error, con datos— y el estado vacío explica y ofrece la acción (`RNF-089`).
- **Ningún valor visual fuera del archivo de tokens.** Color, tipografía, espaciado, radios, sombras y transiciones viven ahí, con nombres por significado (`--color-peligro`, no `--color-rojo`). La identidad de marca está en definición: hoy los tokens llevan valores neutros deliberados y se sustituirán sin tocar componentes (`RNF-088`).
- Las acciones de servidor verifican permiso con `requirePermiso(recurso, accion)`.
- Un usuario puede tener **varios roles por empresa**; los permisos son la unión (acción y alcance más amplios). `requirePermiso` nunca pregunta "¿cuál es tu rol?", sino "¿alguno de tus roles autoriza esto?". Ver `RF-031` a `RF-033` y `docs/06-matriz-roles.md`.
- La segregación de funciones se controla sobre **la persona**, no sobre el rol: quien captura un pago no lo aprueba, aunque acumule el rol que aprueba.
- Un commit menciona la clave de la función: `feat(FIN-020): antigüedad de saldos`.

## Definición de terminado (cada tarea)
- Migración SQL con RLS + tipos regenerados.
- Lógica con pruebas (Vitest). Motores fiscal, contable y de nómina: pruebas con los casos dorados de `docs/12-pruebas-y-calidad.md`.
- Evento(s) publicados según el catálogo del doc 05.
- UI mínima funcional y protegida por permisos.
- `pnpm lint && pnpm typecheck && pnpm test` en verde.
- Estado de la tarea actualizado en `docs/11-plan-de-construccion.md`.

## Comandos
`pnpm dev` · `pnpm lint` · `pnpm typecheck` · `pnpm test` · `pnpm e2e` · `supabase db reset` · `supabase gen types typescript --local > src/platform/db/types.ts`

## Cómo trabajar
Una tarea a la vez del plan (`/siguiente-tarea`). Antes de codificar, resume qué vas a hacer y qué docs aplican.

La fase 0 del plan (plataforma y RLS · bus de eventos · libro contable · motores) es el cimiento del que dependen las siete áreas: no se recorta ni se reordena.

**Si una regla fiscal o contable es ambigua, detente y pregunta.** Esas reglas las valida un contador; no se deducen ni se aproximan.
