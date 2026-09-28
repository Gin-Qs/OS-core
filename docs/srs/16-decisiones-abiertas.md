## 16. Decisiones abiertas

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`) son estables y se referencian entre documentos.

Un SRS sin lagunas no significa que todo esté decidido: significa que **lo no decidido está declarado**, con responsable y fecha, en lugar de quedar al criterio de quien programa.

| # | Decisión pendiente | Qué bloquea | Quién decide | Cuándo se necesita | Criterio para decidir |
|---|---|---|---|---|---|
| `DA-01` | Validación del catálogo de cuentas y de las reglas contables | La semilla del catálogo. El motor se puede construir antes, porque las reglas son datos | Contador | Antes de `T-PLT-13` | Que el catálogo refleje la operación real y los agrupadores sean correctos |
| ~~`DA-02`~~ | ~~Confirmación del stack tecnológico~~ **CERRADA el 24/09/2026**: Next.js + TypeScript + **PostgreSQL sobre Supabase** + **Vercel** + PWA. Ver `ADR-0005` | — | Propietario del producto | — | Cumple los tres criterios: aislamiento por fila nativo, tareas programadas dentro de la base y bóveda de secretos |
| `DA-03` | Elección de PAC | El motor fiscal (`T-PLT-15`) | Propietario | Antes del bloque fiscal | Cobertura de CFDI 4.0, pagos 2.0 y nómina 1.2; ambiente de pruebas; API documentada; costo por timbre |
| `DA-04` | Confirmar que el PAC sella con el CSD cargado en él (`ADR-0003`) | Semanas de trabajo en criptografía | Propietario | Con `DA-03` | Que el PAC lo soporte y que el resguardo del CSD sea aceptable |
| `DA-05` | Proveedor de descarga masiva del SAT | El bloque de recepción de gastos | Propietario | Antes de `RF-138` | Que exista API; si no, se implementa el servicio con e.firma, con el costo que eso implica |
| `DA-06` | Nombre definitivo del producto | Nada técnico; solo la interfaz pública | Propietario | Antes de la primera interfaz visible a terceros | — |
| `DA-07` | Umbrales concretos de aprobación por tipo de operación | Configuración inicial, no el código | Dirección de cada empresa | En la puesta en marcha | Política de control interno de cada empresa |
| `DA-08` | Política de retención más allá del mínimo legal de 5 años | Costo de almacenamiento a largo plazo | Propietario | Antes del primer archivado | Costo contra utilidad de la consulta histórica |
| `DA-09` | Región de residencia de datos que se declarará al cliente | Contrato y `RNF-064` | Propietario | Antes del primer cliente externo | Latencia, costo y requisitos del cliente |
| `DA-10` | Formato de estado de cuenta de cada banco con el que se opere | El analizador correspondiente | Tesorería de cada empresa | En la puesta en marcha | El que el banco entregue de forma estable |

**Regla sobre esta tabla.** Mientras una decisión esté abierta, quien construye **no la resuelve por su cuenta**: implementa detrás de un adaptador o de un parámetro, deja la decisión pendiente documentada y sigue. Adivinar una regla fiscal es la forma más cara de avanzar.

---

---

[← 15-riesgos](./15-riesgos.md) · [Índice](./00-indice.md) · [17-trazabilidad →](./17-trazabilidad.md)
