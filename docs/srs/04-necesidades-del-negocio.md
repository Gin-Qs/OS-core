## 4. Necesidades del negocio

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`) son estables y se referencian entre documentos.

### 4.1 Quién es el cliente

**Cliente objetivo:** empresa mexicana —persona moral o persona física con actividad empresarial— de 10 a 100 empleados, con contador externo o un contador interno, que ya factura electrónicamente y que ha superado el punto en que una hoja de cálculo alcanza.

| Característica | Valor típico | Por qué importa para el diseño |
|---|---|---|
| Empleados | 10 a 100 | Define la escala de nómina y el número de usuarios concurrentes |
| Facturas emitidas al mes | 20 a 500 | Define el volumen de CFDI y de conciliación |
| Facturas recibidas al mes | 50 a 800 | Define el volumen de la descarga masiva y de la DIOT |
| Régimen fiscal | **Cualquiera de los cuatro regímenes soportados** (§3.4). El más común en el cliente objetivo es el general de personas morales | Define la base de acumulación —devengado o flujo—, el cálculo de ISR y las obligaciones informativas |
| Quién lleva la contabilidad | Despacho externo, con retraso de 30 a 60 días | Es el dolor central: la dirección decide con datos viejos |
| Sucursales | 1 a 5 | Define la necesidad de centros de costo y de sucursal en el modelo |
| Madurez tecnológica | Baja a media. Usan correo, hoja de cálculo y mensajería | Define el nivel de simplicidad exigible a la interfaz |

**Clasificación oficial de referencia.** La estratificación publicada en el DOF el 30 de junio de 2009 calcula un puntaje combinando trabajadores (10%) y ventas anuales (90%). El cliente objetivo cae en **pequeña y mediana empresa**. Esa estratificación se usa en el sistema para sugerir el plan durante la configuración inicial, nunca para restringir funciones (`RF-006`).

### 4.2 Objetivos del negocio

Los objetivos del negocio son los del cliente que compra el sistema, no los del producto. Cada uno se conecta con procesos y requisitos verificables.

| # | Objetivo de negocio | Situación actual típica | Meta | Cómo se mide en el sistema | Procesos que lo sirven |
|---|---|---|---|---|---|
| `OB-01` | **Saber cuánto gana realmente la empresa, hoy** | Estado de resultados con 30–60 días de retraso | Estado de resultados disponible en cualquier momento, con el dato del día | Antigüedad del último asiento respecto a hoy | `P-01`, `P-02`, `P-06` |
| `OB-02` | **Cobrar más rápido** | Se cobra tarde porque nadie lleva la antigüedad | Reducir los días de cobranza (DSO) en 20% en 6 meses | `v_cxc_antiguedad` y DSO calculado mensualmente | `P-01`, `P-07` |
| `OB-03` | **No pagar multas ni perder deducciones** | Obligaciones que se recuerdan por calendario personal; gastos que se pierden | Cero obligaciones fuera de plazo; 100% de CFDI recibidos clasificados antes del cierre | Calendario fiscal con estado; conciliación CFDI vs contabilidad | `P-02`, `P-06` |
| `OB-04` | **Saber si cada trabajo fue rentable** | Se sabe el ingreso, no el costo real de ejecutarlo | Margen por orden de trabajo disponible al cerrarla | `v_rentabilidad_orden` | `P-03`, `P-01` |
| `OB-05` | **Controlar quién ve y quién autoriza qué** | Todos ven todo, o nadie ve nada, y se autoriza por mensaje | 100% de los pagos sobre umbral con aprobación registrada de un segundo rol | Bitácora de aprobaciones | `P-02`, `P-09` |
| `OB-06` | **Pagar nómina correcta y a tiempo, sin depender de un tercero** | Nómina en despacho externo; errores se descubren tarde | Nómina calculada, timbrada y dispersada desde el sistema, sin ajuste posterior | Recibos timbrados a la primera ÷ total | `P-04` |
| `OB-07` | **Dejar de recapturar** | El mismo dato se escribe en 3 o 4 lugares | Cero recapturas en la cadena cotización → factura → póliza | Auditoría del flujo E2E | `P-01` |
| `OB-08` | **Que nada dependa de la memoria de una persona** | Vencimientos, renovaciones y obligaciones viven en la cabeza de alguien | 100% de vencimientos con alerta automática antes del plazo | Motor de alertas | `P-05`, `P-08` |
| `OB-09` | **Poder demostrar lo que se hizo** | La evidencia está repartida en correos y carpetas | Trazabilidad completa de cualquier operación, con autor y momento | Bitácora y hash del libro contable | `P-09` |
| `OB-10` | **Crecer sin romper el sistema** | Cada empresa nueva o área nueva exige otra herramienta | Alta de una segunda empresa o área sin reprogramar | Alta de empresa sin commits de código | Todos |

### 4.3 Objetivos de los usuarios

Un objetivo de negocio no se cumple solo porque la dirección lo quiera: se cumple si la persona que hace el trabajo diario encuentra el sistema más fácil que su hoja de cálculo. Esta es la traducción por rol.

| # | Actor | Lo que la persona quiere realmente | Lo que odia | Qué le da el sistema | Requisitos |
|---|---|---|---|---|---|
| `OU-01` | Propietario `ACT-01` | Abrir una pantalla y saber si el negocio va bien | Pedir reportes y esperar tres días | Tablero ejecutivo con datos del día y alertas críticas | `RF-210`, `RF-211` |
| `OU-02` | Dirección `ACT-03` | Enterarse de los problemas antes de que sean caros | Enterarse cuando ya no hay remedio | Alertas por umbral, aprobaciones en bandeja, reporte automático | `RF-211`, `RF-152` |
| `OU-03` | Tesorería `ACT-04` | Saber exactamente qué entra y qué sale esta semana | Conciliar a mano línea por línea | Flujo a 13 semanas, conciliación automática por referencia e importe | `RF-145`, `RF-147` |
| `OU-04` | Contabilidad `ACT-05` | Cerrar el mes sin perseguir a nadie | Capturar pólizas una por una; descubrir un gasto sin factura en el día 28 | Pólizas automáticas, conciliación CFDI vs contabilidad, checklist de cierre | `RF-121`, `RF-141`, `RF-130` |
| `OU-05` | Personas `ACT-06` | Correr la nómina y que salga bien a la primera | Recalcular por una incidencia capturada tarde | Incidencias capturadas por el propio empleado y aprobadas por su jefe, prenómina revisable | `RF-162`, `RF-164` |
| `OU-06` | Comercial `ACT-07` | Cotizar rápido y facturar sin pedir favores | Esperar a que administración facture | Cotización → pedido → factura sin recaptura, con permiso acotado | `RF-102`, `RF-104`, `RF-116` |
| `OU-07` | Operaciones `ACT-08` | Saber qué hay que hacer hoy, con qué y con quién | Descubrir a media ejecución que falta un recurso | Agenda de recursos, asignación con validación de disponibilidad y vigencias | `RF-182`, `RF-186` |
| `OU-08` | Campo `ACT-09` | Registrar lo que hizo en tres toques y sin señal | Formularios largos; perder lo capturado por falta de red | PWA con captura mínima, cámara, cola sin conexión | `RF-014`, `RF-185` |
| `OU-09` | Colaborador `ACT-10` | Bajar su recibo y pedir vacaciones sin preguntarle a nadie | Pedir por WhatsApp y que se olvide | Espacio del Colaborador con recibos, solicitudes y su estado | `RF-236`, `RF-237` |
| `OU-10` | Administrador `ACT-02` | Dar y quitar accesos sin equivocarse | Descubrir que un ex empleado sigue entrando | Consola de usuarios y roles, revocación ligada a la baja | `RF-004`, `RF-009` |
| `OU-11` | Contador externo `ACT-05` | Recibir la información completa y cuadrada | Pedir por correo lo que falta, tres veces | Acceso de solo lectura con exportación de balanza, pólizas y papeles | `RF-124`, `RNF-075` |

### 4.4 Criterios de éxito del producto

El sistema se considera exitoso cuando, sobre una empresa real, se cumplen simultáneamente:

| # | Criterio | Umbral | Momento de medición |
|---|---|---|---|
| `CE-01` | Un mes calendario completo opera dentro del sistema sin hoja de cálculo paralela | 1 mes | Primer cierre |
| `CE-02` | Las cifras de IVA, ISR y DIOT del sistema coinciden con lo presentado ante el SAT | Diferencia = 0 | Primer cierre |
| `CE-03` | La balanza del sistema coincide con la del contador | Diferencia = 0 | Primer y segundo cierre |
| `CE-04` | Toda la nómina del periodo se timbra desde el sistema sin ajuste manual posterior | 100% de recibos | Primera nómina |
| `CE-05` | Al menos el 80% de los empleados usa su espacio al menos una vez al mes | 80% | Tercer mes |
| `CE-06` | Ningún usuario ve datos que su rol no permite | 0 incidencias | Prueba de seguridad previa a producción |
| `CE-07` | Ninguna póliza fue alterada después de registrarse | 0 | Verificación de hash, cada cierre |

### 4.5 Trazabilidad: objetivo de negocio → proceso → requisito

Ninguna función existe porque sí. Esta matriz es la prueba.

| Objetivo | Procesos | Casos de uso principales | Requisitos funcionales núcleo |
|---|---|---|---|
| `OB-01` | `P-01`, `P-02`, `P-06` | `CU-020`, `CU-030`, `CU-040` | `RF-121`, `RF-122`, `RF-126`, `RF-130` |
| `OB-02` | `P-01`, `P-07` | `CU-023`, `CU-024` | `RF-142`, `RF-143`, `RF-144` |
| `OB-03` | `P-02`, `P-06` | `CU-031`, `CU-041` | `RF-131` a `RF-141` |
| `OB-04` | `P-03`, `P-01` | `CU-050`, `CU-055` | `RF-184`, `RF-188`, `RF-155` |
| `OB-05` | `P-02`, `P-09` | `CU-033`, `CU-011` | `RF-005`, `RF-007`, `RF-152` |
| `OB-06` | `P-04` | `CU-060` a `CU-064` | `RF-160` a `RF-175` |
| `OB-07` | `P-01` | `CU-020` a `CU-022` | `RF-102`, `RF-104`, `RF-116` |
| `OB-08` | `P-05`, `P-08` | `CU-070`, `CU-071` | `RF-025`, `RF-026`, `RF-207` |
| `OB-09` | `P-09` | `CU-012` | `RF-024`, `RF-123`, `RNF-070` |
| `OB-10` | Todos | `CU-001` | `RF-001`, `RF-002`, `RNF-090` a `RNF-093` |

---

---

[← 03-dominio-y-glosario](./03-dominio-y-glosario.md) · [Índice](./00-indice.md) · [05-procesos-del-negocio →](./05-procesos-del-negocio.md)
