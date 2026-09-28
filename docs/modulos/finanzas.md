# Módulo · Finanzas
**Propósito:** dinero entrante y saliente, impuestos y costeo.
**Funciones:** FIN-009..014, 016, 018..026, 031, 038, 043, 044 (FIN-001..008, 030 en motor contable).
**Tablas:** esquema `finanzas`.
**Publica:** cfdi_recibido_registrado, pago_recibido, pago_proveedor_autorizado, pago_proveedor_realizado, gasto_comprobado, movimiento_conciliado, arrendamiento_iniciado, renta_arrendamiento_pagada, provision_creada. **Escucha:** fiscal.cfdi_timbrado (CxC), fiscal.cfdi_cancelado, fiscal.cfdi_recibido (sugerir clasificación), operaciones.orden_cerrada (borrador de CFDI), contable.periodo_cerrado (cálculos fiscales).
**Reglas:**
- CxC nace de CFDI I-PPD; I-PUE se registra como cobrado contra movimiento bancario.
- Pago recibido sobre PPD genera complemento de pagos (motor fiscal) en el plazo legal; alerta si queda pendiente.
- Contrarrecibo: fecha de vencimiento real = fecha de contrarrecibo + días de crédito (clientes institucionales).
- Cobranza automática: recordatorio X días antes de vencer, al vencer y cada N días después (configurable).
- CFDI recibido no se registra dos veces (uuid único) y se valida estado SAT antes de pagar.
- Pagos a proveedor sobre umbral requieren aprobación; nunca se paga a proveedor sin CFDI vigente (salvo excepción aprobada).
- Conciliación automática: coincide monto exacto + referencia o fecha ±3 días; lo demás queda a revisión manual.
- Arrendamiento: tabla con tasa de descuento; valor presente de rentas = derecho de uso inicial.
- Flujo 13 semanas: saldos bancarios + CxC (fecha promesa > vencimiento) + CxP programadas + nómina estimada + partidas manuales.
**Pantallas:** doc 10 Finanzas. **Pruebas:** CD-01..05, CD-07..09.
