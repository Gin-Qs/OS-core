# 06 · Matriz de roles y permisos V1 (A3)

> **Roles del núcleo.** *Operaciones* coordina y despacha el trabajo; *Campo* es quien lo ejecuta y solo ve lo propio; *Colaborador* es cualquier empleado en su propio espacio (recibos, vacaciones, gastos). Un satélite de industria podría renombrarlos para su giro, pero no agrega roles nuevos.

Acciones: V ver · C crear · E editar · A aprobar · X exportar · — sin acceso · (p) solo propios.
El Administrador gestiona usuarios, roles, configuración e integraciones, sin acceso a contenido de negocio. El Propietario tiene todo.

| Recurso | Dirección | Tesorería | Contabilidad | Personas | Comercial | Operaciones | Campo | Colaborador |
|---|---|---|---|---|---|---|---|---|
| comercial.prospectos / oportunidades / actividades | V X | — | — | — | V C E X | V | — | — |
| comercial.clientes | V X | V | V | — | V C E X | V | — | — |
| comercial.clientes.credito | V A | V E | V | — | V | — | — | — |
| comercial.listas_precios | V A | — | — | — | V C E | V | — | — |
| comercial.cotizaciones / pedidos | V A X | V | V | — | V C E X | V | — | — |
| operaciones.ordenes / asignaciones | V X | V | V | — | V | V C E X | V (p) E (p) | — |
| operaciones.checklists / evidencias / incidencias | V | — | — | — | V | V C E | C (p) V (p) | — |
| operaciones.consumos | V X | V | V | — | — | V C E | C (p) | — |
| operaciones.proveedores | V | V C E | V | — | — | V C | — | — |
| operaciones.activos / mantenimientos / garantias | V X | V | V | — | — | V C E X | V (p) | — |
| finanzas.bancos / conciliacion | V X | V C E X | V E X | — | — | — | — | — |
| finanzas.cfdi_emitidos (timbrar/cancelar) | V | V | V C E | — | V C (desde pedido) | — | — | — |
| finanzas.cxc / cobranza | V X | V C E X | V | — | V | — | — | — |
| finanzas.cfdi_recibidos / cxp | V X | V C E | V C E X | — | — | V (clasificar op.) | — | — |
| finanzas.pagos_proveedor | V A | V C E | V | — | — | — | — | — |
| finanzas.gastos_empleado | V A | V E A | V E | — | C (p) | C (p) A | C (p) | C (p) |
| finanzas.arrendamientos / provisiones | V | V | V C E | — | — | — | — | — |
| finanzas.declaraciones / calendario | V | V | V C E X | V (isn, imss) | — | — | — | — |
| contabilidad.polizas manuales / cierre | V | — | V C A X | — | — | — | — | — |
| contabilidad.reportes (EF, balanza) | V X | V X | V X | — | — | — | — | — |
| analitica.rentabilidad / costeo | V X | V | V X | — | V (clientes) | V (unidades/rutas) | — | — |
| personas.empleados / expedientes / contratos | V | — | — | V C E X | — | V (su equipo) | V (p) | V (p) |
| personas.condiciones_salariales | — | — | — | V C E | — | — | — | — |
| personas.nomina / imss / isn | V A (totales) | V (dispersión) | V (póliza) | V C E X | — | — | V (p recibos) | V (p recibos) |
| personas.incidencias / vacaciones | V | — | — | V C E A | — | C A (su equipo) | C (p) | C (p) |
| legal.contratos / permisos / polizas_seguro / siniestros | V A X | V | V | — | V (clientes) | V C E | — | — |
| direccion.tablero / objetivos / alertas | V C E X | V (propias) | V (propias) | V (propias) | V (propias) | V (propias) | V (p) | V (p) |

Notas
- Dirección no ve salarios individuales ni datos médicos; ve totales de nómina.
- Montos de aprobación en `plataforma.reglas_aprobacion` (ej. pagos > umbral requieren Dirección).
- Alcance `(p)`: el rol Campo solo ve las órdenes asignadas a él, sus gastos y sus recibos. El Colaborador solo ve lo suyo.
- Toda acción de servidor usa `requirePermiso(recurso, accion)`; RLS protege por empresa y, para `(p)`, por usuario.

---

## Quién puede asignar roles

Solo **Administrador** y **Propietario**. Ningún otro rol reparte accesos, por alto que sea: Dirección ve toda la operación y no asigna un solo permiso.

| Quien asigna | Qué puede hacer | Límite |
|---|---|---|
| **Administrador** | Crear usuarios, asignar y retirar roles a cualquier persona de la empresa, dar accesos temporales con vencimiento | No puede otorgarse a sí mismo acceso a contenido de negocio, ni asignarse una combinación incompatible: eso lo autoriza el Propietario (`RF-005`, `RF-032`) |
| **Propietario** | Todo lo anterior, y además **autorizar** las combinaciones incompatibles con un motivo registrado | No puede dejar a la empresa sin Propietario activo (`RF-033`) |

El candado es el de siempre: quien reparte las llaves no se queda con una. Toda alta, cambio y baja de rol queda en bitácora con autor y momento.

---

## Un usuario puede tener varios roles

En una empresa de 15 personas, la misma persona lleva Tesorería y Contabilidad. El sistema lo reconoce en lugar de obligar a inventar un segundo usuario: **un usuario puede tener varios roles dentro de la misma empresa**, y sus permisos son la **unión** de ellos (`RF-031`).

Cómo se resuelve la unión, sin ambigüedad:

| Situación | Resultado |
|---|---|
| Dos roles con distinta acción sobre el mismo recurso | La acción más amplia. Tesorería `V C E` + Contabilidad `V E X` = `V C E X` |
| Dos roles con distinto alcance sobre el mismo recurso | El alcance más amplio. `(p)` propios + todos = todos |
| Un rol da acceso y el otro no lo menciona | Da acceso. La ausencia no niega; solo la falta de todo rol que lo otorgue niega |
| Campos sensibles (salarios individuales) | Los otorga el rol Personas o Propietario. Acumular Dirección + Comercial no los alcanza nunca |

El sistema muestra los **permisos efectivos** de cualquier usuario en una sola pantalla, indicando qué rol origina cada permiso. Sin esa pantalla, apilar roles se vuelve imposible de auditar.

**Propietario no se combina.** Ya contiene todo; asignarlo retira los demás roles de esa empresa (`RF-033`). Y una empresa nunca puede quedarse sin al menos un Propietario activo.

---

## Combinaciones incompatibles (segregación de funciones)

Apilar roles es lo que rompe la segregación de funciones que el sistema promete vigilar (`RF-159`, `FIN-048`). No se prohíben —en una empresa chica son inevitables—, pero **se bloquean hasta que el Propietario las autorice con un motivo**, y la excepción queda visible en el reporte de control interno mientras exista (`RF-032`).

| Combinación | Control que rompe | Por qué importa |
|---|---|---|
| Tesorería + Dirección | Quien solicita el pago lo aprueba | Un pago sobre umbral podría salir sin que nadie más lo viera |
| Tesorería + Contabilidad | Quien mueve el dinero registra el movimiento | Un faltante puede ocultarse con el asiento que lo explica |
| Comercial + Contabilidad | Quien vende registra el ingreso | Reconocer ventas que no ocurrieron deja de tener freno |
| Comercial + Tesorería | Quien vende cobra y aplica el pago | Un cobro puede aplicarse a otra cuenta sin que se note |
| Administrador + cualquier rol de negocio | Quien otorga los accesos los usa | El administrador podría darse permisos y operar con ellos |
| Personas + Tesorería | Quien da de alta al empleado dispersa su nómina | Un empleado inexistente puede cobrar |

**El control real es sobre la persona, no sobre el rol.** Aunque una excepción esté autorizada, quien captura un pago **nunca** puede aprobarlo él mismo, aunque acumule el rol que aprueba (`RN-013`, `RF-152`). La excepción abre el acceso; no apaga la segregación en la operación concreta.

**Lo que hay que construir para sostener esto:** la pantalla de permisos efectivos, la matriz de incompatibilidades como semilla editable, el flujo de autorización con motivo, y la línea permanente en el reporte de control interno. Sin la última, apilar roles se vuelve una puerta que nadie vuelve a mirar.
