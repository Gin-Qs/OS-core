# 07 · Catálogo de cuentas y reglas contables V1 (A4)

> **BORRADOR PARA VALIDAR CON EL CONTADOR.** Los códigos agrupadores del SAT y los tratamientos (especialmente retenciones de IVA, arrendamientos NIF D-5 y nómina) deben ser revisados antes de T-PLT-13. Las reglas se guardan como datos en `contabilidad.reglas_contables`, no en código: el contador puede ajustarlas sin reprogramar.

## Catálogo de cuentas base (persona moral)
| Código | Cuenta | Naturaleza | Agrupador SAT (validar) |
|---|---|---|---|
| 1000 | ACTIVO | D | — |
| 1101 | Caja y fondos fijos | D | 101 |
| 1102 | Bancos | D | 102 |
| 1105 | Clientes | D | 105 |
| 1107 | Deudores diversos (anticipos a empleados) | D | 107 |
| 1113 | Impuestos a favor | D | 113 |
| 1118 | IVA acreditable pagado | D | 118 |
| 1119 | IVA pendiente de pago (acreditable por pagar) | D | 119 |
| 1120 | Anticipo a proveedores | D | 120 |
| 1125 | IVA retenido por clientes pendiente de cobro | D | validar |
| 1126 | IVA retenido por clientes efectivamente cobrado | D | validar |
| 1130 | Pagos anticipados (seguros, rentas) | D | validar |
| 1154 | Equipo de transporte | D | 154 |
| 1155 | Mobiliario y equipo de oficina | D | 155 |
| 1156 | Equipo de cómputo | D | validar |
| 1171 | Depreciación acumulada | A | 171 |
| 1180 | Activo por derecho de uso (bienes arrendados, NIF D-5) | D | validar |
| 1181 | Amortización acumulada de derecho de uso | A | validar |
| 2000 | PASIVO | A | — |
| 2201 | Proveedores | A | 201 |
| 2205 | Acreedores diversos | A | 205 |
| 2206 | Anticipos de clientes | A | 206 |
| 2208 | IVA trasladado cobrado | A | 208 |
| 2209 | IVA trasladado no cobrado | A | 209 |
| 2210 | Sueldos por pagar | A | 210 |
| 2211 | IMSS, SAR e INFONAVIT por pagar | A | 211 |
| 2213 | Impuestos por pagar (ISR, IVA, ISN) | A | 213 |
| 2216 | Impuestos retenidos por pagar (ISR salarios, ISR/IVA a terceros) | A | 216 |
| 2250 | Pasivo por arrendamiento | A | validar |
| 3000 | CAPITAL | A | — |
| 3101 | Capital social | A | 301 |
| 3201 | Resultados de ejercicios anteriores | A | 304 |
| 3301 | Resultado del ejercicio | A | 305 |
| 4101 | Ingresos por servicios | A | 401 |
| 4102 | Ingresos por venta de productos | A | 401 |
| 4103 | Otros ingresos de operación | A | 401 |
| 4104 | Devoluciones, descuentos y bonificaciones sobre ventas | D | 402 |
| 5101 | Costo de operación: materiales e insumos | D | 501 |
| 5102 | Costo de operación: servicios de terceros y subcontratos | D | 501 |
| 5103 | Costo de operación: sueldos del personal de operación | D | 501 |
| 5104 | Costo de operación: cuotas patronales e ISN del personal de operación | D | 501 |
| 5105 | Costo de operación: mantenimiento de equipo productivo | D | 501 |
| 5106 | Costo de operación: depreciación y amortización de derecho de uso | D | 501 |
| 5107 | Costo de operación: seguros de equipo productivo | D | 501 |
| 5108 | Costo de operación: viáticos y gastos de campo | D | 501 |
| 5109 | Costo de ventas (si maneja inventario) | D | 501 |
| 6101 | Gastos de administración: sueldos | D | 601 |
| 6102 | Gastos de administración: cuotas patronales IMSS/INFONAVIT/SAR | D | 601 |
| 6103 | Gastos de administración: impuesto sobre nómina | D | 601 |
| 6104 | Gastos de administración: honorarios y servicios | D | 601 |
| 6105 | Gastos de administración: renta, luz, internet, telefonía | D | 601 |
| 6106 | Gastos de administración: depreciación | D | 601 |
| 6107 | Gastos no deducibles | D | 601 |
| 7101 | Gastos financieros: intereses por arrendamiento | D | 701 |
| 7102 | Gastos financieros: comisiones bancarias | D | 701 |
| 7201 | Productos financieros | A | 702 |

**Notas para el contador.** (1) Las cuentas 51xx son el costo de lo que la empresa vende: qué entra ahí y qué se va a 61xx lo define la política contable de cada empresa, no el sistema. (2) La 5109 solo se usa si la empresa maneja inventario. (3) El catálogo se carga por empresa, con este como plantilla base: una comercializadora y una empresa de servicios no usan las mismas cuentas de resultados. (4) Los agrupadores marcados "validar" son los que más cambian entre giros.

## Reglas evento → póliza
Notación: C = cargo, A = abono. Montos del payload del evento.

### R-01 fiscal.cfdi_timbrado · Ingreso PPD (venta a crédito)
Póliza D
- C 1105 Clientes = total
- C 1125 IVA retenido por clientes pendiente = iva_retenido (4% si el cliente es persona moral)
- A 4101 Ingresos por servicios (o 4102 si es venta de producto) = subtotal
- A 2209 IVA trasladado no cobrado = iva_trasladado
Dimensiones en partidas: cliente_id, orden_id, activo_id (unidad).

### R-02 fiscal.cfdi_timbrado · Ingreso PUE (contado)
Póliza I: C 1102 Bancos = total · C 1126 IVA retenido cobrado = iva_retenido · A 4101 = subtotal · A 2208 IVA trasladado cobrado = iva_trasladado

### R-03 finanzas.pago_recibido (sobre CFDI PPD)
Póliza I
- C 1102 Bancos = importe
- A 1105 Clientes = importe
- C 2209 IVA trasladado no cobrado / A 2208 IVA trasladado cobrado = IVA proporcional al pago
- C 1126 / A 1125 = IVA retenido proporcional

### R-04 fiscal.cfdi_cancelado
Póliza de reversa exacta de la póliza origen (mismas cuentas, cargos ↔ abonos), en el periodo abierto.

### R-05 finanzas.cfdi_recibido_registrado · Gasto/costo PPD
Póliza D: C cuenta según clasificación/categoría (51xx/61xx) = subtotal · C 1119 IVA pendiente de pago = iva · A 2216 retenciones (si aplica, ej. honorarios o servicios de terceros) · A 2201 Proveedores = total a pagar

### R-06 finanzas.cfdi_recibido_registrado · Gasto/costo PUE ya pagado
Póliza E: C cuenta de gasto = subtotal · C 1118 IVA acreditable pagado = iva · A 1102 Bancos o 1101 Caja o 1107 Deudores (si lo pagó un empleado con anticipo) = total

### R-07 finanzas.pago_proveedor_realizado
Póliza E: C 2201 Proveedores = importe · A 1102 Bancos = importe · C 1118 / A 1119 = IVA proporcional

### R-08 finanzas.anticipo_otorgado
Póliza E: C 1107 Deudores diversos (empleado) = monto · A 1102 Bancos o 1101 Caja = monto

### R-09 finanzas.gasto_comprobado (con anticipo)
Póliza D: C 51xx según categoría = subtotal · C 1118 IVA acreditable = iva · A 1107 Deudores diversos = importe. Diferencias: reembolso al empleado (A 2205) o descuento (según liquidación).

### R-10 personas.nomina_timbrada
Póliza D
- C 5103 (personal de operación) / 6101 (administración) = percepciones gravadas + exentas
- A 2216 ISR retenido por salarios = isr_retenido
- A 2211 IMSS obrero retenido = imss_obrero
- A 2211 / 2205 Descuentos INFONAVIT y FONACOT = descuentos
- A 2210 Sueldos por pagar = neto
- Subsidio para el empleo aplicado: según regla vigente en `parametros_fiscales` (validar tratamiento con contador)
Provisión patronal (misma póliza):
- C 6102 (o 51xx) = cuotas patronales IMSS + SAR + INFONAVIT · A 2211
- C 6103 = ISN · A 2213

### R-11 personas.nomina_dispersada
Póliza E: C 2210 Sueldos por pagar = total · A 1102 Bancos = total

### R-12 finanzas.arrendamiento_iniciado (NIF D-5)
Póliza D: C 1180 Activo por derecho de uso = valor presente de rentas · A 2250 Pasivo por arrendamiento = mismo importe

### R-13 finanzas.renta_arrendamiento_pagada
Póliza E: C 2250 Pasivo por arrendamiento = amortizacion · C 7101 Intereses = interes · C 1118 IVA acreditable = iva · A 1102 Bancos = renta + iva
Nota fiscal: la renta es deducible fiscalmente cuando se paga; la amortización y el interés contables generan diferencias temporales (validar con contador).

### R-14 Cierre mensual · amortización y depreciación (proceso de cierre)
- Derecho de uso: C 5106 · A 1181
- Activos propios: C 6106 (o 51xx) · A 1171

### R-15 Cierre mensual · aplicación de pagos anticipados (FIN-031)
Pago de la póliza de seguro: C 1130 Pagos anticipados = prima · C 1118 IVA · A 1102/2201
Mensual: C 5107 Seguros = monto_mensual · A 1130

### R-16 Comisiones bancarias (conciliación)
Póliza E: C 7102 = comisión · C 1118 IVA · A 1102

## Reglas del libro
- Cada póliza debe cuadrar (cargos = abonos) o se rechaza.
- `evento_id` único: el mismo evento no genera dos pólizas.
- Solo se escribe en periodos `abierto`.
- Correcciones: póliza de reversa + póliza nueva; nunca UPDATE.
- Partidas con CFDI guardan uuid, RFC y monto para la contabilidad electrónica.
