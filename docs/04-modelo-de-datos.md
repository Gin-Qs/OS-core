# 04 · Modelo de datos V1 (A1)

Convenciones: toda tabla de negocio incluye `id uuid pk`, `empresa_id uuid not null → plataforma.empresas`, `creado_en timestamptz`, `creado_por uuid`, `actualizado_en`, `actualizado_por`. Se omiten abajo. Dinero `numeric(18,2)`, tasas `numeric(9,6)`, cantidades `numeric(18,4)`. `→` = llave foránea. Funciones V1 que cubre cada tabla entre corchetes.

---
## Esquema `plataforma`
| Tabla | Columnas clave |
|---|---|
| empresas | razon_social, rfc, **regimen_fiscal_id → regimenes_fiscales**, codigo_postal_fiscal, nombre_comercial, logo_archivo_id, plan, activa |
| empresa_regimen_historial | empresa_id, regimen_fiscal_id, vigencia_inicio, vigencia_fin, motivo, registrado_por — un periodo se calcula con el régimen vigente entonces [RF-059] |
| sucursales | nombre, codigo_postal, estado, es_matriz |
| usuarios | id = auth.users.id, nombre, email, empleado_id → personas.empleados (nullable), activo, ultimo_acceso [TEC-001] |
| roles | clave (propietario, administrador, direccion, tesoreria, contabilidad, personas, comercial, operaciones, campo, colaborador), nombre, es_sistema |
| permisos | rol_id → roles, recurso (ej. `finanzas.cxc`), accion, alcance (`propios`, `empresa`) |
| usuario_roles | empresa_id, usuario_id → usuarios, rol_id → roles, vigencia_inicio, vigencia_fin (acceso temporal), otorgado_por, otorgado_en — **clave primaria (empresa_id, usuario_id, rol_id): varios roles por usuario y empresa** [TEC-001, RF-004] |
| roles_incompatibles | rol_a_id → roles, rol_b_id → roles, motivo, control_que_rompe — semilla del sistema, editable por empresa [RF-032] |
| excepciones_segregacion | empresa_id, usuario_id, rol_a_id, rol_b_id, motivo, autorizado_por (usuario con rol propietario), autorizado_en, retirada_en — solo inserción; una excepción vigente aparece en el reporte de control interno [RF-032, FIN-048] |
| terceros | tipo_persona (fisica/moral), rfc, razon_social, regimen_fiscal, codigo_postal_fiscal, uso_cfdi_default, email_facturacion, es_cliente, es_proveedor, activo — maestro compartido |
| productos_servicios | clave_interna, descripcion, clave_prod_serv_sat, clave_unidad_sat, objeto_impuesto, tasa_iva, tasa_retencion_iva, tasa_retencion_isr, cuenta_ingreso_id, cuenta_gasto_id, activo |
| catalogos_sat | catalogo, clave, descripcion, vigencia_inicio, vigencia_fin, datos jsonb — sin empresa_id |
| parametros_fiscales | clave (UMA, SALARIO_MINIMO, TABLA_ISR_MENSUAL, SUBSIDIO_EMPLEO, CUOTAS_IMSS, TASA_ISN_<ESTADO>…), vigencia_inicio, vigencia_fin, valor jsonb, fuente — sin empresa_id |
| regimenes_fiscales | clave_sat, nombre, fundamento_legal, tipo_persona (fisica/moral), base_acumulacion (devengado/flujo), obligaciones jsonb, vigencia_inicio, vigencia_fin — sin empresa_id [RF-051] |
| definiciones_calculo | clave (ISR_PROVISIONAL, ISR_ANUAL, PTU…), regimen_id → regimenes_fiscales, version, vigencia_inicio, vigencia_fin, pasos jsonb, estado (borrador/validada/activa/retirada), activada_por, activada_en — solo inserción; una versión activa por clave, régimen y fecha [RF-053, RF-056] |
| ejecuciones_calculo | empresa_id, definicion_id, version_definicion, periodo_id, ejecutado_en, ejecutado_por, papel_trabajo jsonb (paso, descripción, expresión, entradas, resultado, fundamento), resultado numeric, poliza_id nullable — solo inserción [RF-055, RF-057] |
| casos_dorados_calculo | definicion_id, version, nombre, entradas jsonb, resultado_esperado numeric, firmado_por_contador, firmado_en — una definición no se activa sin pasarlos todos [RF-056] |
| folios | tipo (factura, cotizacion, pedido, orden, poliza_I/E/D…), serie, siguiente |
| archivos | bucket, ruta, nombre, tipo_mime, tamano_bytes, hash_sha256, entidad, entidad_id, version, reemplaza_a_id |
| secretos_ref | tipo (csd, efirma, pac, banco, clabe), vault_secret_id, descripcion, rfc, vigencia_fin |
| eventos_outbox | tipo, version, agregado, agregado_id, payload jsonb, ocurrido_en, estado (pendiente/procesado/error), intentos, siguiente_intento_en, ultimo_error |
| eventos_procesados | evento_id → eventos_outbox, suscriptor, procesado_en · PK(evento_id, suscriptor) |
| bitacora | usuario_id, accion, entidad, entidad_id, antes jsonb, despues jsonb, ip, ocurrido_en — solo inserción |
| aprobaciones | tipo, entidad, entidad_id, monto, solicitado_por, estado (pendiente/aprobada/rechazada), resuelto_por, comentario, resuelto_en |
| reglas_aprobacion | tipo, monto_desde, monto_hasta, rol_aprobador |
| alertas | tipo, severidad (info/advertencia/critica), entidad, entidad_id, mensaje, vence_en, rol_destino, estado (abierta/atendida/descartada) [DIR-002] |
| integraciones | tipo (pac, sat, correo, banco), proveedor, configuracion jsonb, secreto_ref_id, activa [TEC-006] |
| configuracion | clave, valor jsonb [TEC-005] |

## Esquema `comercial`
| Tabla | Columnas clave |
|---|---|
| clientes | tercero_id → plataforma.terceros, dias_credito, limite_credito, lista_precios_id, estado_credito (activo/bloqueado), requiere_orden_compra, requiere_contrarrecibo, portal_proveedor_url, notas [COM-002, FIN-022] |
| contactos | tercero_id, nombre, puesto, email, telefono, es_principal, recibe_facturas |
| prospectos | nombre_empresa, contacto, email, telefono, origen, estado (nuevo/contactado/calificado/descartado/convertido), cliente_id [COM-001] |
| oportunidades | cliente_id, prospecto_id, nombre, etapa (prospeccion/propuesta/negociacion/ganada/perdida), monto_estimado, probabilidad, fecha_cierre_estimada, responsable_id, motivo_perdida [COM-003] |
| actividades | tipo (llamada/correo/visita/reunion/tarea), relacionado_tipo, relacionado_id, fecha, responsable_id, notas, completada [COM-004] |
| listas_precios | nombre, moneda, vigencia_inicio, vigencia_fin, cliente_id nullable [COM-037] |
| listas_precios_detalle | lista_id, producto_servicio_id, ruta_id nullable, tipo_unidad nullable, precio |
| cotizaciones | folio, cliente_id / prospecto_id, fecha, vigencia_hasta, moneda, subtotal, impuestos, total, estado (borrador/enviada/aceptada/rechazada/vencida), datos_extra jsonb, aceptada_en [COM-005] |
| cotizacion_partidas | cotizacion_id, producto_servicio_id, descripcion, cantidad, precio_unitario, descuento, impuestos jsonb, importe |
| pedidos | folio, cliente_id, cotizacion_id, fecha, orden_compra_cliente, estado (abierto/en_operacion/cerrado/facturado/cancelado), total [COM-006] |
| pedido_partidas | pedido_id, producto_servicio_id, descripcion, cantidad, precio_unitario, impuestos jsonb, importe |

## Esquema `operaciones`
| Tabla | Columnas clave |
|---|---|
| proveedores | tercero_id, dias_credito, clabe_secreto_ref_id, categoria (combustible/taller/arrendadora/aseguradora/casetas/otro), opinion_cumplimiento_estado, opinion_fecha [OPE-012, OPE-047] |
| plantillas_orden | tipo, nombre, campos jsonb, checklist_id [OPE-002] |
| ordenes | folio, tipo, plantilla_id, pedido_id → comercial.pedidos, cliente_id, sucursal_id, estado (programada/asignada/en_proceso/cerrada/facturada/cancelada), fecha_programada, fecha_inicio, fecha_cierre, responsable_id, datos jsonb [OPE-001, OPE-005] |
| asignaciones | orden_id, tipo_recurso (empleado/activo), recurso_id, rol (responsable/apoyo/equipo), desde, hasta [OPE-003, OPE-004] |
| checklists | nombre, tipo (salida_unidad/entrega/general), items jsonb [OPE-006] |
| checklist_respuestas | orden_id, checklist_id, activo_id, respondido_por, respuestas jsonb, aprobado, fecha |
| evidencias | orden_id, tipo (foto/firma/documento/sello), archivo_id, lat, lng, capturado_en, capturado_por [OPE-007] |
| consumos | orden_id, activo_id, tipo (material/horas/combustible/caseta/custodia/maniobra/viatico/otro), descripcion, cantidad, costo_unitario, importe, cfdi_recibido_id, gasto_empleado_id [OPE-008] |
| incidencias | orden_id, activo_id, tipo (retraso/falla/accidente/robo/rechazo/otro), severidad, descripcion, reportado_por, ocurrido_en, lat, lng, estado, resolucion [OPE-009] |
| activos | clave, tipo (equipo/vehiculo/computo/mobiliario/otro), descripcion, marca, modelo, anio, numero_serie, propiedad (propio/arrendado), arrendamiento_id → finanzas.arrendamientos, fecha_alta, costo_adquisicion, responsable_id, estado (activo/en_taller/baja), lectura_actual, unidad_lectura (km/horas/ciclos) [OPE-040] |
| planes_mantenimiento | activo_id, nombre, cada_km, cada_dias, ultimo_km, ultima_fecha, proximo_km, proxima_fecha [OPE-042] |
| mantenimientos | activo_id, plan_id, tipo (preventivo/correctivo), proveedor_id (taller), fecha, lectura, descripcion, costo, cfdi_recibido_id, estado (programado/en_proceso/terminado) [OPE-043, OPE-044] |
| garantias | activo_id, proveedor_id, descripcion, vigencia_fin, archivo_id [OPE-046] |

## Nota sobre esquemas de industria

El núcleo no crea ningún esquema de industria. Un satélite futuro creará el suyo y apuntará a las tablas del núcleo con llaves foráneas (por ejemplo, una tabla propia cuya llave primaria sea el `id` de `operaciones.ordenes` o de `operaciones.activos`).

**Criterio de diseño que esto impone al modelo de aquí:** `operaciones.ordenes`, `operaciones.activos`, `comercial.cotizaciones` y `personas.empleados` deben tener llave primaria estable y admitir campos adicionales sin cambiar su forma. Si algún día hay que alterar una de esas tablas para que quepa algo específico de una industria, el modelo se diseñó mal.

## Esquema `finanzas`
| Tabla | Columnas clave |
|---|---|
| cuentas_bancarias | banco, alias, ultimos_digitos, clabe_secreto_ref_id, moneda, cuenta_contable_id, saldo_inicial, fecha_saldo_inicial, activa [FIN-018] |
| cajas | nombre, responsable_id, monto_fondo, cuenta_contable_id [FIN-025] |
| movimientos_bancarios | cuenta_bancaria_id, fecha, descripcion, referencia, cargo, abono, saldo, origen (importacion/manual), hash_linea unique, conciliado [FIN-019] |
| conciliaciones | movimiento_id, documento_tipo (pago_cliente/pago_proveedor/anticipo/nomina/comision/otro), documento_id, importe, conciliado_por, automatica |
| cfdi_emitidos | tipo_comprobante (I/E/P/N), serie, folio, uuid unique, fecha_emision, fecha_timbrado, receptor_tercero_id, uso_cfdi, metodo_pago (PUE/PPD), forma_pago, moneda, tipo_cambio, subtotal, descuento, total_trasladados, total_retenidos, total, estado (borrador/timbrado/cancelacion_solicitada/cancelado/error), motivo_cancelacion, uuid_sustitucion, pedido_id, orden_id, recibo_nomina_id, complementos jsonb (pagos/nomina), xml_archivo_id, pdf_archivo_id, respuesta_pac jsonb [COM-007, OPE-010] |
| cfdi_conceptos | cfdi_id, producto_servicio_id, clave_prod_serv, clave_unidad, descripcion, cantidad, valor_unitario, importe, descuento, objeto_imp, traslados jsonb, retenciones jsonb |
| cuentas_por_cobrar | cliente_id, cfdi_id, fecha_emision, fecha_vencimiento, importe, saldo, estado (abierta/parcial/pagada/cancelada), contrarrecibo_folio, contrarrecibo_fecha, fecha_promesa_pago [FIN-020] |
| pagos_recibidos | cliente_id, fecha, forma_pago, moneda, importe, cuenta_bancaria_id, movimiento_bancario_id, cfdi_pago_id [FIN-020] |
| aplicaciones_pago | pago_id, cxc_id, importe, num_parcialidad, saldo_anterior, saldo_insoluto |
| gestiones_cobranza | cxc_id, cliente_id, fecha, tipo (recordatorio_automatico/llamada/correo/visita/portal), resultado, fecha_promesa, responsable_id [FIN-021] |
| cfdi_recibidos | uuid unique, emisor_rfc, emisor_nombre, tipo_comprobante, fecha, subtotal, iva_trasladado, iva_retenido, isr_retenido, total, metodo_pago, forma_pago, estado_sat (vigente/cancelado), xml_archivo_id, proveedor_id, clasificacion (gasto/costo/activo/nomina/no_deducible/ignorar), categoria, orden_id, activo_id, estado_registro (pendiente/registrado/ignorado) [FIN-009, FIN-010] |
| cuentas_por_pagar | proveedor_id, cfdi_recibido_id, fecha, fecha_vencimiento, importe, saldo, estado [FIN-023] |
| pagos_proveedor | proveedor_id, cuenta_bancaria_id, fecha_programada, fecha_pago, importe, estado (programado/por_autorizar/autorizado/pagado/rechazado), aprobacion_id, movimiento_bancario_id [FIN-024] |
| aplicaciones_pago_proveedor | pago_id, cxp_id, importe |
| gastos_empleado | empleado_id, anticipo_id, caja_id, fecha, concepto, importe, iva, cfdi_recibido_id, comprobante_archivo_id, orden_id, estado (capturado/comprobado/rechazado/reembolsado) [FIN-025] |
| arrendamientos | arrendador_proveedor_id, contrato_id → legal.contratos, activo_id, fecha_inicio, plazo_meses, renta_mensual, iva_renta, tasa_descuento_anual, opcion_compra, derecho_uso_inicial, pasivo_inicial, estado [FIN-038] |
| tabla_arrendamiento | arrendamiento_id, periodo, fecha, renta, interes, amortizacion_pasivo, saldo_pasivo, amortizacion_derecho_uso, poliza_id |
| provisiones | tipo (seguro_prepagado/renta_anticipada/otro), descripcion, cuenta_diferida_id, cuenta_gasto_id, monto_total, fecha_inicio, meses, monto_mensual, meses_aplicados [FIN-031] |
| declaraciones | tipo (isr_provisional/iva/retenciones/diot/contab_electronica/isn/imss/infonavit), ejercicio, periodo, base jsonb, impuesto_a_cargo, impuesto_a_favor, estado (calculada/revisada/presentada/pagada), fecha_presentacion, acuse_archivo_id [FIN-011..014, PER-015, PER-016] |
| calendario_fiscal | obligacion, ejercicio, periodo, fecha_limite, declaracion_id, estado (pendiente/cumplida/vencida) [FIN-016] |
| flujo_partidas_manuales | fecha, concepto, importe, tipo (entrada/salida), probabilidad [FIN-026] |

## Esquema `contabilidad` (solo motor contable escribe)
| Tabla | Columnas clave |
|---|---|
| cuentas | codigo, nombre, nivel, padre_id, naturaleza (deudora/acreedora), tipo (activo/pasivo/capital/ingreso/costo/gasto/orden), codigo_agrupador_sat, afectable, activa [FIN-001] |
| periodos | ejercicio, mes, estado (abierto/en_cierre/cerrado), cerrado_por, cerrado_en [FIN-007] |
| reglas_contables | evento_tipo, version, **base_acumulacion (devengado/flujo/ambas)**, condicion jsonb, partidas jsonb, activa, vigencia_desde — la base la aporta el régimen de la empresa, no el código [FIN-002, RF-052] |
| polizas_borrador | periodo_id, tipo, fecha, concepto, origen, creado_por, actualizado_en — **editable y eliminable**; no afecta saldos ni reportes; desaparece al aprobarse, que es cuando nace la póliza definitiva [FIN-003, RF-041] |
| partidas_borrador | poliza_borrador_id, orden, cuenta_id, cargo, abono, concepto, tercero_id, dimensiones jsonb — editable y eliminable [RF-041] |
| polizas | periodo_id, tipo (I/E/D), numero, fecha, concepto, origen (evento/manual/cierre/reversa/sustituta/ajuste), evento_id unique nullable, reversa_de_id, **sustituye_a_id**, **motivo_correccion**, total_cargos, total_abonos, hash, hash_anterior, creado_por — **solo inserción** [FIN-002, FIN-003, RF-042] |
| reclasificaciones | partida_origen_id, cuenta_nueva_id, tercero_nuevo_id, dimensiones_nuevas jsonb, poliza_ajuste_id, motivo, autorizado_por, creado_en — solo inserción; la partida original nunca se altera [RF-043] |
| partidas | poliza_id, orden, cuenta_id, cargo, abono, concepto, tercero_id, dimensiones jsonb (activo_id, orden_id, cliente_id, empleado_id), cfdi_uuid, rfc_tercero, monto_total_cfdi |
| saldos | cuenta_id, periodo_id, saldo_inicial, cargos, abonos, saldo_final — recalculables [FIN-004] |
| activos_contables | activo_id, cuenta_activo_id, cuenta_dep_acumulada_id, cuenta_gasto_id, moi, fecha_inicio_uso, tasa_contable_anual, tasa_fiscal_anual, valor_residual, es_derecho_uso [FIN-008] |
| depreciaciones | activo_contable_id, periodo_id, importe_contable, importe_fiscal, poliza_id |
| envios_contab_electronica | periodo_id, tipo (catalogo/balanza), tipo_envio (N/C), xml_archivo_id, generado_en [FIN-006] |

## Esquema `personas`
| Tabla | Columnas clave |
|---|---|
| puestos | nombre, departamento, puesto_jefe_id, descripcion, riesgo_trabajo_clase [PER-002] |
| empleados | numero, nombre, apellido_paterno, apellido_materno, rfc, curp, nss, codigo_postal_fiscal, email, telefono, sucursal_id, puesto_id, jefe_id, fecha_ingreso, fecha_baja, motivo_baja, tipo_contrato_sat, tipo_jornada_sat, tipo_regimen_sat, periodicidad_pago_sat, banco, clabe_secreto_ref_id, estado (activo/baja) [PER-001] |
| condiciones_salariales | empleado_id, vigencia_desde, salario_diario, salario_diario_integrado, esquema (fijo/fijo_mas_variable), tarifa_variable, registro_patronal — RLS solo rol personas/propietario [PER-005] |
| documentos_empleado | empleado_id, tipo, archivo_id, vence [PER-001] |
| contratos_laborales | empleado_id, tipo (indeterminado/determinado/prueba/capacitacion_inicial), fecha_inicio, fecha_fin, archivo_id, estado [PER-003] |
| incidencias_nomina | empleado_id, tipo (falta/incapacidad/hora_extra_doble/hora_extra_triple/prima_dominical/permiso_con_goce/permiso_sin_goce/variable/bono), fecha, cantidad, referencia, aprobada, periodo_nomina_id [PER-009] |
| saldos_vacaciones | empleado_id, anio_servicio, dias_derecho, dias_tomados, vence |
| solicitudes_vacaciones | empleado_id, desde, hasta, dias, estado, aprobacion_id [PER-011] |
| periodos_nomina | tipo (ordinaria/extraordinaria), periodicidad, fecha_inicio, fecha_fin, fecha_pago, estado (abierto/calculado/autorizado/timbrado/dispersado/cerrado) [PER-005] |
| recibos_nomina | periodo_id, empleado_id, dias_pagados, total_percepciones, total_deducciones, total_otros_pagos, isr_retenido, subsidio_causado, imss_obrero, neto, cfdi_id, estado [PER-005..007] |
| recibo_conceptos | recibo_id, tipo (percepcion/deduccion/otro_pago), clave_sat, clave_interna, descripcion, importe_gravado, importe_exento, importe |
| dispersiones | periodo_id, cuenta_bancaria_id, archivo_layout_id, total, estado [PER-008] |
| movimientos_imss | empleado_id, tipo (alta/baja/modificacion_salario), fecha, sdi, motivo, archivo_id, estado (generado/presentado) [PER-004] |
| creditos_empleado | empleado_id, tipo (infonavit/fonacot), numero_credito, tipo_descuento, valor, activo [PER-015] |
| cuotas_seguridad_social | empleado_id, periodo (mes/bimestre), cuotas jsonb por ramo, infonavit_patronal, amortizacion_infonavit, total [PER-015] |
| isn_calculos | periodo, estado_entidad, base, tasa, impuesto [PER-016] |

## Esquema `legal`
| Tabla | Columnas clave |
|---|---|
| contratos | tipo (cliente/proveedor/arrendamiento/otro), tercero_id, titulo, fecha_inicio, fecha_fin, renovacion_automatica, dias_aviso, monto, archivo_id, estado [LEG-001] |
| permisos | tipo (federal/estatal/municipal/otro), numero, autoridad, activo_id nullable, vigencia_inicio, vigencia_fin, archivo_id [LEG-008] |
| polizas_seguro | aseguradora_proveedor_id, numero, tipo (rc/carga/unidad/otro), activo_id nullable, suma_asegurada, deducible, prima, vigencia_inicio, vigencia_fin, archivo_id, provision_id [LEG-023] |
| siniestros | poliza_id, fecha, tipo, activo_id, orden_id, incidencia_id, descripcion, monto_reclamado, monto_pagado, deducible_pagado, estado [LEG-024] |

## Esquema `direccion`
| Tabla | Columnas clave |
|---|---|
| objetivos | ejercicio, periodo, nombre, indicador (clave de métrica), meta, responsable_id [DIR-004] |
| reglas_alerta | tipo, parametros jsonb, dias_anticipacion, rol_destino, activa [DIR-002] |

## Esquema `analitica` (vistas de solo lectura)
| Vista | Cálculo |
|---|---|
| v_rentabilidad_orden | ingreso (subtotal CFDI) − consumos de la orden (materiales, servicios de terceros, gastos) − costo de las horas de personal asignado − depreciación prorrateada de los activos usados = margen y % [FIN-044] |
| v_costo_por_activo | costos acumulados por activo en el periodo (consumos, mantenimiento, seguros, depreciación) y costo por unidad de uso (km u horas) cuando el activo lleva lectura [FIN-043] |
| v_rentabilidad_cliente / v_rentabilidad_linea | agregados de v_rentabilidad_orden [FIN-043, FIN-044] |
| v_cxc_antiguedad | saldo por cliente en 0-30, 31-60, 61-90, +90 días [FIN-020, FIN-021] |
| v_flujo_13_semanas | saldos bancarios + CxC por fecha promesa/vencimiento + CxP programadas + nómina + partidas manuales [FIN-026] |
| v_estado_resultados / v_balance | desde contabilidad.saldos [FIN-005, FIN-030] |
| v_tablero_ejecutivo | ventas, margen, flujo, CxC vencida, utilización de unidades, alertas abiertas [DIR-001] |

## Relaciones clave
```
terceros ─┬─ clientes ─ cotizaciones ─ pedidos ─ ordenes ─ cfdi_emitidos ─ cuentas_por_cobrar ─ aplicaciones_pago ─ pagos_recibidos
          └─ proveedores ─ cfdi_recibidos ─ cuentas_por_pagar ─ pagos_proveedor
ordenes ─ asignaciones ─ (empleados | activos) · ordenes ─ evidencias · consumos · incidencias
activos ─ unidades · planes_mantenimiento · mantenimientos · verificaciones · permisos · polizas_seguro · arrendamientos
empleados ─ condiciones_salariales · incidencias_nomina · recibos_nomina ─ cfdi_emitidos(N)
eventos_outbox ─ polizas (evento_id) ─ partidas ─ cuentas
```
