# 12 · Pruebas y calidad

## Niveles
| Nivel | Herramienta | Cobertura mínima |
|---|---|---|
| Unidad | Vitest | Motores fiscal, contable, nómina, costeo: 100% de reglas con casos dorados |
| Base de datos | Pruebas SQL (pgTAP o scripts) | RLS por empresa y por rol; inmutabilidad del libro; cuadre de pólizas |
| Integración | Vitest + Supabase local | Evento → suscriptor → póliza; PAC en sandbox |
| E2E | Playwright | Los 4 flujos de punta a punta |

## Casos dorados (validados por el contador ANTES de programar cada motor)
Cada caso: entradas, resultado esperado y firma del contador. Guardar en `src/engines/*/__tests__/golden/*.json`.
- CD-01 Factura de servicio PPD a persona moral, con y sin retención → XML esperado + póliza R-01.
- CD-02 Pago parcial de CD-01 → complemento de pago + póliza R-03.
- CD-03 Cancelación con sustitución.
- CD-04 CFDI recibido PUE pagado por un empleado con anticipo → R-06/R-09.
- CD-05 Arrendamiento de un activo (NIF D-5): tabla de amortización a 36 meses + pólizas R-12, R-13, R-14.
- CD-06 Nómina quincenal con salario base más percepción variable → ISR, subsidio, IMSS, neto, póliza R-10.
- CD-07 IVA mensual con retenciones cobradas.
- CD-08 Pago provisional de ISR.
- CD-09 DIOT del mes.
- CD-10 Rentabilidad de una orden de trabajo con consumos, horas y depreciación.
- CD-11 Misma venta, dos regímenes: en devengado la factura acumula el ingreso; en flujo lo acumula el cobro. Mismas reglas contables, sin condicional por régimen.
- CD-12 Pago provisional de ISR en cada régimen soportado, con su papel de trabajo paso a paso, contra el cálculo del contador.
- CD-13 Recálculo de un periodo anterior con la definición y los parámetros vigentes entonces: resultado idéntico al original.
- CD-14 Facilidades administrativas del autotransporte de un ejercicio: cambia la mecánica, no solo la tasa, y se resuelve cargando una versión nueva de la definición.

## Flujos E2E
1. Ingreso: cotización → pedido → orden de trabajo → asignación → checklist → ejecución con evidencia → cierre → CFDI → póliza → CxC → cobro → complemento de pago → conciliación bancaria → rentabilidad.
2. Egreso: CFDI recibido → CxP → autorización → pago → póliza → conciliación.
3. Nómina: incidencias → cálculo → autorización → timbrado → dispersión → pólizas.
4. Cierre: conciliaciones → depreciación/amortización/provisiones → cierre → IVA, ISR, DIOT, balanza XML.

## Seguridad
- Usuario de empresa A nunca lee datos de empresa B (prueba por cada tabla).
- El rol Campo solo ve las órdenes asignadas a él; nadie fuera de Personas lee `condiciones_salariales`.
- Intentos de UPDATE/DELETE en `contabilidad.polizas` fallan.
- Secretos nunca aparecen en respuestas ni en logs.

## Puesta en marcha
Operación en paralelo con el contador durante 2 cierres: balanza, IVA, ISR y nómina deben coincidir. Diferencias se documentan y corrigen antes de apagar el proceso anterior.
