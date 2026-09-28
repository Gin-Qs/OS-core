## 15. Riesgos

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`) son estables y se referencian entre documentos.

> El **Anexo E** reúne estos riesgos con los de la instalación compartida (Anexo C) en un solo mapa, ordenados por reversibilidad, y agrega el procedimiento de respuesta para el día en que alguno se materializa.

| ID | Riesgo | Probabilidad | Impacto | Mitigación prevista | Señal de alerta temprana |
|---|---|---|---|---|---|
| `RI-01` | Las reglas contables resultan equivocadas y se descubre en el primer cierre | Media | Alto: hay que rehacer registros | Las reglas son datos, no código: se corrigen y se recalcula. Validación del contador **antes** de construir el motor | El contador no ha firmado los casos dorados y ya se está programando |
| `RI-02` | El alcance se desborda: se agregan funciones fuera del plan | **Alta** | Alto: el sistema nunca se termina | Catálogo cerrado con claves; ninguna función se construye si no está en el plan | Aparecen commits con funciones que no tienen clave |
| `RI-03` | El PAC elegido no cubre todos los complementos necesarios | Media | Medio: cambiar de proveedor a medio camino | El PAC vive tras un adaptador; se verifica la cobertura antes de contratar | La lista de complementos del proveedor no incluye alguno necesario |
| `RI-04` | El SAT cambia versiones o formatos durante la construcción | Media | Medio | Parámetros con vigencia y adaptadores; nunca valores en código | Publicación de una versión nueva del anexo correspondiente |
| `RI-05` | Construir solo, con IA, produce deriva de arquitectura | **Alta** | Alto: el sistema se vuelve inmantenible | Fronteras verificadas automáticamente; este SRS como punto fijo; ADR para toda desviación | La verificación de fronteras se desactiva "temporalmente" |
| `RI-06` | La nómina resulta más compleja de lo estimado | Media | Alto: es la función con más casos particulares | Casos dorados firmados; operación en paralelo dos periodos antes de confiar | Diferencias recurrentes en la revisión de prenómina |
| `RI-07` | Los saldos iniciales se cargan mal | Media | **Muy alto**: toda la contabilidad hereda el error | El paso 8 de `P-11` es bloqueante: la balanza inicial debe coincidir al centavo | Se propone "ajustar la diferencia después" |
| `RI-08` | El usuario de campo no adopta la PWA | Media | Alto: sin datos de campo no hay costo real | Diseño de 8 toques; funcionamiento sin conexión; prueba con usuario real antes de liberar | La captura de campo se sigue haciendo por mensajería |
| `RI-09` | Una fuga de datos entre empresas | Baja | **Muy alto**: pérdida de confianza irreparable | Cinco capas independientes de control; pruebas de aislamiento por módulo | Aparece una consulta que desactiva el filtro por empresa |
| `RI-10` | Dependencia de un proveedor de infraestructura | Media | Medio | PostgreSQL estándar; exportación completa bajo demanda | Uso de funciones propietarias sin equivalente estándar |
| `RI-11` | El costo de operación crece más rápido que los ingresos | Media | Medio | Medición desde el primer mes de timbres, almacenamiento y consumo de IA | Costo por empresa creciendo sin relación con su uso |
| `RI-12` | La validación del contador se retrasa y bloquea la construcción | Media | Medio | Construir el motor contra reglas provisionales marcadas como tales, y la carga del catálogo al final | El catálogo de cuentas lleva semanas sin revisión |
| `RI-13` | Una migración deja fuera a todos los clientes a la vez | Media | Alto: caída simultánea en horario hábil | Expandir y contraer en dos despliegues; tiempo límite de bloqueo en cada migración; prueba contra copia del tamaño de producción (`C.6.2`) | Una migración con `DROP` o `RENAME`; código y migración en el mismo despliegue |
| `RI-14` | Un cliente grande degrada el servicio de los demás | Media | Medio | Todo índice encabezado por `empresa_id`; cola por turnos entre empresas; límites de consumo (`C.6.2`) | Latencia p95 sube con tráfico plano; una empresa concentra más del 30% de las filas |
| `RI-15` | Hay que restaurar los datos de un solo cliente y el respaldo devuelve a todos | Media | **Muy alto**: los demás pierden un día de trabajo | Papelera con retención de 30 días; exportación lógica diaria por empresa; simulacro trimestral de restauración (`C.6.2`, `C.8`) | Un cliente pregunta si algo se puede deshacer; el procedimiento de restauración nunca se ha ejecutado |
| `RI-16` | Una definición de cálculo equivocada se publica a todo un régimen | Baja | **Muy alto**: varias empresas declaran mal el mismo mes | Casos dorados firmados como condición de activación (`RF-056`); recálculo de regresión contra periodos cerrados; la versión anterior queda intacta | Una definición se activa sin firma; un caso dorado se "ajusta" para que pase |

---

---

[← 14-calidad-y-pruebas](./14-calidad-y-pruebas.md) · [Índice](./00-indice.md) · [16-decisiones-abiertas →](./16-decisiones-abiertas.md)
