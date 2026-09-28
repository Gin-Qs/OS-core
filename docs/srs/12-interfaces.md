## 12. Interfaces

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`) son estables y se referencian entre documentos.

### 12.1 Interfaz de usuario

**Navegación.** El menú lateral se arma con la intersección de lo contratado y lo que permite el rol; lo que un usuario no puede usar, no aparece. La estructura completa de pantallas por área está en `docs/10-pantallas.md`.

**Principios obligatorios de la interfaz:**

| # | Principio | Verificación |
|---|---|---|
| 1 | Una acción que el rol no permite no se muestra — y aun así se verifica en el servidor | `RNF-055` |
| 2 | Todo error nombra el campo, la causa y la acción correctiva | `RNF-082` |
| 3 | Toda acción irreversible pide confirmación que describe lo que ocurrirá | `RNF-083` |
| 4 | Todo listado permite filtrar, ordenar y exportar dentro de los permisos del usuario | `RF-030` |
| 5 | Todo documento muestra su estado con color y texto consistentes en todo el sistema | `RNF-088` |
| 6 | Toda pantalla de captura de campo funciona en 360 px y sin conexión | `RNF-087`, `RNF-045` |
| 7 | Ningún número de un tablero se captura a mano; cada uno navega a su origen | `RF-210` |

**Componentes reutilizables obligatorios:** tabla con filtros y exportación · formulario con validación declarativa · ficha con pestañas · tablero kanban · calendario de recursos · línea de tiempo de eventos y bitácora · visor de archivos · selector de catálogos del SAT · captura de foto, firma y ubicación · tarjetas de indicador · barra de aprobación.

#### 12.1.1 Los cinco patrones de pantalla

El sistema tiene unas 120 pantallas (`docs/10-pantallas.md`). **Todas son uno de estos cinco patrones con datos distintos.** No existe un sexto: si una pantalla no encaja, se replantea la pantalla, no se inventa un patrón.

Esta es la regla que evita que 402 funciones construyan 402 tablas ligeramente distintas.

| Patrón | Para qué | Qué incluye siempre |
|---|---|---|
| **Lista** | Ver muchos registros y encontrar uno | Filtros persistentes en la dirección web, orden por columna, paginación, exportación según permisos, acción primaria arriba a la derecha, selección múltiple donde haya acciones por lote |
| **Ficha** | Ver y editar un registro y todo lo que cuelga de él | Encabezado con identificador y estado, pestañas para lo relacionado, línea de tiempo de eventos y bitácora, acciones según el estado y el rol, archivos adjuntos |
| **Captura** | Crear o editar | Validación declarativa al salir de cada campo, errores que nombran campo y causa, guardado explícito, aviso al salir con cambios sin guardar, borrador donde el documento lo permita |
| **Tablero** | Decidir de un vistazo | Indicadores con su periodo y su comparación, **todo número navega a su origen** (`RF-210`), sin captura manual, actualización visible |
| **Asistente** | Procesos de varios pasos con orden obligado | Pasos numerados con su estado, criterio de avance explícito por paso, posibilidad de volver sin perder lo capturado. Usado en cierre de periodo, nómina y configuración inicial |

**Consecuencia para la construcción:** el paquete que implementa la pantalla de clientes y el que implementa la de proveedores usan el mismo patrón *Lista* y el mismo componente. El segundo cuesta una hora, no un día. Un paquete que construya su propia tabla en vez de usar el patrón es un defecto de revisión, no una preferencia de estilo.

#### 12.1.2 Los cuatro estados de toda pantalla

Una pantalla no está terminada cuando muestra datos. Está terminada cuando resuelve **los cuatro estados**, y esto es verificable en revisión:

| Estado | Qué debe mostrar | Por qué importa |
|---|---|---|
| **Cargando** | Estructura de la pantalla con marcadores de posición, nunca una pantalla en blanco | Una pantalla vacía durante un segundo se lee como un error |
| **Vacío** | Qué es esta pantalla, por qué no hay nada, y la acción para empezar | *"Aún no hay facturas — emite la primera"* contra un recuadro en blanco es la diferencia entre un sistema terminado y uno roto |
| **Error** | Qué falló, si el usuario puede hacer algo, y cómo reintentar. Nunca un código crudo | `RNF-082`, `RNF-089` |
| **Con datos** | El contenido | — |

**El estado vacío es el que más se olvida y el que más comunica.** En un sistema de negocio, el usuario ve pantallas vacías durante toda su primera semana.

#### 12.1.3 Identidad visual: una sola costura

La identidad de marca —color, tipografía, logotipo, tono— **está en definición y se integrará cuando esté lista**. Para que esa integración sea un cambio de un archivo y no una reescritura, el sistema se construye desde hoy bajo esta regla:

| # | Regla | Verificación |
|---|---|---|
| 1 | **Toda decisión visual vive en el archivo de tokens**: color, tipografía, escala de espaciado, radios, sombras, duración de transiciones | Análisis estático: ningún valor de color ni familia tipográfica fuera del archivo de tokens. Falla la compilación |
| 2 | Ningún componente incrusta un valor visual; solo referencia tokens | Igual que arriba |
| 3 | Los tokens tienen **significado, no apariencia**: `--color-peligro`, no `--color-rojo`; `--tipo-dato`, no `--fuente-mono` | Revisión. Un token nombrado por su color se vuelve mentira el día que cambia |
| 4 | Modo claro y modo oscuro salen de los mismos tokens, no de dos hojas de estilo | Revisión visual en ambos modos |
| 5 | Mientras la marca no exista, los tokens toman **valores neutros deliberados**: grises, un acento sobrio, tipografía de sistema. Nunca valores "provisionales" que nadie documentó | El archivo de tokens declara su estado: `neutro` o `marca` |

**Cuando la marca esté lista**, se sustituyen los valores del archivo de tokens y, si hace falta, se agregan los que la marca introduzca. El código de los componentes no se toca. Ese es todo el trabajo de integración, y es deliberado: `RNF-088`.

#### 12.1.4 Nivel de acabado exigible

No todo momento del proyecto exige el mismo acabado. Lo que **siempre** se exige, desde la primera pantalla:

| Siempre | Hasta que la marca exista, no se construye |
|---|---|
| Espaciado consistente, salido de la escala | Ilustraciones y gráficos de marca |
| Jerarquía tipográfica clara: se distingue título, dato y apoyo | Animaciones y microinteracciones |
| Los cuatro estados de §12.1.2 | Iconografía propia |
| **Cifras alineadas a la derecha con numeración tabular**: en una columna de importes, los dígitos deben alinearse verticalmente | Páginas de presentación o mercadotecnia |
| Contraste suficiente para lectura prolongada | Tipografía de pago |
| Foco visible y navegación por teclado en formularios | Temas por empresa cliente |

La numeración tabular parece un detalle menor y no lo es: **es lo que hace que una columna de dinero se vea profesional o se vea rota**, y cuesta una línea de estilo.

---

### 12.2 Interfaz de programación (API)

| Aspecto | Especificación |
|---|---|
| Estilo | REST sobre HTTPS, con cuerpos en JSON |
| Autenticación | Llave de API por empresa, con alcance limitado por recurso y acción |
| Autorización | La llave hereda un rol; aplican exactamente las mismas reglas de permiso y aislamiento que a un usuario |
| Versionado | Versión en la ruta. Una versión se mantiene al menos 12 meses tras publicarse su sucesora |
| Límites de consumo | Por llave y por periodo, configurables; el exceso devuelve un código explícito, no un fallo genérico |
| Idempotencia | Toda operación de escritura acepta una clave de idempotencia; repetirla no duplica |
| Errores | Código, mensaje legible y campo afectado. Nunca un mensaje genérico |
| Documentación | Especificación abierta, generada desde el código, siempre sincronizada |
| Webhooks salientes | Eventos seleccionados, firmados, con reintentos y registro de entrega |

### 12.3 Interfaces con sistemas externos

Cada una vive detrás de un adaptador cuya interfaz la define el sistema, no el proveedor (`RE-10`).

| Sistema | Operaciones | Modo | Datos que cruzan |
|---|---|---|---|
| **PAC** | `timbrar`, `cancelar`, `consultarEstado` | API del proveedor, con ambiente de pruebas | Sale: comprobante. Entra: XML timbrado, UUID, acuses |
| **SAT — descarga masiva** | `solicitar`, `verificar`, `descargar` | Vía proveedor (`ADR-0003`); tarea diaria | Entra: XML de comprobantes emitidos y recibidos |
| **SAT — catálogos y listas** | `actualizarCatalogos`, `consultar69B`, `opinionCumplimiento` | Descarga periódica | Entra: catálogos vigentes, lista de contribuyentes, opinión |
| **Bancos** | `importarEstadoCuenta`, `generarLayoutPagos` | Archivos, con analizador por banco | Entra: movimientos. Sale: layout de dispersión |
| **IMSS / INFONAVIT** | `generarArchivoMovimientos`, `generarArchivoCuotas` | Archivos para carga manual en los portales | Sale: movimientos afiliatorios y determinación de cuotas |
| **Correo** | `enviar` | Proveedor transaccional | Sale: facturas con XML y PDF, recordatorios, alertas, reportes |
| **Mensajería y automatización** | Webhooks salientes | Opcional, desactivado por defecto | Sale: eventos seleccionados |

**Reglas comunes a toda integración:**

1. La interfaz se define desde las necesidades del sistema, nunca copiando la API del proveedor.
2. Las credenciales viven en bóveda; en las tablas queda solo la referencia.
3. Todo webhook entrante se valida por firma y es idempotente.
4. Todo error del proveedor se guarda con su código y mensaje originales.
5. Todo adaptador tiene un modo de prueba que no toca el sistema real.

### 12.4 Interfaces de archivo

| Archivo | Dirección | Formato | Regla |
|---|---|---|---|
| Estado de cuenta bancario | Entrada | CSV, XLSX o TXT, según banco | Analizador por banco; importación idempotente por identificador de movimiento |
| Layout de dispersión | Salida | El del banco | Se genera desde pagos autorizados; nunca desde captura libre |
| Movimientos afiliatorios | Salida | El del portal del IMSS | Validado contra el formato vigente |
| Determinación de cuotas | Salida | El del sistema de autodeterminación | Cifras cuadradas contra la nómina del periodo |
| Contabilidad electrónica | Salida | XML del Anexo 24 | Validado contra el esquema oficial antes de entregarse |
| DIOT | Salida | El formato vigente | Generado desde CFDI recibidos pagados |
| Exportación del cliente | Salida | CSV y JSON, más los archivos originales | Completa, sin intervención del proveedor (`RNF-075`) |

---

---

[← 11-comportamiento-del-sistema](./11-comportamiento-del-sistema.md) · [Índice](./00-indice.md) · [13-escalabilidad-y-evolucion →](./13-escalabilidad-y-evolucion.md)
