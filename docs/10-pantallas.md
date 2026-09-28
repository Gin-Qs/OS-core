# 10 · Pantallas y navegación

## Navegación web (menú lateral según rol)
| Área | Pantallas |
|---|---|
| Inicio | Tablero por rol · Mis pendientes (aprobaciones, alertas, tareas) |
| Dirección | Tablero ejecutivo · Alertas · Objetivos · Juntas y acuerdos · Rentabilidad (por línea, cliente y sucursal) |
| Comercial | Prospectos · Oportunidades (kanban) · Clientes (ficha 360: contactos, cotizaciones, pedidos, facturas, saldo) · Actividades · Listas de precios · Cotizaciones · Pedidos · Marketing (campañas, formularios, contenido) · Servicio (tickets, SLA, base de conocimiento) |
| Operaciones | Órdenes (lista + kanban por estado) · Agenda de recursos (calendario de personas y equipos) · Checklists · Incidencias · Proveedores · Requisiciones y órdenes de compra · Recepciones · Inventario (si está activado) · Activos (ficha: mantenimientos, costos, garantías, seguros, permisos, verificaciones) · Planes y órdenes de mantenimiento |
| Finanzas | Bancos y movimientos · Conciliación bancaria · Facturación (emitidos, timbrar, cancelar) · Cuentas por cobrar (antigüedad) · Cobranza (agenda de gestiones) · Buzón CFDI (clasificar recibidos) · Cuentas por pagar · Programación y autorización de pagos · Gastos y comprobaciones · Arrendamientos · Pagos anticipados · Flujo de efectivo 13 semanas · Impuestos (ISR, IVA, retenciones, DIOT) · Calendario fiscal |
| Contabilidad | Catálogo de cuentas · Pólizas (consulta y manuales) · Libros y balanza · Estados financieros · Cierre de periodo (checklist) · Contabilidad electrónica · Reglas contables (solo Contabilidad) |
| Personas | Empleados (expediente) · Seguridad y salud (NOM-035, accidentes, EPP) · Puestos y organigrama · Contratos · Incidencias · Vacaciones · Nómina (periodos: calcular → revisar → autorizar → timbrar → dispersar) · Movimientos IMSS · SUA/INFONAVIT/FONACOT · ISN |
| Legal | Contratos · Solicitudes de contrato · Firma electrónica · Documentos corporativos y poderes · Marcas · Permisos y licencias |
| Configuración | Empresa · Usuarios y roles · Integraciones · Reglas de aprobación · Reglas de alertas · Parámetros fiscales (solo lectura) · Respaldos |

## PWA móvil
### Campo (quien ejecuta el trabajo)
1. Mis órdenes (hoy / próximas)
2. Detalle de orden → **Iniciar** (checklist de arranque con fotos)
3. Durante la ejecución: registrar consumos con foto del comprobante, reportar incidencia con ubicación
4. **Cerrar**: fotos de evidencia, firma del cliente, lectura final (funciona sin conexión y sincroniza al volver)
5. Mis gastos y comprobaciones
6. Mis recibos de nómina · Solicitar vacaciones
### Colaborador
Mis recibos · Vacaciones y permisos · Mis gastos

## Componentes reutilizables
Tabla con filtros/exportación · Formulario con validación Zod · Ficha con pestañas · Kanban · Calendario de recursos · Timeline de eventos y bitácora · Visor de archivos · Selector de catálogos SAT · Captura de foto/firma/ubicación · Tarjetas KPI · Barra de aprobación.

## Principios de UI
Español de México · montos con separador de miles y 2 decimales · estados con color consistente · toda acción destructiva pide confirmación · acciones visibles solo si el rol tiene permiso.
