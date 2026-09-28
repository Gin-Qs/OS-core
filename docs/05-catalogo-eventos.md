# 05 · Catálogo de eventos V1 (A2)

Formato de sobre (todos los eventos):
```json
{ "id": "uuid", "tipo": "modulo.evento", "version": 1, "empresa_id": "uuid",
  "agregado": "tabla", "agregado_id": "uuid", "ocurrido_en": "ISO-8601",
  "actor_id": "uuid|null", "payload": { } }
```
Reglas: se inserta en la misma transacción que el cambio · suscriptores idempotentes · nunca se borra · cambios de forma = nueva `version`.

| Evento | Emisor | Payload | Suscriptores → acción |
|---|---|---|---|
| comercial.cliente_creado | Comercial | cliente_id, tercero_id, rfc | — (tablero) |
| comercial.cotizacion_aceptada | Comercial | cotizacion_id, cliente_id, origen, total | Comercial → crea pedido |
| comercial.pedido_creado | Comercial | pedido_id, cliente_id, origen, partidas | Operaciones → crea orden de trabajo |
| operaciones.orden_asignada | Operaciones | orden_id, recursos[] | Alertas → notifica a quien ejecuta |
| operaciones.orden_cerrada | Operaciones | orden_id, pedido_id, tiene_evidencia | Finanzas → prepara CFDI borrador |
| operaciones.consumo_registrado | Operaciones | consumo_id, orden_id, activo_id, tipo, importe | Analítica (sin póliza; la póliza nace del CFDI o gasto) |
| operaciones.incidencia_reportada | Operaciones | incidencia_id, orden_id, tipo, severidad | Alertas; Legal si tipo robo/accidente → sugiere siniestro |
| operaciones.activo_registrado | Operaciones | activo_id, propiedad, costo | Contable → alta de activo contable (si propio) |
| operaciones.mantenimiento_vencido | Alertas | activo_id, plan_id, km/fecha | Operaciones (bloquea la asignación si es crítico) |
| operaciones.mantenimiento_terminado | Operaciones | mantenimiento_id, activo_id, costo | Analítica · actualiza plan |
| fiscal.cfdi_timbrado | Motor fiscal | cfdi_id, uuid, tipo, metodo_pago, subtotal, traslados, retenciones, total, receptor, origen (pedido/orden/nómina/pago) | Contable → póliza · Finanzas → crea CxC (I-PPD) o registra cobro (I-PUE) |
| fiscal.cfdi_cancelado | Motor fiscal | cfdi_id, uuid, motivo, sustituto | Contable → póliza de reversa · Finanzas → cancela CxC |
| fiscal.cfdi_recibido | Buzón SAT | cfdi_recibido_id, uuid, emisor_rfc, tipo, total | Finanzas → sugiere clasificación y proveedor |
| finanzas.cfdi_recibido_registrado | Finanzas | cfdi_recibido_id, clasificacion, categoria, metodo_pago, orden_id, activo_id | Contable → póliza D (PPD) o E (PUE) · Finanzas → CxP si PPD |
| finanzas.pago_recibido | Tesorería | pago_id, cliente_id, importe, aplicaciones[] | Motor fiscal → complemento de pago (si PPD) · Contable → póliza I · Comercial → libera crédito |
| finanzas.pago_proveedor_autorizado | Flujos | pago_id | Tesorería (layout) |
| finanzas.pago_proveedor_realizado | Tesorería | pago_id, aplicaciones[], cuenta_bancaria_id | Contable → póliza E |
| finanzas.gasto_comprobado | Finanzas | gasto_id, empleado_id, anticipo_id, importe, iva, categoria, orden_id | Contable → póliza D · Transporte → actualiza anticipo |
| finanzas.movimiento_conciliado | Tesorería | movimiento_id, documentos[] | — (control) |
| finanzas.arrendamiento_iniciado | Finanzas | arrendamiento_id, derecho_uso, pasivo | Contable → póliza D inicial |
| finanzas.renta_arrendamiento_pagada | Finanzas | arrendamiento_id, periodo, renta, interes, amortizacion, iva | Contable → póliza E |
| finanzas.provision_creada | Finanzas | provision_id, monto_total | Contable (si nace de pago) |
| personas.empleado_alta | Personas | empleado_id, fecha_ingreso, sdi | Tecnología → crea usuario (colaborador) · Personas → movimiento IMSS |
| personas.empleado_baja | Personas | empleado_id, fecha, motivo | Tecnología → revoca acceso · Personas → movimiento IMSS |
| personas.nomina_timbrada | Personas | periodo_id, totales por concepto, recibos[] | Contable → póliza D (sueldos, retenciones, cuotas patronales, ISN) |
| personas.nomina_dispersada | Personas | periodo_id, cuenta_bancaria_id, total | Contable → póliza E |
| legal.poliza_seguro_por_vencer | Alertas | poliza_id, vence | Dirección, Operaciones |
| legal.permiso_por_vencer | Alertas | permiso_id, vence | Dirección, Operaciones |
| legal.siniestro_abierto | Legal | siniestro_id, poliza_id, monto_reclamado | Alertas |
| contable.periodo_cerrado | Motor contable | periodo_id, ejercicio, mes | Motor fiscal → calcula ISR, IVA, DIOT y genera contabilidad electrónica |
| contable.depreciacion_aplicada | Motor contable | periodo_id, total | — |
| plataforma.evento_fallido | Despachador | evento_id, suscriptor, error | Alertas → Tecnología |

## Eventos de un satélite futuro

Un satélite de industria publica sus propios eventos con su prefijo (`<industria>.<entidad>_<verbo>`) y se suscribe a los de aquí. No modifica ni renombra ningún evento del núcleo: por eso los eventos del núcleo se nombran por lo que pasó en el negocio (`orden_cerrada`), no por cómo lo llama una industria.
