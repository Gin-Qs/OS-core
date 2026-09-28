# 01 · Alcance — el núcleo universal

Este repositorio construye el **núcleo**: las funciones que sirven a cualquier empresa sin importar su giro. **402 funciones**, en 7 áreas y 46 departamentos.

El catálogo completo vive en `docs/areas/`, un archivo por área. Ese es el documento que se edita cuando cambia el alcance; este resume qué contiene cada archivo.

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

## Los tres niveles

El nivel de una función decide **en qué plan aparece**, no cuándo se construye.

| Nivel | Plan | Funciones acumuladas | A quién sirve |
|---|---|---|---|
| `E` Esencial | Basic | 118 | Micro y pequeña empresa: opera, factura, paga, cumple |
| `P` Profesional | Pro | 281 | Mediana empresa: además controla, planea y mide |
| `A` Avanzado | Max | 402 | Empresa grande o grupo: además consolida, gobierna y predice |

Dos reglas que no se rompen al mover funciones de nivel:

1. **Nada legalmente obligatorio sale del nivel Esencial.** Facturar, timbrar nómina, declarar impuestos y conservar documentos no se venden como add-on.
2. **La línea base de seguridad tampoco.** Roles, bitácora, respaldos y cifrado de datos sensibles están en Basic.

## Qué está fuera del núcleo

| Fuera | Dónde está documentado | Por qué |
|---|---|---|
| Paquetes de modelo de negocio (140 funciones) | `docs/areas/08-paquetes-de-modelo.md` | Se activan por modelo de negocio (inventarios, canales de venta, operación internacional, grupo empresarial), no los necesita toda empresa |
| Satélites de industria | No están en este repositorio | Se diseñan cuando el núcleo esté terminado |

## La regla que define el núcleo

> Si una función solo le sirve a una industria, no es núcleo.

La prueba práctica: una función pertenece al núcleo si la necesitan por igual una empresa de servicios de tecnología y una comercializadora. Si solo la necesita una de las dos por su giro, es satélite.

## Extensibilidad: lo que el núcleo debe dejar preparado

Aunque no se construya ningún satélite, el núcleo se diseña para que después quepan sin rediseño:

| Entidad del núcleo | Lo que un satélite le agregará algún día |
|---|---|
| Orden de trabajo (`OPE-001`) | El trabajo concreto de cada industria (un viaje, una obra, una consulta) |
| Cotización (`COM-005`) | Formas de cotizar propias del giro |
| Activo (`OPE-040`) | Equipos y vehículos con sus vigencias y mantenimientos |
| Empleado (`PER-001`) | Certificaciones y licencias del oficio |
| Consumos por orden (`OPE-008`) | Los insumos que consume cada industria |
| Factura CFDI (`COM-007`) | Complementos fiscales por giro |

**Criterio de diseño:** un satélite debe poder construirse agregando tablas en su propio esquema y suscriptores a eventos existentes, **sin modificar una sola tabla del núcleo**. Si algún día hace falta alterar `operaciones.ordenes` o `comercial.cotizaciones` para que quepa algo específico de una industria, el núcleo se diseñó mal.
