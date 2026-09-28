# 18 · Glosario

Para que una sesión nueva —o un desarrollador que no vive en la contabilidad mexicana— entienda los documentos sin adivinar.

## Del producto

| Término | Qué significa aquí |
|---|---|
| **Núcleo** | Las funciones que sirven a cualquier empresa sin importar su giro. Es lo que construye este repositorio: 402 funciones |
| **Satélite** | Extensión para una industria concreta. Extiende entidades del núcleo, nunca las duplica. No se construye todavía |
| **Área** | Una de las 7 divisiones del catálogo (Finanzas, Personas, Comercial, Operaciones, Legal, Dirección, Tecnología). Corresponde uno a uno con un módulo de código |
| **Departamento** | Subdivisión dentro de un área (Contabilidad, Fiscal, Tesorería…). 46 en total |
| **Función** | La unidad del catálogo, con clave estable (`FIN-020`). Una función = un área = un departamento |
| **Nivel** | `E` Esencial, `P` Profesional, `A` Avanzado. Decide en qué plan aparece la función, no cuándo se construye |
| **Plan** | Basic (E, 118 funciones) · Pro (E+P, 281) · Max (E+P+A, 402) |
| **Paquete de modelo** | Add-on que se activa por modelo de negocio, no por industria. 140 funciones en 4 paquetes |
| **Micro app** | Calculadora independiente (IVA, finiquito, punto de equilibrio). No escribe en la base de negocio y no lleva clave |
| **Espacio del Colaborador** | La vista que tiene cualquier empleado: sus recibos, vacaciones, gastos, capacitación |

## De la arquitectura

| Término | Qué significa aquí |
|---|---|
| **Monolito modular** | Una sola aplicación, dividida en módulos con fronteras reales: cada uno con su código, su esquema de base de datos y sus contratos públicos |
| **Contrato (`contracts/`)** | Lo único que un módulo expone a los demás: tipos y funciones públicas. Todo lo demás es interno |
| **Bus de eventos** | El mecanismo por el que un módulo avisa a los demás que algo pasó, sin llamarlos directamente |
| **Outbox** | El evento se escribe en una tabla dentro de la misma transacción que el cambio de negocio. Si la transacción falla, el evento no existe; si tiene éxito, el evento se entrega sí o sí |
| **Idempotencia** | Procesar el mismo evento dos veces produce el mismo resultado que procesarlo una. Se logra registrando lo ya procesado |
| **Dead-letter** | Donde termina un evento que agotó sus reintentos. Genera alerta: nunca se pierde en silencio |
| **RLS** (Row Level Security) | Política de PostgreSQL que filtra las filas que una sesión puede leer o escribir. Es lo que aísla a una empresa de otra |
| **Vault** | Almacén cifrado de secretos. En las tablas de negocio solo queda una referencia |
| **Bitácora** | Registro de quién hizo qué, cuándo y desde dónde. No se edita ni se borra |
| **Los 6 almacenes** | ① operativa ② libro contable inmutable ③ bóveda cifrada ④ eventos de alto volumen ⑤ archivos ⑥ analítico |

## De la contabilidad

| Término | Qué significa aquí |
|---|---|
| **Póliza** | El asiento contable: un conjunto de partidas con cargos y abonos que deben sumar igual. Aquí las genera el motor contable a partir de eventos |
| **Partida** | Cada renglón de una póliza: una cuenta, y un cargo o un abono (nunca los dos) |
| **Cargo / abono** | Los dos lados del registro contable. La suma de cargos debe ser igual a la de abonos, siempre |
| **Balanza de comprobación** | El listado de todas las cuentas con sus saldos. Si no cuadra, algo se rompió |
| **Póliza de reversa** | La forma correcta de corregir un error: una póliza nueva que anula la anterior. Nunca se edita la original |
| **Periodo cerrado** | Un mes cuya contabilidad quedó bloqueada. Rechaza escrituras |
| **Código agrupador SAT** | La clasificación oficial que el SAT exige para cada cuenta contable |
| **NIF** | Normas de Información Financiera mexicanas. La NIF D-5 es la que trata arrendamientos: un bien arrendado se registra como activo por derecho de uso con su pasivo |
| **Devengado vs flujo** | Devengado = se registra cuando ocurre. Flujo = cuando el dinero se mueve. La contabilidad es devengada; el IVA mexicano es de flujo |

## De lo fiscal mexicano

| Término | Qué significa aquí |
|---|---|
| **SAT** | La autoridad fiscal mexicana |
| **CFDI 4.0** | La factura electrónica. Es un XML que solo es válido cuando un PAC lo sella |
| **PAC** | Proveedor Autorizado de Certificación: la empresa autorizada por el SAT para sellar CFDI. Sin PAC no hay factura válida |
| **Timbrar** | El acto de que el PAC selle el CFDI y le asigne su folio fiscal (UUID) |
| **CSD** | Certificado de Sello Digital: el certificado con el que se firman los CFDI |
| **e.firma** | La firma electrónica avanzada del contribuyente. Más poderosa que el CSD: sirve para trámites, no para facturar |
| **PUE / PPD** | Pago en Una sola Exhibición / Pago en Parcialidades o Diferido. Un CFDI PPD exige emitir después un complemento de pago por cada cobro |
| **Complemento de pagos 2.0** | El comprobante que se emite al cobrar una factura PPD |
| **Nómina 1.2** | El complemento de CFDI con el que se timbra cada recibo de nómina |
| **Carta Porte 3.1** | Complemento obligatorio para trasladar mercancía. Es satélite: no se construye aquí |
| **Buzón de CFDI / descarga masiva** | El servicio del SAT que permite bajar todos los CFDI emitidos y recibidos. Es la fuente automática de los gastos |
| **IVA trasladado / acreditable / retenido** | El que se cobra al cliente / el que se paga al proveedor y se puede restar / el que un tercero retiene |
| **IVA en flujo** | El IVA se causa al cobrar y se acredita al pagar, no al facturar |
| **DIOT** | Declaración Informativa de Operaciones con Terceros: mensual, se arma desde los CFDI recibidos |
| **ISR provisional** | El pago mensual a cuenta del impuesto anual, calculado con el coeficiente de utilidad |
| **69-B (EFOS)** | La lista de contribuyentes que emiten facturas de operaciones inexistentes. Facturar con uno de ellos invalida la deducción |
| **RESICO** | Régimen Simplificado de Confianza: régimen fiscal con tasas y reglas propias |
| **PTU** | Participación de los Trabajadores en las Utilidades. Se reparte cada año |

## De nómina y seguridad social

| Término | Qué significa aquí |
|---|---|
| **IMSS** | Instituto Mexicano del Seguro Social. Recibe altas, bajas, modificaciones de salario y cuotas |
| **SDI** | Salario Diario Integrado: la base con la que se calculan las cuotas al IMSS |
| **SUA** | El sistema con el que se pagan las cuotas al IMSS e INFONAVIT |
| **INFONAVIT / FONACOT** | Instituciones cuyos créditos se descuentan vía nómina |
| **ISN** | Impuesto Sobre Nómina: estatal, la tasa cambia por estado |
| **UMA** | Unidad de Medida y Actualización: el valor de referencia para multas, topes y cuotas |
| **Subsidio para el empleo** | Cantidad que reduce el ISR de los salarios bajos |
| **Finiquito / liquidación** | Lo que se paga al terminar la relación laboral: finiquito siempre, liquidación cuando el despido es injustificado |
| **NOM-035** | Norma que obliga a identificar y prevenir riesgos psicosociales en el trabajo |
| **REPSE** | Registro de prestadoras de servicios especializados |

## De la construcción

| Término | Qué significa aquí |
|---|---|
| **Caso dorado** | Escenario de prueba con entrada y resultado esperado exactos, revisado por el contador. Los motores fiscal, contable y de nómina deben pasarlos siempre |
| **ADR** | Architecture Decision Record: el registro de una decisión de arquitectura, con su contexto y sus consecuencias. En `docs/adr/` |
| **Tarea** | Una unidad de trabajo del plan con clave por área (`T-FIN-04`), sus dependencias y su criterio de aceptación |
| **Semilla** | Datos iniciales que se cargan en un entorno para poder probar |
