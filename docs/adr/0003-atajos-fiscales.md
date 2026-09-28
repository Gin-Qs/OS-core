# ADR-0003 · Delegar el sellado de CFDI y la descarga masiva a un proveedor

- **Fecha:** 2026-09-17
- **Estado:** propuesta — pendiente de confirmación

## Contexto
Emitir un CFDI implica construir la cadena original con una transformación XSLT oficial, firmarla con el CSD y manejar la criptografía correspondiente. Bajar los CFDI recibidos del SAT implica un servicio SOAP autenticado con e.firma. Ambas son piezas delicadas, de bajo valor diferencial y alto costo de mantenimiento cuando el SAT cambia algo.

## Decisión
- **T4:** el CSD se carga en el PAC y el PAC sella el CFDI. El sistema arma el comprobante y lo envía; no implementa cadena original ni firma.
- **T5:** la descarga masiva se consume por API de un proveedor en vez de implementar el SOAP con e.firma.

Ambas quedan **detrás de un adaptador** (`engines/fiscal/adapters/`), con la interfaz definida por el sistema, no por el proveedor.

## Alternativas consideradas
| Alternativa | Por qué no ahora |
|---|---|
| Sellado propio desde el día uno | Semanas de trabajo en criptografía y XSLT antes de poder emitir la primera factura, sin valor visible para el cliente |
| Descarga masiva propia con e.firma | Exige custodiar la e.firma, que da acceso a mucho más que las facturas. Más riesgo por menos beneficio |

## Consecuencias
- Más fácil: emitir la primera factura real en semanas en vez de meses.
- Más difícil: dependencia de un proveedor, y un costo por timbre.
- El CSD queda en poder del PAC: la elección de PAC se vuelve una decisión de confianza, no solo de precio.

## Cómo se revierte
Se implementa el adaptador alternativo y se cambia la configuración. El resto del sistema no se entera, porque nunca habló con el PAC directamente.
