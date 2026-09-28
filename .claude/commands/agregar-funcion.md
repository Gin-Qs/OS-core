Agrega una función nueva al catálogo del núcleo.

Argumento: la descripción de la función en lenguaje natural.

Pasos:
1. Decide a qué **área** y a qué **departamento** pertenece. Si parece pertenecer a dos áreas, está mal definida o son dos funciones: dilo y detente.
2. Aplica la prueba del núcleo: ¿la necesitan por igual una empresa de servicios de tecnología y una comercializadora? Si solo una por su giro, es satélite: dilo y no la agregues.
3. Abre el archivo del área en `docs/areas/`, busca el número más alto del prefijo y toma el siguiente libre. **Nunca rellenes un hueco ni reutilices una clave.**
4. Propón el nivel (`E`/`P`/`A`) y justifícalo en una línea. Recuerda: nada legalmente obligatorio ni de seguridad base puede salir de `E`.
5. Agrega la fila en la tabla de su departamento, con descripción de una línea en el mismo tono que las demás.
6. Actualiza el resumen por departamento y el total del área, y el total en `docs/areas/00-indice.md` y en `docs/01-alcance.md`.
7. Si la función implica una tarea de construcción, agrégala en la sección de su área en `docs/11-plan-de-construccion.md` con dependencias y criterio de aceptación.
8. Commit: `docs(areas): agregar <CLAVE> <nombre>`, sin código mezclado.

Muestra al final: la clave asignada, el área, el departamento, el nivel y los totales actualizados.
