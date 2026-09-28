# 08 · Motor fiscal V1

> Toda tasa, tabla o importe viene de `plataforma.parametros_fiscales` o `plataforma.catalogos_sat` con vigencia. Nunca en código. Casos dorados validados por el contador en `docs/12`.

## Componentes
| Componente | Responsabilidad |
|---|---|
| `cfdi/builder` | Construye el modelo CFDI 4.0 desde pedido, orden de trabajo, pago o recibo de nómina |
| `cfdi/validator` | Valida contra catálogos SAT: RFC y régimen del receptor, CP fiscal, uso CFDI compatible con régimen, claves de producto/unidad, objeto de impuesto, redondeos |
| `cfdi/complementos/pagos` | Complemento de pagos 2.0 |
| `cfdi/complementos/nomina` | Complemento de nómina 1.2 |
| `pac/adapter` | Interfaz única: `timbrar`, `cancelar`, `consultarEstado`, `descargarAcuses`. Implementación por proveedor elegido |
| `sat/descarga` | Interfaz: `solicitar(periodo, tipo)`, `verificar`, `descargar`. V1 vía proveedor (T5) |
| `calculos/iva` | IVA mensual en flujo de efectivo |
| `calculos/isr-provisional` | Pago provisional de personas morales |
| `calculos/retenciones` | ISR/IVA retenidos a terceros |
| `calculos/diot` | Operaciones con terceros desde CFDI recibidos pagados |
| `nomina/*` | ISR salarios, subsidio, IMSS, INFONAVIT, ISN |

## CFDI de ingreso (caso base)
Datos obligatorios a tomar del modelo:
- Comprobante: tipo I, uso CFDI del cliente, método PUE/PPD, forma de pago (99 si PPD), exportación 01, moneda y tipo de cambio.
- Emisor: RFC, nombre y régimen fiscal de la empresa. Receptor: RFC, nombre, código postal del domicilio fiscal, régimen fiscal y uso CFDI **compatible con ese régimen** (el SAT lo rechaza si no).
- Conceptos: clave de producto o servicio del SAT, clave de unidad, cantidad, valor unitario, descuento, objeto de impuesto.
- Impuestos: IVA trasladado a la tasa que corresponda; retenciones de IVA o ISR cuando el tipo de servicio y el receptor lo obliguen (por ejemplo, honorarios y arrendamiento con receptor persona moral).
- Redondeo: se calcula por concepto y se suma; nunca al revés. La diferencia por redondeo se ajusta según la regla del doc 07.

**Complementos por giro.** Un satélite de industria puede requerir un complemento propio (Carta Porte para autotransporte, comercio exterior para importación). El motor los admite como módulos dentro de `cfdi/complementos/`, sin modificar el constructor base. El núcleo solo implementa los complementos universales: pagos 2.0 y nómina 1.2.

**Validaciones previas al timbrado:** catálogos SAT vigentes, RFC con estructura válida y no listado en 69-B, régimen y uso compatibles, y suma de impuestos igual a la de los conceptos. Si algo falla, no se envía al PAC: se explica el error en pantalla con su campo.

## Cálculos mensuales (se disparan con `contable.periodo_cerrado`)
### IVA
IVA a cargo = IVA trasladado efectivamente cobrado − IVA acreditable efectivamente pagado − IVA retenido por clientes efectivamente cobrado. Saldo a favor se acumula en `declaraciones`.
### ISR provisional (persona moral)
Ingresos nominales acumulados del ejercicio × coeficiente de utilidad − pérdidas pendientes = utilidad fiscal estimada × tasa − pagos provisionales previos − retenciones = pago del mes. Coeficiente y tasa desde parámetros; primer ejercicio sin coeficiente según regla vigente (validar con contador).
### Retenciones
Suma de ISR/IVA retenidos a terceros en CFDI recibidos pagados en el mes.
### DIOT
Por proveedor (RFC): valor de actos pagados por tasa, IVA pagado, IVA retenido. Genera el archivo del formato vigente.
### Contabilidad electrónica
Catálogo (con código agrupador) al inicio o cuando cambie; balanza mensual; pólizas bajo requerimiento.

## Nómina
- ISR: tabla del periodo (art. 96 LISR) desde parámetros según periodicidad.
- Subsidio para el empleo: regla vigente desde parámetros (ha cambiado recientemente; no asumir).
- Integración de SDI con factor de prestaciones; tope en UMA.
- IMSS por ramo (enfermedad y maternidad, invalidez y vida, retiro, cesantía y vejez, guarderías, riesgo de trabajo con prima de la empresa), INFONAVIT 5%: cuotas desde parámetros.
- ISN por estado de la sucursal desde parámetros.
- Percepciones variables (comisiones, destajo, bonos): entran como incidencia del periodo y se gravan según su tipo de percepción del catálogo SAT.
- CFDI de nómina 1.2 por recibo; timbrado por lote con reintentos individuales.
