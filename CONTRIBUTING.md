# Cómo se trabaja en este repositorio

## El ciclo

1. **Elegir tarea.** Una a la vez, del plan (`docs/11-plan-de-construccion.md`). En Claude Code: `/siguiente-tarea`.
2. **Rama.** `git switch -c fin/020-antiguedad-de-saldos` — prefijo del área en minúsculas, número de función, descripción corta.
3. **Antes de codificar**, escribir en la sesión: qué se va a hacer, qué documentos aplican y qué eventos se van a publicar. Si algo no está en los docs, se pregunta.
4. **Construir**, cumpliendo la definición de terminado de `CLAUDE.md`.
5. **Verificar**: `pnpm lint && pnpm typecheck && pnpm test`. Si la tarea toca dinero, impuestos o nómina, además su caso dorado del doc 12.
6. **Actualizar el estado** de la tarea en el plan.
7. **Pull request** con la plantilla de abajo.

## Commits

```
<tipo>(<clave>): <qué cambió, en imperativo>
```

Tipos: `feat` · `fix` · `refactor` · `test` · `docs` · `chore` · `db` (migraciones).
La clave es la de la función (`FIN-020`) o la de la tarea (`T-PLT-05`) cuando no corresponde a una función.

```
feat(FIN-020): antigüedad de saldos por cliente
db(T-PLT-13): libro contable con hash encadenado
fix(COM-007): el CFDI tomaba el régimen del emisor, no del receptor
docs(areas): mover LEG-023 de Profesional a Esencial
```

## Pull request

Cada PR responde cinco preguntas, en este orden:

1. Qué función o tarea implementa (con su clave).
2. Qué eventos publica o consume.
3. Qué migraciones incluye y si alguna borra datos.
4. Qué pruebas la cubren, y el caso dorado si aplica.
5. Qué quedó fuera a propósito.

No se mezcla nada con CI en rojo, ni una tabla de negocio sin su política RLS en la misma migración.

## Qué se revisa, en orden de importancia

1. **Aislamiento entre empresas.** ¿Toda tabla nueva tiene `empresa_id` y RLS? ¿Hay alguna consulta que se salte el filtro?
2. **Fronteras de módulo.** ¿Alguien importa internals de otro módulo? ¿Alguien escribe en un esquema ajeno?
3. **Eventos.** ¿Se publican en la misma transacción? ¿El suscriptor es idempotente?
4. **Dinero.** ¿Se usó decimal o centavos, nunca float? ¿Los redondeos siguen la regla del doc 07?
5. **Parámetros fiscales.** ¿Alguno quedó escrito en el código?
6. **Permisos.** ¿La acción de servidor verifica permiso, o solo se ocultó el botón?
7. **Pruebas.** ¿Prueban la regla de negocio o solo que la función existe?

## Cómo se cambia el catálogo de funciones

El catálogo vive en `docs/areas/`, un archivo por área.

- **Agregar:** siguiente número libre del área, aunque quede al final de la tabla de su departamento. Nunca se rellena un hueco.
- **Quitar:** se marca `retirada` en la columna Notas y se deja la fila. Borrarla libera una clave que ya vive en commits y pruebas.
- **Mover de nivel:** se cambia la columna Nivel. Eso cambia el plan en que aparece, no la clave ni el módulo.
- **Mover de área:** se retira en el área vieja y se crea con clave nueva en la correcta. Una clave nunca cambia de prefijo.

Cambiar el catálogo es un commit `docs(areas)` por sí solo, sin código mezclado.

## Cuándo se escribe un ADR

Cuando la decisión sea cara de revertir: elegir o cambiar de proveedor, cambiar el modelo de datos de un motor, romper compatibilidad, o desviarse de una regla de `CLAUDE.md`. Plantilla en `docs/adr/0000-plantilla.md`. Una decisión discutida y no registrada se vuelve a discutir en tres meses.

## Cuándo detenerse y preguntar

- Una regla fiscal o contable ambigua. **Siempre.** Esas las valida el contador.
- Una migración que borra datos o columnas en producción.
- Algo que exige romper una regla de `CLAUDE.md`.
- Una función que el catálogo no contiene.
