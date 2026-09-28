# Anexo E · Mapa de riesgos y resolución

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`, `RI-`) son estables y se referencian entre documentos.

> Este anexo reúne **todos** los riesgos del sistema —los de construcción del §15 y los de la instalación compartida del Anexo C— en un solo mapa, y agrega lo que ninguno de los dos tiene: **qué hacer el día que el riesgo se materializa**.
>
> Un riesgo documentado sin procedimiento de respuesta es un riesgo que, cuando llega, se resuelve improvisando a las tres de la mañana.

---

## E.1 Los dieciséis riesgos, ordenados por lo que cuesta deshacerlos

La pregunta que ordena esta tabla no es "¿qué tan probable es?" sino **"si ocurre, ¿se puede deshacer?"**. Un riesgo probable y reversible es un inconveniente; uno improbable e irreversible es una amenaza existencial.

| Clave | Riesgo | ¿Reversible? | Alcance | Control que lo previene | Dónde se especifica |
|---|---|---|---|---|---|
| `RI-09` | Fuga de datos entre empresas | **No** | Todos los clientes a la vez | RLS forzado, `WITH CHECK`, rol sin `BYPASSRLS`, `empresa_id` desde la sesión | `C.6.2 R1` · §10.8 |
| `RI-16` | Definición de cálculo equivocada publicada a todo un régimen | **Parcialmente**: el cálculo se corrige, la declaración presentada no | Todas las empresas de ese régimen | Casos dorados firmados como condición de activación | `RF-056` · `C.6.2 R6` |
| `RI-07` | Saldos iniciales cargados mal | Sí, pero muy caro: toda la contabilidad hereda el error | Un cliente, todo su historial | Paso bloqueante: la balanza inicial coincide al centavo | `P-11` paso 8 |
| `RI-05` | Deriva de arquitectura al construir con IA | Sí, pero el costo crece cada semana | El producto entero | Fronteras verificadas por herramienta; este SRS como punto fijo; ADR para toda desviación | `ADR-0001` · `CLAUDE.md` |
| `RI-01` | Reglas contables equivocadas descubiertas en el primer cierre | Sí: las reglas son datos, se corrigen y se recalcula | Un cliente, un periodo | Validación del contador **antes** de construir el motor | `RF-121` · doc 07 |
| `RI-15` | Restaurar a un solo cliente y el respaldo devuelve a todos | Sí, si existe la papelera y la exportación por empresa | Todos los clientes, un día de trabajo | Papelera de 30 días; exportación lógica diaria por empresa | `C.6.2 R4` · `C.8` |
| `RI-13` | Una migración deja fuera a todos | Sí, si se hizo en dos pasos. **No**, si eliminó una columna | Todos los clientes, horas | Expandir y contraer; tiempo límite de bloqueo; prueba a escala real | `C.6.2 R2` |
| `RI-02` | El alcance se desborda | Sí, pero solo decidiendo no construir | El calendario del proyecto | Catálogo cerrado con claves; nada se construye sin estar en el plan | §7 · doc 11 |
| `RI-06` | La nómina resulta más compleja de lo estimado | Sí: se ajusta el calendario | Un módulo | Casos dorados firmados; dos periodos en paralelo antes de confiar | `RF-160` a `RF-179` |
| `RI-03` | El PAC no cubre los complementos necesarios | Sí: se cambia de proveedor | Todos los clientes, su facturación | Adaptador; verificación de cobertura antes de contratar | `ADR-0003` · `C.6.2 R7` |
| `RI-08` | El usuario de campo no adopta la PWA | Sí: se rediseña | Un módulo y el costo real | Diseño de 8 toques; sin conexión; prueba con usuario real | `RF-180` a `RF-189` |
| `RI-04` | El SAT cambia versiones durante la construcción | Sí: es una carga de datos | Todos los clientes | Parámetros y definiciones con vigencia; adaptadores | `RF-012` · `ADR-0006` |
| `RI-14` | Un cliente grande degrada a los demás | Sí: límites y, en el extremo, instancia dedicada | Los clientes chicos | Índices encabezados por `empresa_id`; cola por turnos; límites | `C.6.2 R3` · `C.9` |
| `RI-10` | El proveedor de infraestructura suspende el servicio | Sí: días de traslado, si hay copias fuera | Todos los clientes | Pago redundante; alertas; respaldos y repositorio fuera del proveedor | `C.6.2 R8` · `ADR-0005` |
| `RI-11` | El costo de operación crece más rápido que los ingresos | Sí: se ajusta el precio o el consumo | El negocio | Medición por empresa desde el primer mes | `C.6.2 R3` |
| `RI-12` | La validación del contador se retrasa | Sí: se reordena el trabajo | El calendario | Construir contra reglas provisionales marcadas como tales | doc 07 |

**Los cuatro que exigen disciplina desde el primer día**, porque después ya no se arreglan: `RI-09`, `RI-16`, `RI-07` y `RI-05`. Los doce restantes cuestan tiempo o dinero; estos cuatro cuestan el proyecto o la reputación.

---

## E.2 Qué hacer el día que ocurre

Seis procedimientos. Los demás riesgos se resuelven ajustando calendario o precio y no necesitan uno.

### E.2.1 Sospecha de fuga entre empresas (`RI-09`)

**La primera hora decide todo. El orden importa.**

| # | Paso | Por qué en ese orden |
|---|---|---|
| 1 | **Preservar la evidencia antes de tocar nada**: copiar la bitácora y los registros de acceso del periodo sospechoso | Lo primero que destruye una reparación apresurada es la prueba de qué pasó |
| 2 | Determinar el alcance con la bitácora: qué consulta, qué usuario, qué filas, en qué ventana de tiempo | Sin alcance no hay notificación honesta ni reparación dirigida |
| 3 | Cerrar la vía: revocar la sesión, retirar el permiso, desplegar la corrección | Primero se cierra, después se investiga la causa raíz |
| 4 | Verificar con las empresas canario que el aislamiento volvió a funcionar | No se declara resuelto sin prueba |
| 5 | **Notificar a los titulares afectados y evaluar el aviso al INAI**, con el contador y un abogado | La LFPDPPP obliga a informar de forma inmediata las vulneraciones que afecten significativamente los derechos patrimoniales o morales |
| 6 | Escribir el informe: qué pasó, qué datos, a quién, qué se corrigió, qué control nuevo lo impide | Es lo que un cliente necesita para decidir quedarse |
| 7 | Agregar la prueba automática que habría detectado ese caso concreto | Un incidente sin prueba nueva se repite |

**Lo que nunca se hace:** borrar registros "para limpiar", minimizar el alcance sin haberlo medido, o avisar al cliente después de que él lo descubra.

### E.2.2 Una migración dejó el sistema caído (`RI-13`)

| # | Paso |
|---|---|
| 1 | **Revertir el despliegue del código, no la migración.** Si se hizo expandir-y-contraer, el código anterior sigue funcionando contra el esquema nuevo, y esa es toda la razón de hacerlo en dos pasos |
| 2 | Si el código anterior ya no sirve porque la migración eliminó algo: recuperar a un punto en el tiempo **inmediatamente anterior** a la migración, asumiendo la pérdida de los minutos posteriores |
| 3 | Avisar a los clientes con una estimación honesta. Un "estamos trabajando en ello" sin hora es peor que un "vuelve en dos horas" |
| 4 | Reproducir la migración contra una copia del tamaño de producción hasta entender qué la hizo fallar |
| 5 | Reescribirla en dos pasos y volver a intentarla en ventana de mantenimiento |

**La decisión difícil del paso 2:** una migración que eliminó datos no se revierte desplegando; se revierte restaurando, y restaurar cuesta los minutos de trabajo posteriores de **todos** los clientes. Por eso la regla de nunca eliminar en el mismo despliegue no es una recomendación.

### E.2.3 Una definición de cálculo salió equivocada (`RI-16`)

| # | Paso |
|---|---|
| 1 | **Desactivar la versión**: la anterior queda vigente para los periodos que le correspondían. No se reprograma nada |
| 2 | Identificar el alcance exacto: cada ejecución guarda qué versión usó (`RF-057`), así que la lista de empresas y periodos afectados es una consulta, no una investigación |
| 3 | Recalcular con la definición corregida y comparar el papel de trabajo viejo contra el nuevo, empresa por empresa |
| 4 | **Avisar al cliente y a su contador antes de que lo descubra el SAT**, con la diferencia exacta y el papel de trabajo de ambas versiones |
| 5 | Acompañar la declaración complementaria donde haya que presentarla |
| 6 | Agregar el caso que falló al conjunto de casos dorados, firmado, para que ninguna versión futura pueda activarse sin pasarlo |

**El costo real no es técnico**, es que tu cliente presentó mal por tu causa. Por eso el paso 4 no se pospone.

### E.2.4 El PAC está caído (`RI-07` del anexo C, `RI-03`)

| # | Paso |
|---|---|
| 1 | Los comprobantes entran a la cola de reintento; **no se pierden y no se marcan como fallidos ante el usuario** |
| 2 | Aviso automático a los clientes afectados: "el timbrado está en espera, tus comprobantes se enviarán solos". Que no se enteren por su propio fracaso |
| 3 | Si la interrupción supera el umbral acordado, **conmutar al segundo PAC** — que es un cambio de configuración, no un despliegue |
| 4 | Al restablecerse, verificar que ningún comprobante quedó duplicado: la idempotencia del bus lo cubre, y se confirma |

### E.2.5 Un cliente necesita que le restauren sus datos (`RI-15`)

| # | Paso |
|---|---|
| 1 | **Primero la papelera.** Nueve de cada diez casos se resuelven aquí, en minutos, y el propio cliente puede hacerlo |
| 2 | Si no alcanza: tomar la exportación lógica de esa empresa del día anterior |
| 3 | Restaurarla en el entorno de desarrollo y **verificar con el cliente que es el estado que quiere** antes de tocar producción |
| 4 | Reimportar solo las entidades afectadas, dentro de la transacción y respetando la inmutabilidad del libro contable: lo contable se corrige con pólizas, nunca sobrescribiendo (`RF-042`) |
| 5 | Nunca restaurar el respaldo general por un solo cliente: eso castiga a los demás por un problema que no tuvieron |

### E.2.6 El proveedor suspendió el servicio (`RI-10`)

| # | Paso |
|---|---|
| 1 | Resolver lo administrativo primero: casi siempre es una tarjeta, no una decisión |
| 2 | En paralelo, avisar a los clientes. Este es el incidente que más daña la confianza si se calla |
| 3 | Si la suspensión no se levanta: levantar la base desde la copia externa en otro proveedor de PostgreSQL y apuntar la aplicación ahí |
| 4 | La aplicación se reconstruye desde el repositorio en cualquier sitio que ejecute Node |
| 5 | Después: método de pago redundante y alertas, que es lo que debió existir desde el principio |

---

## E.3 El tablero: las señales que se vigilan solas

Un riesgo se atiende barato cuando se ve venir. Estas son las señales que el sistema debe vigilar **sin que nadie se acuerde de revisarlas**, con el riesgo que anticipan.

| Señal | Umbral de alerta | Anticipa |
|---|---|---|
| Tabla de negocio sin política de aislamiento | Cualquiera. Falla la compilación | `RI-09` |
| Prueba de empresa canario que ve filas ajenas | Una sola fila | `RI-09` |
| Acción de servidor que recibe `empresa_id` del cliente | Cualquiera. Falla la revisión | `RI-09` |
| Literal con identificador de cliente en el código | Cualquiera. Falla la compilación | `RI-02` |
| Definición de cálculo activada sin casos dorados firmados | Cualquiera. Se rechaza la activación | `RI-16` |
| Recálculo de regresión con diferencia contra un periodo cerrado | Un centavo | `RI-16` |
| Duración de una migración en la prueba a escala real | Más de 5 segundos | `RI-13` |
| Latencia p95 por empresa | Por encima de lo comprometido en §8 | `RI-14` |
| Participación de una empresa en filas, almacenamiento o peticiones | Más del 30% | `RI-14` |
| Rezago de la cola de eventos | Creciente entre picos sucesivos | `RI-14` |
| Exportación diaria por empresa ausente o vacía | Cualquiera | `RI-15` |
| Tasa de error de timbrado | Por encima de lo normal del día | `RI-03` |
| Timbres disponibles y vigencia del CSD | 30 días de anticipación | `RI-03` |
| Consumo contra los límites del plan del proveedor | 80% | `RI-10` |
| Costo por empresa contra su uso | Divergencia sostenida | `RI-11` |
| Verificación de fronteras entre módulos desactivada | Cualquiera | `RI-05` |
| Función construida sin clave del catálogo | Cualquiera | `RI-02` |

**La mitad de esta tabla vive en la compilación, no en un tablero.** Un control que depende de que alguien recuerde mirar una pantalla no es un control; es una intención.

---

## E.4 Revisión periódica

| Cadencia | Qué se revisa | Riesgos |
|---|---|---|
| **Cada despliegue** | Fronteras, aislamiento, ausencia de identificadores de cliente, duración de migraciones | `RI-09`, `RI-05`, `RI-02`, `RI-13` |
| **Diario, automático** | Empresas canario, exportaciones por empresa, colas, errores de timbrado | `RI-09`, `RI-15`, `RI-03` |
| **Mensual** | Consumo y costo por empresa contra ingresos; límites del proveedor | `RI-11`, `RI-14`, `RI-10` |
| **Trimestral** | **Simulacro de restauración de una empresa**; revisión de la matriz de riesgos completa | `RI-15`, todos |
| **Anual, o al cambiar la ley** | Definiciones de cálculo, parámetros, catálogos del SAT, con el contador | `RI-16`, `RI-04`, `RI-01` |

Este anexo se revisa **cada trimestre y después de cada incidente**. Un riesgo que se materializó y no dejó una señal nueva en `E.3` ni un paso nuevo en `E.2` es un incidente del que no se aprendió.

---

## E.5 Resumen en cinco frases

1. **Lo que ordena la prioridad no es la probabilidad, es la reversibilidad.** Cuatro riesgos no se deshacen: `RI-09`, `RI-16`, `RI-07` y `RI-05`.
2. **Cada riesgo tiene prevención, detección y contención.** Con solo prevención, te enteras tarde.
3. **La mitad de los controles vive en la compilación**, no en un tablero que alguien debe recordar mirar.
4. **Todo incidente que alcance a un cliente se le informa antes de que él lo descubra.** En fuga de datos y en cálculo fiscal equivocado, eso no es cortesía: es obligación legal.
5. **Un procedimiento de respuesta nunca ejecutado no es un control, es un documento.** Por eso el simulacro trimestral.

---

---

[← D · Plano de operación](./21-plano-de-operacion.md) · [Índice](./00-indice.md) · [Cierre →](./99-cierre.md)
