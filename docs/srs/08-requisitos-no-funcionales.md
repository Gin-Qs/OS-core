## 8. Requisitos no funcionales

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`) son estables y se referencian entre documentos.

Cada requisito no funcional lleva un número. Las palabras "rápido", "seguro" o "escalable" no aparecen sin su traducción medible, porque no se pueden verificar.

### 8.1 Rendimiento

Los umbrales se miden en el percentil 95 de las peticiones, con la base de datos cargada al volumen de `RNF-030`, desde una conexión de 10 Mbps.

| ID | Requisito | Umbral | Cómo se mide |
|---|---|---|---|
| `RNF-010` | Tiempo de carga de una pantalla de captura | ≤ 1.5 s | Métrica de la primera interacción posible |
| `RNF-011` | Tiempo de respuesta de una búsqueda o listado con filtros | ≤ 1.0 s | Registro del servidor, p95 |
| `RNF-012` | Tiempo de guardado de un documento de negocio (cotización, pedido, póliza manual) | ≤ 800 ms sin contar el tiempo del PAC | Registro del servidor, p95 |
| `RNF-013` | Tiempo total de emisión de un CFDI, incluyendo al PAC | ≤ 8 s; si se excede, la interfaz libera al usuario y notifica al terminar | Prueba con PAC de pruebas |
| `RNF-014` | Tiempo de generación de la balanza de comprobación de un mes | ≤ 3 s con 50 000 partidas | Prueba de carga |
| `RNF-015` | Tiempo de cálculo de la nómina de 100 empleados | ≤ 60 s | Prueba de carga |
| `RNF-016` | Tiempo de timbrado de un lote de 100 recibos de nómina | ≤ 10 min, con progreso visible y reintento individual | Prueba con PAC de pruebas |
| `RNF-017` | Latencia entre un evento de negocio y su póliza | ≤ 60 s en operación normal | Diferencia entre marcas de tiempo |
| `RNF-018` | Tiempo de carga del tablero ejecutivo | ≤ 2 s, con datos de antigüedad ≤ 5 min | Métrica de la pantalla |
| `RNF-019` | Tiempo de sincronización de la PWA al recuperar conexión, con 50 registros en cola | ≤ 30 s | Prueba con modo avión |

### 8.2 Capacidad y escalabilidad

| ID | Requisito | Umbral de la primera etapa | Umbral de diseño |
|---|---|---|---|
| `RNF-030` | Volumen soportado sin degradación por empresa | 100 usuarios · 500 CFDI emitidos y 800 recibidos al mes · 100 empleados en nómina · 50 000 partidas contables al mes | 10× lo anterior sin cambio de arquitectura |
| `RNF-031` | Número de empresas en una instancia | 10 | 1 000, con el particionado de §13.3 |
| `RNF-032` | Usuarios concurrentes | 50 | 500 |
| `RNF-033` | Tamaño máximo de un archivo adjunto | 25 MB | Configurable por empresa |
| `RNF-034` | Retención en línea de datos operativos | 5 ejercicios completos | Archivado en frío de lo anterior, sin perder acceso |
| `RNF-035` | El crecimiento de una empresa no **debe** degradar a las demás | Ninguna consulta de una empresa puede consumir recursos ilimitados; existen límites por empresa | Prueba de carga con una empresa dominante |

### 8.3 Disponibilidad y continuidad

| ID | Requisito | Umbral |
|---|---|---|
| `RNF-040` | Disponibilidad mensual del servicio en horario hábil (lunes a viernes, 7:00–21:00, hora del centro de México) | ≥ 99.5% |
| `RNF-041` | Objetivo de punto de recuperación (pérdida máxima de datos aceptable) | 24 horas |
| `RNF-042` | Objetivo de tiempo de recuperación | 8 horas |
| `RNF-043` | Respaldo automático de la base de datos y de los archivos | Diario, con retención mínima de 30 días |
| `RNF-044` | Prueba de restauración documentada | Trimestral. Un respaldo no restaurado no cuenta como respaldo |
| `RNF-045` | Operación de campo sin conexión | La PWA opera sin red para consultar sus órdenes, capturar evidencias, consumos e incidencias |
| `RNF-046` | Degradación elegante ante caída de un proveedor externo | La caída del PAC, del SAT, del banco o del correo **no** impide operar el resto del sistema. Cada una tiene su comportamiento definido en §11.7 |
| `RNF-047` | Integridad de la sincronización | Cero pérdidas y cero duplicados tras sincronizar, verificado con prueba de reconexión repetida |

### 8.4 Seguridad

| ID | Requisito | Verificación |
|---|---|---|
| `RNF-050` | Todo el tráfico **debe** viajar cifrado en tránsito | Prueba de configuración; sin puertos sin cifrar |
| `RNF-051` | Todos los datos **deben** estar cifrados en reposo | Configuración del proveedor verificada |
| `RNF-052` | Las credenciales de integración y los certificados **deben** vivir en bóveda cifrada, nunca en tablas ni en variables del código | Auditoría de código y de esquema |
| `RNF-053` | Las contraseñas **deben** almacenarse con función de derivación de clave resistente a fuerza bruta | Revisión de la configuración de autenticación |
| `RNF-054` | El acceso a datos **debe** filtrarse en la base de datos mediante seguridad a nivel de fila, no solo en la aplicación | Prueba: consulta directa con credencial de otro usuario devuelve cero filas |
| `RNF-055` | Toda acción de servidor **debe** verificar permiso antes de ejecutarse | Prueba automatizada por acción; ocultar en la interfaz no es control |
| `RNF-056` | La sesión **debe** expirar por inactividad y poder revocarse centralmente | Prueba de expiración y revocación |
| `RNF-057` | El sistema **debe** impedir que quien captura una operación sea quien la aprueba | Prueba por cada flujo de aprobación |
| `RNF-058` | Un agente de IA **no debe** poder acceder a nada fuera de los permisos de su invocador | Prueba explícita por rol |
| `RNF-059` | El sistema **debe** registrar intentos fallidos de acceso y actividad anómala, y alertar | Simulación de intentos fallidos genera alerta |

### 8.5 Privacidad y protección de datos personales

| ID | Requisito |
|---|---|
| `RNF-060` | El sistema **debe** mantener un inventario de los datos personales que almacena, su finalidad y su tiempo de conservación |
| `RNF-061` | El sistema **debe** permitir atender solicitudes de acceso, rectificación, cancelación y oposición sobre los datos de una persona |
| `RNF-062` | Los datos de salud de empleados (incapacidades, exámenes médicos) **deben** almacenarse separados del expediente general, con acceso restringido al rol Personas |
| `RNF-063` | Los importes salariales individuales **deben** ser inaccesibles para todo rol distinto de Personas y Propietario, incluida Dirección, que accede solo a agregados |
| `RNF-064` | Los datos **deben** residir en una región geográfica declarada, y esa región **debe** informarse al cliente |
| `RNF-065` | Los registros técnicos **no deben** contener datos personales ni financieros: ni CLABE, ni salarios, ni contenido de XML con RFC completo |
| `RNF-066` | Los entornos de desarrollo y pruebas **no deben** contener datos reales de ningún cliente |

### 8.6 Auditoría e integridad

| ID | Requisito | Verificación |
|---|---|---|
| `RNF-070` | Los documentos contables y fiscales **deben** conservarse íntegros al menos 5 años y **no deben** poder eliminarse | Intento de borrado rechazado; prueba de recuperación de un documento de hace 5 años |
| `RNF-071` | El libro contable **debe** encadenarse con hash verificable de principio a fin | Verificación de la cadena completa en cada cierre; cualquier ruptura genera alerta crítica |
| `RNF-072` | La bitácora **debe** ser inmutable y conservar al menos 5 años | Intento de modificación rechazado a nivel de base de datos |
| `RNF-073` | Todo archivo almacenado **debe** guardar su hash de contenido | Verificación de integridad bajo demanda |
| `RNF-074` | El sistema **debe** poder producir un paquete de evidencia de un periodo (pólizas, comprobantes, bitácora, estados financieros) | Generado en menos de 1 hora ante un requerimiento |
| `RNF-075` | El cliente **debe** poder exportar íntegramente sus datos en formato abierto, en cualquier momento | Exportación completa que incluye datos y archivos, sin intervención del proveedor |

### 8.7 Usabilidad y accesibilidad

| ID | Requisito | Verificación |
|---|---|---|
| `RNF-080` | Toda la interfaz **debe** estar en español de México, con terminología del dominio contable y fiscal mexicano | Revisión por el contador |
| `RNF-081` | Un usuario nuevo con rol Comercial **debe** poder emitir su primera cotización sin capacitación previa, siguiendo solo la interfaz | Prueba con un usuario real que no conoce el sistema |
| `RNF-082` | Todo error **debe** indicar qué campo falló, por qué y qué hacer | Ningún mensaje del tipo "ocurrió un error" sin detalle. Revisión de todos los mensajes |
| `RNF-083` | Toda acción destructiva o irreversible **debe** pedir confirmación explícita que nombre lo que se va a hacer | Revisión de cada acción destructiva |
| `RNF-084` | La interfaz de campo (PWA) **debe** permitir completar el registro de una orden en **8 toques o menos** en el caso típico | Conteo en prueba con usuario real |
| `RNF-085` | Los importes **deben** mostrarse con separador de miles y dos decimales; las fechas en formato local; las horas en la zona horaria de la empresa | Revisión de pantallas |
| `RNF-086` | El sistema **debe** cumplir el nivel AA de las pautas de accesibilidad para contenido web en contraste, navegación por teclado y etiquetado de formularios | Auditoría de accesibilidad |
| `RNF-087` | La interfaz **debe** ser utilizable desde 360 px de ancho | Prueba en dispositivo real |
| `RNF-088` | Toda decisión visual —color, tipografía, espaciado, radios, sombras, transiciones— **debe** vivir en un único archivo de tokens con nombres por significado, y ningún componente **debe** incrustar un valor visual | Análisis estático: ningún valor de color ni familia tipográfica fuera del archivo de tokens. Falla la compilación. Integrar una identidad de marca consiste en sustituir valores de ese archivo, sin tocar componentes |
| `RNF-089` | Toda pantalla **debe** resolver sus cuatro estados: cargando, vacío, error y con datos. El estado vacío **debe** explicar qué es la pantalla y ofrecer la acción para empezar | Revisión de diseño por pantalla. Una pantalla sin estado vacío diseñado no se considera terminada (§12.1.2) |

### 8.8 Mantenibilidad y evolución

| ID | Requisito | Verificación |
|---|---|---|
| `RNF-090` | El núcleo **debe** funcionar completo sin ningún satélite ni paquete activo | Prueba de instalación limpia con todo desactivado |
| `RNF-091` | Un satélite **debe** poder construirse sin modificar ninguna tabla del núcleo | Revisión del diff de migraciones al construir el primero. Meta: cero tablas del núcleo alteradas |
| `RNF-092` | Un satélite o paquete **debe** comunicarse exclusivamente por contratos públicos y eventos | Verificación automática de fronteras |
| `RNF-093` | Activar o desactivar un módulo, paquete o satélite **debe** ser una operación de configuración, no un despliegue | Prueba de activación en caliente |
| `RNF-094` | Las fronteras entre módulos **deben** verificarse automáticamente en integración continua | La compilación falla si un módulo importa internals de otro |
| `RNF-095` | La cobertura de pruebas de los motores fiscal, contable y de nómina **debe** ser del 100% de sus reglas | Reporte de cobertura por regla, no por línea |
| `RNF-096` | Todo cambio de regla fiscal, contable o laboral **debe** poder aplicarse cargando parámetros o reglas, sin desplegar código | Prueba: cambio de tasa aplicado sin despliegue |
| `RNF-097` | Toda decisión de arquitectura costosa de revertir **debe** estar registrada en un ADR | Revisión del directorio de decisiones |
| `RNF-098` | El código **debe** nombrar el dominio en español y mantener la correspondencia uno a uno entre área del catálogo, módulo de código y esquema de base de datos | Revisión estructural en cada revisión de código |

### 8.9 Observabilidad y operación

| ID | Requisito |
|---|---|
| `RNF-100` | El sistema **debe** exponer métricas de: eventos en cola, eventos fallidos, timbrados rechazados, tareas programadas no ejecutadas, tiempo de respuesta por pantalla y errores por módulo |
| `RNF-101` | Todo error de un proveedor externo **debe** registrarse con su código y su mensaje original, no como un fallo genérico |
| `RNF-102` | Toda tarea programada **debe** ser idempotente y registrar su ejecución, su duración y su resultado |
| `RNF-103` | El sistema **debe** alertar cuando una tarea programada no se ejecute en su ventana esperada |
| `RNF-104` | Las migraciones de base de datos **deben** ser acumulativas y hacia adelante; una migración aplicada en producción no se edita |
| `RNF-105` | Toda migración que cree una tabla de negocio **debe** crear su política de aislamiento en la misma migración |

### 8.10 Cumplimiento legal

| ID | Requisito |
|---|---|
| `RNF-110` | El sistema **debe** emitir comprobantes conforme a la versión vigente del estándar del SAT, y **debe** poder adoptar una versión nueva mediante configuración y adaptador, sin rediseño |
| `RNF-111` | El sistema **debe** conservar los XML originales tal como fueron timbrados, sin transformarlos |
| `RNF-112` | El sistema **debe** poder demostrar, ante un requerimiento, la integridad y la inalterabilidad de su contabilidad |
| `RNF-113` | El sistema **debe** soportar las obligaciones de conservación, entrega y formato exigidas por la autoridad fiscal mexicana |
| `RNF-114` | Cuando una norma cambie, el sistema **debe** seguir reproduciendo el cálculo de los periodos anteriores con las reglas que estaban vigentes entonces |

---

---

[← 07-requisitos-funcionales](./07-requisitos-funcionales.md) · [Índice](./00-indice.md) · [09-modelo-de-datos →](./09-modelo-de-datos.md)
