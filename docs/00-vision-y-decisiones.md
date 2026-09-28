# 00 · Visión, decisiones y supuestos

## Visión
Sistema operativo de negocio: un **núcleo universal** (7 áreas, 402 funciones) más **satélites por industria**, basado en roles, que convierte la operación en inteligencia. Producto vendible por planes (Basic 118 · Pro 281 · Max 402).

El núcleo se termina primero. Ningún satélite se construye hasta entonces.

## Empresas involucradas
- **Orion** — servicios B2B de tecnología. **Empresa de prueba**: opera solo con el núcleo, sin necesitar ninguna función de industria.
- **FLEETER Soluciones Logísticas S.A. de C.V.** — autotransporte de carga, caja seca, clientes institucionales, CDMX / Estado de México / Puebla, 3 unidades arrendadas. Entra después como segunda empresa, **solo en su parte administrativa**: no puede facturar fletes sin el complemento Carta Porte, que pertenece al satélite de Transporte.

## Decisiones de producto
| # | Decisión |
|---|---|
| D1 | Núcleo universal + satélites de industria; primer satélite: Transporte |
| D2 | Todo propio incluida la contabilidad; externos esenciales: PAC, SAT, IMSS, bancos |
| D3 | 7 áreas × 3 niveles; Basic 118 · Pro 281 · Max 402 funciones (visión completa) |
| D5 | Acceso por roles: lo contratado ∩ lo que permite el rol; Administrador ≠ Dirección ≠ Propietario |
| D6 | Monolito modular, bus de eventos, 6 almacenes de datos |
| D8 | Unidades arrendadas = activo por derecho de uso + pasivo por arrendamiento (NIF D-5) |
| D14 | Giro de FLEETER: caja seca, clientes institucionales, sin perecederos |
| **D15** | **Alcance: el núcleo completo, sin satélites.** Los satélites de industria se replanifican cuando el núcleo esté terminado |
| **D16** | **Construcción por categoría y nivel:** fase 0 de fundación, después las 7 áreas en nivel Esencial (118), Profesional (163) y Avanzado (121) |

## Decisiones técnicas
| # | Decisión | Estado |
|---|---|---|
| T1 | Stack TypeScript + Next.js + Supabase + Vercel | **Confirmado** el 24/09/2026 — ver `ADR-0005` |
| T2 | Interfaz móvil como PWA (web instalable) | Confirmado |
| T3 | Construcción con Claude Code en VS Code, una tarea por sesión | Confirmado |
| T4 | Sellado de CFDI: el PAC sella (CSD cargado en el PAC); sellado propio en V2 | **Propuesta** — evita implementar cadena original, XSLT y criptografía |
| T5 | Descarga masiva SAT vía API de proveedor; implementación propia en V2 | **Propuesta** — evita el SOAP con e.firma |
| T6 | Validación en paralelo con el contador durante 2 cierres mensuales | Confirmado |

Ambos atajos viven detrás de un adaptador: cambiarlos en V2 no toca el resto del sistema.

## Pendientes antes de construir
- Elegir PAC (timbrado, cancelación, complemento de pagos y, de ser posible, descarga masiva; Carta Porte y nómina para después).
- Validación del contador: catálogo de cuentas y reglas contables (doc 07) y casos dorados (doc 12).
- Confirmar el stack (T1) y los atajos T4 y T5.
- RFC, e.firma y CSD de la empresa de prueba; cuenta bancaria empresarial.
- Nombre del producto (nombre de trabajo: OS).

Ya **no** es urgente elegir proveedor de GPS: la telemetría pertenece al satélite.
