Revisa la coherencia de un área del catálogo.

Argumento: el nombre del área (Finanzas, Personas, Comercial, Operaciones, Legal, Dirección, Tecnología).

Verifica y reporta:
1. **Claves**: consecutivas, sin huecos, sin repetidas, todas con el prefijo del área.
2. **Cuentas**: el resumen por departamento coincide con las filas reales; el total del área coincide con `docs/areas/00-indice.md` y con `docs/01-alcance.md`.
3. **Niveles**: ninguna función legalmente obligatoria ni de la línea base de seguridad quedó fuera de `E`.
4. **Pertenencia**: ninguna función del área sirve solo a una industria (sería satélite); ninguna duplica una función de otra área.
5. **Descripciones**: una línea, mismo tono, sin nombres de producto ni de proveedor.
6. **Plan**: toda función con tarea en `docs/11-plan-de-construccion.md` existe en el catálogo, y toda tarea apunta a claves reales.

Reporta solo lo que está mal, con la línea exacta. Si todo está bien, dilo en una frase.
