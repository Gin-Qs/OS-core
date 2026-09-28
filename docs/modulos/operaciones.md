# Módulo · Operaciones
**Propósito:** ejecutar el servicio (órdenes) y administrar activos y proveedores.
**Funciones:** OPE-001..010, OPE-012, OPE-040, OPE-042..044, OPE-046, OPE-047.
**Tablas:** esquema `operaciones`.
**Publica:** orden_asignada, orden_cerrada, consumo_registrado, incidencia_reportada, activo_registrado, mantenimiento_vencido, mantenimiento_terminado. **Escucha:** comercial.pedido_creado (crea orden), finanzas.cfdi_recibido_registrado (liga costo a orden/activo).
**Reglas:**
- Estados de orden: programada → asignada → en_proceso → cerrada → facturada (o cancelada). Cerrar exige evidencias si la plantilla lo pide.
- Un recurso no puede estar asignado a dos órdenes con horarios traslapados.
- Activo en taller o con mantenimiento crítico vencido no es asignable.
- Plan de mantenimiento: próximo = último + intervalo (por lectura de uso o por días); se recalcula al terminar mantenimiento o actualizar lectura.
- Consumos siempre ligados a orden y/o activo (base del costeo).
**Pantallas:** doc 10 Operaciones. **Pruebas:** traslapes, bloqueo por mantenimiento, cierre sin evidencia.
