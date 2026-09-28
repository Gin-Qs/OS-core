# Módulo · Comercial
**Propósito:** conseguir clientes, cotizar y convertir en pedidos.
**Funciones:** COM-001..007, COM-037, FIN-022 (datos de crédito del cliente).
**Tablas:** esquema `comercial` + `plataforma.terceros`, `plataforma.productos_servicios`.
**Publica:** cliente_creado, cotizacion_aceptada, pedido_creado. **Escucha:** finanzas.pago_recibido (recalcula crédito disponible), fiscal.cfdi_timbrado (liga factura a pedido).
**Reglas:**
- RFC válido y régimen/CP fiscal obligatorios para facturar; sin ellos el cliente queda "no facturable".
- Crédito disponible = límite − saldo CxC; si excede o hay vencidos > N días → estado bloqueado (no permite nuevo pedido sin aprobación de Dirección).
- Cotización vence en `vigencia_hasta`; al aceptarse genera pedido (evento) y queda inmutable.
- Pedido guarda `orden_compra_cliente` (clientes institucionales la exigen en la factura).
- Precio: lista del cliente → lista general → captura manual (requiere permiso).
**Pantallas:** doc 10 Comercial. **Pruebas:** bloqueo por crédito, conversión cotización→pedido→orden.
