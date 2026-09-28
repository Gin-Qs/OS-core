# ADR-0002 · Libro contable inmutable y aislado

- **Fecha:** 2026-09-16
- **Estado:** aceptada

## Contexto
La contabilidad es la fuente de verdad ante el SAT y ante cualquier auditoría, y debe conservarse cinco años. Un sistema donde cualquier módulo puede escribir pólizas, o donde una póliza se puede editar, pierde justamente lo que la hace útil: que lo registrado no cambió después.

## Decisión
El esquema `contabilidad` es de solo inserción. Solo el motor contable escribe en él, y lo hace a partir de eventos, nunca por captura directa de otro módulo. Las pólizas y sus partidas rechazan `UPDATE` y `DELETE` por trigger; llevan hash encadenado; un periodo cerrado rechaza escrituras. Los errores se corrigen con una póliza de reversa.

## Alternativas consideradas
| Alternativa | Por qué no |
|---|---|
| Pólizas editables con bitácora | La bitácora dice que algo cambió, pero el libro ya no es evidencia de lo que se registró en su momento |
| Borrado lógico (`activo = false`) | Una póliza "inactiva" sigue siendo una póliza modificada; ante el SAT no es defendible |
| Cada módulo escribe sus propias pólizas | Multiplica las reglas contables por el número de módulos y garantiza que se contradigan |

## Consecuencias
- Más fácil: auditar, cerrar periodos, confiar en la balanza, demostrar integridad con el hash.
- Más difícil: corregir. Toda corrección cuesta una póliza de reversa, y eso es intencional.
- Las reglas contables se guardan **como datos** (`contabilidad.reglas_contables`), no como código: el contador puede ajustarlas sin reprogramar.

## Cómo se revierte
No se revierte. Un libro contable mutable no es una variante de diseño, es un defecto.
