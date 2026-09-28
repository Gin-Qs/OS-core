## 14. Calidad, pruebas y aceptación

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`) son estables y se referencian entre documentos.

### 14.1 Estrategia de pruebas

| Nivel | Herramienta | Alcance obligatorio |
|---|---|---|
| Unitaria | Vitest | Motores fiscal, contable y de nómina: **100% de las reglas** cubiertas por caso dorado (`RNF-095`). Resto del dominio: la lógica de negocio, no los accesorios |
| Integración | Vitest + base de datos local | Evento → suscriptor → póliza. Aislamiento por empresa. Adaptadores contra ambiente de pruebas del proveedor |
| Extremo a extremo | Playwright | Los cuatro flujos de §14.3 |
| Seguridad | Pruebas específicas | Aislamiento entre empresas, permisos por rol, campos sensibles, segregación de funciones |
| Carga | Pruebas programadas | Umbrales de §8.1 con el volumen de `RNF-030` |
| Sin conexión | Manual y automatizada | Captura completa en modo avión, con reconexión y verificación de integridad |

### 14.2 Casos dorados

Un caso dorado es un escenario con entradas y resultado esperado exactos, **revisado y firmado por el contador antes de programar el motor correspondiente**. Se almacenan como datos de prueba versionados.

| ID | Escenario | Verifica |
|---|---|---|
| `CD-01` | Factura de servicio PPD a persona moral, con y sin retención | XML esperado + póliza `R-01` |
| `CD-02` | Pago parcial de `CD-01` | Complemento de pago + póliza `R-03` + reconocimiento de IVA cobrado |
| `CD-03` | Cancelación con sustitución | Estados del CFDI + póliza de reversa |
| `CD-04` | CFDI recibido PUE pagado por un empleado con anticipo | Pólizas `R-06` y `R-09` |
| `CD-05` | Arrendamiento de un activo bajo NIF D-5: tabla a 36 meses | Pólizas `R-12`, `R-13`, `R-14` + depreciación + cierre |
| `CD-06` | Nómina quincenal con salario base más percepción variable | ISR, subsidio, SDI, cuotas, neto + póliza `R-10` |
| `CD-07` | IVA mensual con retenciones cobradas | Cálculo cuadrado contra balanza |
| `CD-08` | Pago provisional de ISR con coeficiente y pagos previos | Cálculo coincidente con el del contador |
| `CD-09` | DIOT del mes | Archivo aceptado sin ajustes |
| `CD-10` | Rentabilidad de una orden con consumos, horas y depreciación | Margen correcto |

**Regla sobre los casos dorados.** Cuando un cálculo del sistema difiere del del contador, se investiga cuál está bien. Si el sistema está mal, se corrige la regla —que es dato, no código— y se recalcula. Si el contador estaba equivocado, se actualiza el caso dorado **con su firma**. Nunca se ajusta el resultado para que coincida.

### 14.3 Flujos de aceptación extremo a extremo

| # | Flujo | Recorrido completo |
|---|---|---|
| 1 | **Ingreso** | Cotización → pedido → orden de trabajo → ejecución con evidencia → cierre → CFDI → póliza → CxC → cobro → complemento → conciliación bancaria → margen |
| 2 | **Egreso** | Descarga del SAT → clasificación → CxP → autorización → pago → layout → póliza → conciliación |
| 3 | **Nómina** | Incidencias → cálculo → revisión → autorización → timbrado → dispersión → pólizas → movimientos IMSS |
| 4 | **Cierre** | Conciliaciones → depreciación y provisiones → balanza → impuestos → estados financieros → cierre bloqueado → contabilidad electrónica |

### 14.4 Definición de terminado

Una tarea no está terminada hasta que cumple **todas** estas condiciones:

1. Migración de base de datos con su política de aislamiento en el mismo archivo.
2. Tipos regenerados desde el esquema.
3. Lógica cubierta por pruebas; si toca dinero, impuestos o nómina, su caso dorado en verde.
4. Eventos publicados conforme al catálogo.
5. Interfaz mínima funcional y protegida por permisos en el servidor.
6. Verificación automática (análisis estático, tipos, pruebas, fronteras de módulo) en verde.
7. Estado de la tarea actualizado en el plan de construcción.
8. Si se desvió de una regla de arquitectura, su ADR registrado.

### 14.5 Criterios de aceptación del sistema completo

El sistema se acepta cuando, sobre una empresa real, se cumplen simultáneamente los criterios `CE-01` a `CE-07` de §4.4, y además:

| # | Criterio adicional | Verificación |
|---|---|---|
| 8 | Todos los casos dorados en verde | Reporte de pruebas |
| 9 | Los cuatro flujos extremo a extremo completos | Playwright |
| 10 | Prueba de aislamiento entre empresas sin hallazgos | Suite de seguridad |
| 11 | Restauración de respaldo verificada | Bitácora de la prueba trimestral |
| 12 | Umbrales de rendimiento de §8.1 cumplidos con el volumen de `RNF-030` | Prueba de carga |
| 13 | Operación en paralelo durante dos cierres, con diferencias resueltas | Visto bueno escrito del contador |

---

---

[← 13-escalabilidad-y-evolucion](./13-escalabilidad-y-evolucion.md) · [Índice](./00-indice.md) · [15-riesgos →](./15-riesgos.md)
