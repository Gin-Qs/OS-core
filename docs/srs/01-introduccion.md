## 1. Introducción

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`) son estables y se referencian entre documentos.

### 1.1 Propósito de este documento

Este documento especifica **qué debe hacer el sistema, cómo debe comportarse y por qué**, con el detalle necesario para que se construya sin volver a preguntar lo ya decidido. Es la línea base contra la cual se verifica el software: una funcionalidad que no esté aquí no se construye, y una que esté aquí y no funcione como dice es un defecto, no una interpretación.

El documento cumple tres funciones concretas:

1. **Contrato interno.** Define el alcance. Lo que entra, lo que no, y bajo qué criterio se considera terminado cada pieza.
2. **Fuente única de verdad.** Cuando la especificación y el código difieren, gana la especificación; si la especificación está equivocada, se corrige aquí primero y después en el código.
3. **Defensa contra la deriva.** Un sistema de 402 funciones construido por una persona con ayuda de IA, a lo largo de meses, se desvía si no hay un punto fijo. Este es el punto fijo.

### 1.2 El problema que resuelve el producto

Una empresa mexicana pequeña o mediana opera hoy repartida entre herramientas que no se hablan:

| Dónde vive la información | Herramienta típica | Consecuencia |
|---|---|---|
| Clientes y cotizaciones | Hoja de cálculo, WhatsApp, correo | Nadie sabe qué se cotizó ni en qué quedó |
| Facturación | Portal del SAT o sistema del despacho contable | Facturar exige recapturar lo que ya estaba en la cotización |
| Contabilidad | En el despacho contable externo, con un mes de retraso | La dirección decide con números de hace 30–60 días |
| Cobranza | Memoria y recordatorios manuales | Se cobra tarde porque nadie lleva la antigüedad de saldos |
| Nómina | Despacho externo o sistema aparte | El costo real por persona no se conecta con la operación |
| Operación | Hojas de cálculo y mensajes | El costo de ejecutar un trabajo nunca se compara con lo que se cobró |
| Documentos legales | Carpetas y correos | Los vencimientos se descubren cuando ya vencieron |

El problema de fondo **no es la falta de herramientas**: es que el dato se captura varias veces, envejece en trayecto y nunca se convierte en una sola verdad que la dirección pueda usar para decidir. El valor del producto no está en almacenar más datos, sino en que **un mismo hecho económico se capture una vez y se propague solo** a la factura, a la póliza, al impuesto, al flujo de efectivo y al tablero.

### 1.3 Alcance del producto

#### 1.3.1 Lo que el sistema hace

El sistema es una **aplicación web multiempresa** que cubre la operación administrativa completa de una empresa mexicana:

| Bloque | Qué resuelve |
|---|---|
| **Comercial** | Prospectos, oportunidades, clientes, cotizaciones, pedidos, facturación, marketing básico, servicio al cliente |
| **Operaciones y Abastecimiento** | Órdenes de trabajo, planeación y asignación de recursos, evidencias en campo, consumos, compras, recepción, inventario básico, activos y mantenimiento |
| **Finanzas** | Contabilidad completa con libro inmutable, cumplimiento fiscal (CFDI, IVA, ISR, DIOT, contabilidad electrónica), tesorería (bancos, CxC, CxP, cobranza, flujo de efectivo), control de gestión |
| **Personas** | Expediente, nómina propia timbrada, IMSS, seguridad y salud, talento, compensaciones, relaciones laborales |
| **Legal y Riesgo** | Contratos, documentos corporativos, permisos, cumplimiento, riesgos, seguros |
| **Dirección** | Tablero ejecutivo, alertas, objetivos, planeación, gobierno corporativo |
| **Tecnología y Datos** | Usuarios y roles, configuración, integraciones, respaldos, ciberseguridad, reportes y agentes de IA |

Y tres capacidades transversales que atraviesan todo lo anterior:

- **Contabilidad automática.** Cada hecho económico genera su póliza sin captura manual, con un libro que no se puede alterar.
- **Cumplimiento fiscal nativo.** El sistema emite CFDI, timbra nómina, calcula impuestos y genera las declaraciones informativas, sin depender de un sistema externo.
- **Permisos por rol.** Toda la empresa usa el mismo sistema; cada persona ve y edita solo lo suyo.

#### 1.3.2 Lo que el sistema NO hace (y por qué)

Declarar los límites es parte de la especificación: lo que no está aquí no se construye aunque parezca fácil.

| Fuera de alcance | Por qué | Dónde queda |
|---|---|---|
| Funciones específicas de una industria (viajes de carga, obra civil, expediente clínico, manufactura) | El núcleo se define justamente por ser independiente del giro. Mezclarlas contamina el modelo | Satélites de industria, después de terminar el núcleo |
| Inventario avanzado (multi-almacén, lotes, caducidades, logística) | No lo necesita toda empresa; sí lo necesita quien maneja bienes físicos a escala | Paquete "Inventarios y Cadena de Suministro" (`docs/areas/08-paquetes-de-modelo.md`) |
| Comercio electrónico, marketplaces, punto de venta | Depende del canal de venta, no del giro ni del tamaño | Paquete "Canales de Venta" |
| Comercio exterior, precios de transferencia, expatriados | Solo aplica a empresas con operación internacional | Paquete "Operación Internacional" |
| Consolidación de grupo, cap table, family office | Aplica a grupos empresariales, no a una empresa | Paquete "Grupo Empresarial" |
| Operar en países distintos de México | El motor fiscal está construido sobre normativa mexicana | §13.6 describe cómo se abriría |
| Sustituir al contador | El sistema calcula y genera archivos; la presentación de declaraciones y el criterio profesional siguen siendo humanos | — |
| Presentar declaraciones directamente ante el SAT | El SAT no expone una API de presentación para estas declaraciones. El sistema genera el archivo o los datos; una persona los presenta | §12.3 |
| Ser un banco o mover dinero por sí mismo | El sistema genera layouts de pago y registra movimientos; la transferencia la ejecuta el banco | §12.3 |
| Aplicación móvil nativa (iOS/Android en tiendas) | Una PWA cubre las necesidades de campo con una sola base de código | `RNF-045` |

### 1.4 Objetivos del producto

Los objetivos son verificables. Cada uno tiene una métrica y una forma de medirla; un objetivo sin métrica no es un objetivo, es un deseo.

| # | Objetivo del producto | Métrica | Cómo se verifica |
|---|---|---|---|
| **OP-01** | Capturar cada hecho económico una sola vez | Número de recapturas manuales entre cotización → pedido → factura → póliza = **0** | Prueba E2E `CD-01`: el usuario escribe los datos una vez; la factura y la póliza se generan sin captura adicional |
| **OP-02** | Contabilidad al día, no a 30 días | Días entre el hecho económico y su póliza ≤ **0 días** (la póliza nace con el evento) | Consulta: `max(fecha_poliza − fecha_evento)` en el periodo = 0 |
| **OP-03** | Cumplimiento fiscal sin sistema externo | 100% de CFDI de ingreso, pago y nómina emitidos desde el sistema; IVA, ISR, DIOT y contabilidad electrónica generados por el sistema | Un mes completo declarado con cifras del sistema que coinciden con lo presentado |
| **OP-04** | Que toda la empresa lo use, no solo administración | ≥ 80% de los empleados con cuenta activa y al menos un uso mensual | Consulta de usuarios activos ÷ empleados dados de alta |
| **OP-05** | Que la dirección decida con datos de hoy | Antigüedad del dato del tablero ejecutivo ≤ **5 minutos** | Marca de tiempo de la vista analítica frente a la hora de consulta |
| **OP-06** | Que un satélite de industria se pueda agregar sin rediseñar el núcleo | Número de tablas del núcleo modificadas al agregar el primer satélite = **0** | Revisión del diff de migraciones al construir el primer satélite |
| **OP-07** | Que una empresa nueva arranque sin reprogramar | Configuración de una empresa nueva sin escribir código: **100%** de los casos dentro del núcleo | Alta de la segunda empresa: cero commits de código asociados |
| **OP-08** | Integridad contable demostrable | Pólizas alteradas después de su registro = **0**; cadena de hash íntegra en el 100% de los periodos cerrados | Verificación de hash encadenado sobre el libro completo |

### 1.5 Referencias normativas

El sistema implementa obligaciones legales concretas. Esta es la lista de normas cuyo cumplimiento condiciona el diseño. Las versiones y tasas vigentes **no se escriben en el código**: viven como parámetros con vigencia (`RF-012`).

| Ámbito | Norma / referencia | Qué condiciona |
|---|---|---|
| Fiscal general | Código Fiscal de la Federación (CFF), art. 28, 29, 29-A, 30, 32-B Ter | Contabilidad electrónica, requisitos del CFDI, conservación 5 años, beneficiario controlador |
| Comprobantes | Anexo 20 vigente del SAT: CFDI 4.0, complemento de recepción de pagos 2.0, complemento de nómina 1.2 | Estructura del XML, catálogos, validaciones |
| Contabilidad electrónica | Anexo 24 del SAT (catálogo con código agrupador, balanza, pólizas) | Formato de los XML contables |
| ISR | Ley del ISR: pagos provisionales de persona moral, retenciones, declaración anual, PTU | Cálculos de `RF-132`, `RF-134` y `RF-135` |
| IVA | Ley del IVA: causación en flujo de efectivo, acreditamiento, retenciones, DIOT | Cálculos de `RF-131` a `RF-133` |
| Laboral | Ley Federal del Trabajo: jornada, vacaciones, prima vacacional, aguinaldo, finiquito, PTU | Motor de nómina `RF-160` a `RF-169` |
| Seguridad social | Ley del Seguro Social e INFONAVIT: SDI, cuotas, movimientos afiliatorios | `RF-170` a `RF-174` |
| Local | Leyes de hacienda estatales: Impuesto Sobre Nómina, tasa por estado | `RF-175` |
| Seguridad y salud | NOM-035-STPS (riesgos psicosociales) | `RF-176` |
| Firma y conservación | NOM-151-SCFI (constancia de conservación de mensajes de datos) | `RF-201` |
| Datos personales | Ley Federal de Protección de Datos Personales en Posesión de los Particulares | `RNF-060` a `RNF-066` |
| Prevención de lavado | Ley Federal para la Prevención e Identificación de Operaciones con Recursos de Procedencia Ilícita | `RF-209` (nivel Profesional) |
| Contable | Normas de Información Financiera (NIF) mexicanas, en particular NIF D-5 (arrendamientos) | Tratamiento de activos por derecho de uso, `RF-127` |
| Clasificación de empresa | Estratificación DOF 30/06/2009 (trabajadores 10% + ventas 90%) | Segmentación de planes, §4.3 |

**Regla permanente sobre normativa.** Toda norma cambia. El sistema **debe** tratar tasas, tablas, topes, catálogos y versiones de complemento como datos con fecha de vigencia, nunca como constantes de código. Un cambio del SAT en enero no debe requerir un despliegue: debe requerir cargar un parámetro. Ver `RF-012` y `RNF-081`.

---

---

[Índice](./00-indice.md) · [02-descripcion-general →](./02-descripcion-general.md)
