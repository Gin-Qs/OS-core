# Operaciones y Abastecimiento — 76 funciones

Prefijo `OPE` · claves `OPE-001` a `OPE-076` · esquema de base de datos `operaciones` · 8 departamentos

**Nivel:** `E` Esencial (plan Basic) · `P` Profesional (Pro) · `A` Avanzado (Max). Cada plan incluye los niveles anteriores.

## Cómo se edita este archivo

- Una fila es una función. **Las claves son estables**: se usan en los commits, en el plan de construcción y en las pruebas. No se renumeran ni se reutilizan.
- Para **agregar** una función: se toma el siguiente número libre del área (`OPE-077`), aunque quede al final de la tabla del departamento que le toca.
- Para **quitar** una función: se marca `retirada` en Notas y se deja la fila. Borrarla libera una clave que ya vive en otros documentos.
- Para **mover** una función de nivel: se cambia la columna Nivel. Eso cambia en qué plan aparece, no su clave.
- La columna **Notas** está vacía a propósito: es para decisiones, dudas y recordatorios.

## Resumen por departamento

| Departamento | E | P | A | Total |
|---|---|---|---|---|
| Operaciones | 11 | 4 | 2 | 17 |
| Compras y Abastecimiento | 8 | 6 | 0 | 14 |
| Inventario básico (onboarding) | 4 | 0 | 0 | 4 |
| Calidad | 0 | 6 | 4 | 10 |
| Activos y Mantenimiento | 0 | 8 | 3 | 11 |
| Servicios Generales | 0 | 8 | 0 | 8 |
| Compras Estratégicas | 0 | 0 | 6 | 6 |
| Bienes Raíces Corporativos | 0 | 0 | 6 | 6 |
| **Total** | **23** | **32** | **21** | **76** |

---

## Operaciones (17)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `OPE-001` | Órdenes de trabajo | E | Unidad básica de la operación; los satélites de industria la extienden | |
| `OPE-002` | Plantillas de orden | E | Tipos de orden con sus campos y pasos predefinidos | |
| `OPE-003` | Planeación y agenda | E | Calendario de personas, equipos y recursos | |
| `OPE-004` | Asignación de recursos | E | Quién y con qué se ejecuta cada orden | |
| `OPE-005` | Seguimiento en tiempo real | E | Tablero con el estatus de cada orden | |
| `OPE-006` | Checklists y procedimientos | E | Pasos obligatorios por tipo de orden | |
| `OPE-007` | Evidencias móviles | E | Fotos, firmas y ubicación desde el celular | |
| `OPE-008` | Consumos por orden | E | Materiales, horas y gastos; aquí nace el costo real | |
| `OPE-009` | Incidencias operativas | E | Retrasos, fallas y problemas con responsable | |
| `OPE-010` | Cierre y facturación | E | La orden terminada genera la factura | |
| `OPE-011` | Tablero operativo | E | Cumplimiento, entregas a tiempo y productividad | |
| `OPE-024` | Proyectos | P | Tareas, hitos, dependencias y diagrama de Gantt | |
| `OPE-025` | Capacidad y utilización | P | Cuánto trabajo cabe y qué tan ocupados están los recursos | |
| `OPE-026` | Costo real vs estimado | P | Desviaciones de costo por orden o proyecto | |
| `OPE-027` | Subcontratistas | P | Terceros asignados a órdenes con su costo | |
| `OPE-056` | Programación optimizada | A | La IA propone la mejor asignación de recursos | |
| `OPE-057` | Comparativo multisede | A | Desempeño entre sucursales o centros de operación | |

## Compras y Abastecimiento (14)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `OPE-012` | Proveedores | E | Alta, documentos y opinión de cumplimiento del SAT | |
| `OPE-013` | Requisiciones | E | Solicitud de compra con aprobación | |
| `OPE-014` | Cotizaciones y comparativo | E | Varias cotizaciones de proveedores lado a lado | |
| `OPE-015` | Órdenes de compra | E | Emisión y envío al proveedor | |
| `OPE-016` | Recepción | E | Registro de lo recibido, total o parcial | |
| `OPE-017` | Conciliación de 3 vías | E | Orden de compra vs recepción vs factura; bloquea pagos que no cuadran | |
| `OPE-018` | Precios por proveedor | E | Historial de precios y último costo | |
| `OPE-019` | Devoluciones a proveedor | E | Registro de devoluciones y nota de crédito | |
| `OPE-028` | Presupuesto de compras | P | Gasto por área contra presupuesto | |
| `OPE-029` | Evaluación de proveedores | P | Calificación por precio, calidad y tiempo de entrega | |
| `OPE-030` | Contratos con proveedores | P | Precios pactados y vencimientos | |
| `OPE-031` | Portal de proveedores | P | El proveedor sube facturas y consulta sus pagos | |
| `OPE-032` | Reorden y compras recurrentes | P | Compras automáticas por mínimo o calendario | |
| `OPE-033` | Análisis de gasto | P | En qué, con quién y cuánto se gasta | |

## Inventario básico (onboarding) (4)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `OPE-020` | Existencias | E | Inventario en un almacén (pendiente de confirmar) | |
| `OPE-021` | Entradas y salidas | E | Movimientos por compra, venta y consumo | |
| `OPE-022` | Costo promedio | E | Valuación del inventario para contabilidad | |
| `OPE-023` | Punto de reorden | E | Alerta cuando un artículo llega al mínimo | |

## Calidad (10)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `OPE-034` | Estándares y especificaciones | P | Qué debe cumplir cada producto o servicio | |
| `OPE-035` | Inspecciones | P | Checklists de calidad con resultado | |
| `OPE-036` | No conformidades y acciones correctivas | P | Registro, causa, acción y verificación | |
| `OPE-037` | Documentos del sistema de gestión | P | Control de versiones para ISO 9001 | |
| `OPE-038` | Auditorías internas | P | Programa, hallazgos y cierre | |
| `OPE-039` | Mejora continua | P | Propuestas 5S y Kaizen con seguimiento | |
| `OPE-058` | Calibración de equipos | A | Instrumentos de medición y vencimientos | |
| `OPE-059` | Certificaciones múltiples | A | ISO 14001, 45001 y otras en paralelo | |
| `OPE-060` | Control estadístico | A | Gráficas de control de procesos | |
| `OPE-061` | Costos de calidad | A | Cuánto cuestan los errores y la prevención | |

## Activos y Mantenimiento (11)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `OPE-040` | Registro de activos | P | Etiqueta QR, ubicación y responsable de cada activo | |
| `OPE-041` | Resguardos | P | Qué activo tiene asignado cada empleado | |
| `OPE-042` | Mantenimiento preventivo | P | Programado por fecha o por uso (km, horas) | |
| `OPE-043` | Mantenimiento correctivo | P | Órdenes de reparación | |
| `OPE-044` | Historial y costo por activo | P | Todo lo gastado en cada activo | |
| `OPE-045` | Refacciones | P | Partes para mantenimiento | |
| `OPE-046` | Garantías y seguros | P | Vigencias por activo | |
| `OPE-047` | Talleres y proveedores | P | Quién repara qué y a qué costo | |
| `OPE-062` | Indicadores de confiabilidad | A | MTBF, MTTR y disponibilidad | |
| `OPE-063` | Mantenimiento predictivo | A | Alertas por sensores o telemetría | |
| `OPE-064` | Ciclo de vida y reemplazo | A | Cuándo conviene sustituir un activo | |

## Servicios Generales (8)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `OPE-048` | Instalaciones y espacios | P | Oficinas, sucursales y áreas | |
| `OPE-049` | Solicitudes internas | P | Limpieza, reparaciones o mobiliario | |
| `OPE-050` | Proveedores de servicios | P | Limpieza, vigilancia y sus contratos | |
| `OPE-051` | Servicios y vencimientos | P | Luz, agua, internet y renta con alertas | |
| `OPE-052` | Reserva de salas | P | Salas, equipos y espacios compartidos | |
| `OPE-053` | Vehículos utilitarios | P | Autos administrativos, bitácora y verificaciones | |
| `OPE-054` | Visitantes y accesos | P | Registro de visitas | |
| `OPE-055` | Consumibles | P | Papelería y artículos de oficina | |

## Compras Estratégicas (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `OPE-065` | Categorías de gasto | A | Estrategia por tipo de compra | |
| `OPE-066` | Licitaciones y subastas inversas | A | Concursos entre proveedores | |
| `OPE-067` | Contratos marco | A | Acuerdos por volumen a largo plazo | |
| `OPE-068` | Desarrollo y riesgo de proveedores | A | Dependencia, riesgo y planes de desarrollo | |
| `OPE-069` | Ahorros medidos | A | Ahorro logrado contra precio anterior | |
| `OPE-070` | Abastecimiento internacional | A | Proveedores en el extranjero | |

## Bienes Raíces Corporativos (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `OPE-071` | Portafolio de inmuebles | A | Inmuebles propios y rentados con sus datos | |
| `OPE-072` | Arrendamientos | A | Vencimientos, incrementos y renovaciones | |
| `OPE-073` | Evaluación de ubicaciones | A | Análisis para abrir sucursales o plantas | |
| `OPE-074` | Obras y adecuaciones | A | Proyectos de remodelación | |
| `OPE-075` | Costo de ocupación | A | Costo por metro cuadrado por sede | |
| `OPE-076` | Predial y obligaciones | A | Pagos y trámites inmobiliarios | |

---

## Micro apps del área

- **E:** Costo por orden · Capacidad de atención · Comparador de cotizaciones · Punto de reorden y stock de seguridad · Conversor de unidades
- **P:** Lote económico de compra · Costo total de propiedad (TCO) · MTBF/MTTR
- **A:** Costo de ocupación por m2

Las micro apps son calculadoras independientes: no escriben en la base de datos de negocio, solo leen parámetros vigentes. No llevan clave porque no son funciones del catálogo.

## Agentes de IA del área

- **E:** Compras (detecta compras sin OC y precios fuera de rango)
- **P:** Planeación (asignaciones) · Mantenimiento (vencimientos y fallas) · Calidad (patrones de no conformidades)

Todo agente hereda los permisos del usuario que lo invoca. Un agente nunca ve lo que su usuario no puede ver.

## Reglas del área

- Operaciones es el contenedor universal: la **orden de trabajo** (`OPE-001`) es la entidad que los satélites de industria extienden más adelante. Se diseña genérica desde el principio.
- El inventario básico es condicional: se activa solo si la empresa maneja bienes físicos.
- Multi-almacén, lotes, caducidades y logística no están aquí: son el paquete "Inventarios y Cadena de Suministro".
