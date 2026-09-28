# Catálogo de funciones — índice

Las 402 funciones del núcleo universal, divididas por área. Cada área es un archivo editable.

| # | Área | Archivo | Prefijo | Departamentos | E | P | A | Total |
|---|---|---|---|---|---|---|---|---|
| 1 | Finanzas | [`01-finanzas.md`](./01-finanzas.md) | `FIN` | 6 | 27 | 24 | 16 | 67 |
| 2 | Personas | [`02-personas.md`](./02-personas.md) | `PER` | 6 | 25 | 27 | 11 | 63 |
| 3 | Comercial | [`03-comercial.md`](./03-comercial.md) | `COM` | 8 | 21 | 30 | 19 | 70 |
| 4 | Operaciones y Abastecimiento | [`04-operaciones.md`](./04-operaciones.md) | `OPE` | 8 | 23 | 32 | 21 | 76 |
| 5 | Legal y Riesgo | [`05-legal-riesgo.md`](./05-legal-riesgo.md) | `LEG` | 7 | 8 | 21 | 21 | 50 |
| 6 | Dirección | [`06-direccion.md`](./06-direccion.md) | `DIR` | 7 | 7 | 13 | 19 | 39 |
| 7 | Tecnología y Datos | [`07-tecnologia-datos.md`](./07-tecnologia-datos.md) | `TEC` | 4 | 7 | 16 | 14 | 37 |
| | **Total** | | | **46** | **118** | **163** | **121** | **402** |

## Planes

| Plan | Nivel | Funciones |
|---|---|---|
| Basic | E | 118 |
| Pro | E + P | 281 |
| Max | E + P + A | 402 |

## Add-ons

| Catálogo | Archivo | Funciones |
|---|---|---|
| Paquetes de modelo de negocio | [`08-paquetes-de-modelo.md`](./08-paquetes-de-modelo.md) | 140 |

Los paquetes se activan por **modelo de negocio**, no por industria, y no forman parte del núcleo. Los satélites de industria no se construyen y no están documentados en este repositorio.

La descripción de **qué hace cada uno de los 46 departamentos**, cuándo aparece en una empresa y qué lo caracteriza, está en [`../srs/18-departamentos-y-funciones.md`](../srs/18-departamentos-y-funciones.md).

## Reglas del catálogo

1. Una función pertenece a **una sola área** y a **un solo departamento**. Si parece pertenecer a dos, está mal definida o son dos funciones.
2. Las claves son permanentes. Se agregan al final de su área; nunca se renumeran ni se reciclan.
3. El nivel (`E`/`P`/`A`) decide en qué plan aparece la función, no cuándo se construye.
4. Ninguna función legalmente obligatoria ni de la línea base de seguridad puede quedar fuera del nivel Esencial: no se venden como add-on.
5. Una función que solo sirve a una industria no pertenece al núcleo.