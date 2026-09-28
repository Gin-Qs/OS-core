# Finanzas — 67 funciones

Prefijo `FIN` · claves `FIN-001` a `FIN-067` · esquema de base de datos `finanzas` + `contabilidad` · 6 departamentos

**Nivel:** `E` Esencial (plan Basic) · `P` Profesional (Pro) · `A` Avanzado (Max). Cada plan incluye los niveles anteriores.

## Cómo se edita este archivo

- Una fila es una función. **Las claves son estables**: se usan en los commits, en el plan de construcción y en las pruebas. No se renumeran ni se reutilizan.
- Para **agregar** una función: se toma el siguiente número libre del área (`FIN-068`), aunque quede al final de la tabla del departamento que le toca.
- Para **quitar** una función: se marca `retirada` en Notas y se deja la fila. Borrarla libera una clave que ya vive en otros documentos.
- Para **mover** una función de nivel: se cambia la columna Nivel. Eso cambia en qué plan aparece, no su clave.
- La columna **Notas** está vacía a propósito: es para decisiones, dudas y recordatorios.

## Resumen por departamento

| Departamento | E | P | A | Total |
|---|---|---|---|---|
| Contabilidad | 8 | 5 | 2 | 15 |
| Fiscal | 9 | 4 | 2 | 15 |
| Tesorería | 10 | 4 | 2 | 16 |
| Control de Gestión / FP&A | 0 | 7 | 2 | 9 |
| Contraloría | 0 | 4 | 2 | 6 |
| Riesgos Financieros | 0 | 0 | 6 | 6 |
| **Total** | **27** | **24** | **16** | **67** |

---

## Contabilidad (15)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `FIN-001` | Catálogo de cuentas | E | Cuentas contables con código agrupador del SAT y plantillas por giro | |
| `FIN-002` | Pólizas automáticas | E | Cada venta, compra, cobro, pago y nómina genera su póliza sin captura | |
| `FIN-003` | Pólizas manuales | E | Pólizas de ingreso, egreso y diario para ajustes | |
| `FIN-004` | Libros y balanza | E | Libro diario, mayor, auxiliares y balanza de comprobación | |
| `FIN-005` | Estados financieros | E | Balance general y estado de resultados en tiempo real | |
| `FIN-006` | Contabilidad electrónica | E | Catálogo, balanza y pólizas en XML para el SAT | |
| `FIN-007` | Cierre de periodo | E | Cierre mensual y anual con bloqueo de periodos cerrados | |
| `FIN-008` | Depreciación | E | Depreciación contable y fiscal automática de activos | |
| `FIN-028` | Centros de costo | P | Clasifica ingresos y gastos por sucursal, proyecto o unidad | |
| `FIN-029` | Multimoneda | P | Operaciones en moneda extranjera y revaluación cambiaria automática | |
| `FIN-030` | Estados financieros completos | P | Estado de flujo de efectivo y de cambios en el capital contable | |
| `FIN-031` | Provisiones y amortizaciones | P | Gastos anticipados, provisiones y diferidos | |
| `FIN-032` | Checklist de cierre | P | Tareas de cierre con responsables y fechas | |
| `FIN-052` | Consolidación multiempresa | A | Estados consolidados con eliminación de operaciones entre empresas | |
| `FIN-053` | Reportes NIF / IFRS | A | Estados bajo normas completas para bancos, consejo o inversionistas | |

## Fiscal (15)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `FIN-009` | Buzón de CFDI | E | Descarga masiva del SAT de facturas emitidas y recibidas con validación de estatus | |
| `FIN-010` | Conciliación CFDI vs contabilidad | E | Detecta facturas no registradas o registros sin factura | |
| `FIN-011` | Pagos provisionales ISR | E | Cálculo mensual de ISR con coeficiente de utilidad | |
| `FIN-012` | IVA mensual | E | IVA trasladado, acreditable y retenido en flujo de efectivo | |
| `FIN-013` | Retenciones | E | Retenciones de ISR e IVA por honorarios, arrendamiento y fletes | |
| `FIN-014` | DIOT | E | Declaración informativa de operaciones con terceros generada desde compras | |
| `FIN-015` | Declaración anual y PTU | E | Cálculo del ISR anual y de la base de PTU | |
| `FIN-016` | Calendario fiscal | E | Todas las obligaciones fiscales con fechas y alertas | |
| `FIN-017` | Validación de proveedores | E | Opinión de cumplimiento y revisión en lista 69-B (EFOS) | |
| `FIN-033` | Papeles de trabajo | P | Soporte detallado de cada cálculo fiscal | |
| `FIN-034` | Saldos a favor | P | Devoluciones y compensaciones con seguimiento | |
| `FIN-035` | Expediente de revisiones | P | Requerimientos y auditorías del SAT con su documentación | |
| `FIN-036` | Estímulos fiscales | P | Control de estímulos aplicables a la empresa | |
| `FIN-054` | Simulación fiscal | A | Escenarios del impacto fiscal de decisiones de negocio | |
| `FIN-055` | ISSIF / dictamen | A | Información fiscal requerida para empresas grandes | |

## Tesorería (16)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `FIN-018` | Bancos y cajas | E | Cuentas bancarias y cajas con saldos en tiempo real | |
| `FIN-019` | Conciliación bancaria | E | Importa estados de cuenta y concilia automáticamente | |
| `FIN-020` | Cuentas por cobrar | E | Antigüedad de saldos y complemento de pago al cobrar | |
| `FIN-021` | Cobranza | E | Recordatorios automáticos y estados de cuenta a clientes | |
| `FIN-022` | Crédito a clientes (onboarding) | E | Límite y días de crédito por cliente con bloqueo por vencimiento | |
| `FIN-023` | Cuentas por pagar | E | Calendario de pagos a proveedores | |
| `FIN-024` | Autorización de pagos | E | Programación de pagos con flujo de aprobación | |
| `FIN-025` | Caja chica y gastos | E | Fondos fijos, anticipos y comprobación de gastos de empleados | |
| `FIN-026` | Flujo de efectivo | E | Flujo real y proyectado a 13 semanas | |
| `FIN-027` | Presupuesto simple | E | Presupuesto mensual comparado contra lo real | |
| `FIN-037` | Layouts bancarios | P | Archivos de pago y dispersión masiva para el banco | |
| `FIN-038` | Financiamiento | P | Créditos y arrendamientos con tabla de amortización y covenants | |
| `FIN-039` | Inversiones | P | Control de inversiones de tesorería y rendimientos | |
| `FIN-040` | Posición multimoneda | P | Saldos y flujo por moneda | |
| `FIN-056` | Factoraje | A | Cesión de cuentas por cobrar y su costo financiero | |
| `FIN-057` | Tesorería centralizada | A | Concentración de efectivo entre empresas del grupo | |

## Control de Gestión / FP&A (9)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `FIN-041` | Presupuesto anual | P | Presupuesto por centro de costo con flujo de aprobación | |
| `FIN-042` | Presupuesto vs real | P | Desviaciones contra presupuesto con alertas | |
| `FIN-043` | Costeo | P | Costo real por producto, servicio o cliente | |
| `FIN-044` | Rentabilidad | P | Margen por línea, cliente, sucursal y vendedor | |
| `FIN-045` | KPIs financieros | P | Márgenes, EBITDA, capital de trabajo y ROIC | |
| `FIN-046` | Proyecciones y escenarios | P | Estados financieros proyectados con escenarios | |
| `FIN-047` | Evaluación de inversiones | P | VPN, TIR y periodo de recuperación de proyectos | |
| `FIN-058` | Forecast continuo | A | Pronóstico rodante actualizado cada mes | |
| `FIN-059` | Presupuesto por drivers | A | Presupuesto construido a partir de variables operativas | |

## Contraloría (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `FIN-048` | Matriz de autorizaciones | P | Quién aprueba qué y hasta qué monto | |
| `FIN-049` | Controles internos | P | Segregación de funciones y controles clave | |
| `FIN-050` | Revisión de pólizas | P | Revisión y aprobación de ajustes contables | |
| `FIN-051` | Arqueos e inventarios físicos | P | Conteos de caja, activos e inventario | |
| `FIN-060` | Reportes al consejo | A | Paquete financiero mensual para consejo o socios | |
| `FIN-061` | Detección de anomalías con IA | A | Pagos duplicados, proveedores sospechosos y gastos atípicos | |

## Riesgos Financieros (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `FIN-062` | Exposición cambiaria | A | Posición en moneda extranjera y sensibilidad al tipo de cambio | |
| `FIN-063` | Coberturas | A | Registro y valuación de forwards, opciones y swaps | |
| `FIN-064` | Riesgo de tasas | A | Sensibilidad de la deuda a cambios en tasas de interés | |
| `FIN-065` | Riesgo de commodities | A | Exposición a precios de insumos como diésel, acero o granos | |
| `FIN-066` | Riesgo de crédito | A | Scoring de clientes y probabilidad de impago | |
| `FIN-067` | Stress testing | A | Escenarios extremos y valor en riesgo (VaR) | |

---

## Micro apps del área

- **E:** IVA · ISR (morales, RESICO) · Recargos y actualizaciones SAT · Tabla de amortización · Punto de equilibrio · Tipo de cambio DOF/Banxico · Validador RFC/CFDI/69-B
- **P:** Compra vs arrendamiento · VPN/TIR
- **A:** Calculadora de coberturas

Las micro apps son calculadoras independientes: no escriben en la base de datos de negocio, solo leen parámetros vigentes. No llevan clave porque no son funciones del catálogo.

## Agentes de IA del área

- **E:** Cobranza · Conciliación
- **P:** Cierre · Fiscal

Todo agente hereda los permisos del usuario que lo invoca. Un agente nunca ve lo que su usuario no puede ver.

## Reglas del área

- El libro contable es inmutable: solo el motor contable escribe en `contabilidad.*`, y los errores se corrigen con póliza de reversa.
- El IVA se causa al cobrar y se acredita al pagar (IVA en flujo): tesorería y contabilidad no pueden construirse por separado.
- Ningún parámetro fiscal vive en código. Todos salen de `plataforma.parametros_fiscales` con vigencia por fecha.
- El catálogo de productos y servicios y el maestro de terceros viven en la plataforma, no aquí.
