# ADR-0004 · Multiempresa agrupada con aislamiento por fila

- **Fecha:** 2026-09-23
- **Estado:** aceptada

## Contexto
El sistema se venderá a varias empresas. Cada una debe operar de forma independiente y no conocer la existencia de las demás, pero todas deben recibir cada función nueva sin que se escriba más de una vez. Lo construye principalmente una persona con ayuda de IA, así que el costo de operar N instalaciones es prohibitivo.

Existen tres modelos posibles y ninguno más: agrupado (una base de datos, `empresa_id` en cada fila), esquema por empresa, y aislado (una instalación por cliente).

## Decisión
Multiempresa **agrupada**: un solo repositorio, una sola aplicación desplegada, una sola base de datos, con `empresa_id` en toda tabla de negocio y políticas de aislamiento a nivel de fila aplicadas por la base de datos.

Lo que cada empresa ve se decide con **datos**, no con código: su plan contratado, sus módulos y las banderas de función. No existe ninguna rama, archivo ni condición por nombre de cliente.

Para un cliente que exija aislamiento físico por contrato o regulación, se ofrece una **instancia dedicada**: el mismo repositorio y la misma versión, desplegados aparte. Nunca se entrega el código fuente.

## Alternativas consideradas
| Alternativa | Por qué no |
|---|---|
| Un esquema de base de datos por empresa | Cada migración se multiplica por el número de clientes; tiene los inconvenientes del agrupado y del aislado sin las ventajas de ninguno |
| Una instalación por cliente desde el inicio | El costo de operación crece linealmente con las ventas; una persona no puede operar diez instalaciones y además construir |
| Vender el código fuente con cada licencia | Cada copia se congela el día que se entrega. A los dos años son N productos distintos, todos sin actualizar, y el soporte es imposible |

## Consecuencias
- **Más fácil:** agregar un cliente (es un alta de datos), desplegar una función para todos, operar, medir.
- **Más difícil:** restaurar los datos de un solo cliente, porque el respaldo general devuelve a todos. Se resuelve con exportación lógica diaria por empresa y un procedimiento probado de reemplazo.
- **Riesgo concentrado:** una fuga entre empresas o una migración mala afecta a todos a la vez. Por eso el aislamiento vive en la base de datos y no en el código, y las migraciones se hacen en dos pasos.
- **Presión de personalización:** habrá que decir que no. Lo que sirva a varios clientes se vuelve función del catálogo; lo que sirva a uno solo vive en su propio módulo contratable, nunca en un `if` por cliente.

## Cómo se revierte
Una empresa puede extraerse a una instancia dedicada sin cambiar código: se despliega el mismo repositorio contra otra base de datos y se carga su exportación. Es barato **porque** cada fila lleva `empresa_id` desde la primera migración. Hacerlo al revés —agregar multiempresa a un sistema que no lo tenía— sería reescribir el sistema.

## Detalle
El diseño completo, con sus riesgos, controles y el orden en que construirlos, está en `docs/srs/20-multiempresa-y-distribucion.md`.
