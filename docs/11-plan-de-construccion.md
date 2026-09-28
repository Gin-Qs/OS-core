# 11 · Plan de construcción

Una tarea = una sesión de Claude Code (`/siguiente-tarea`). Estado: `pendiente` · `en curso` · `hecha` · `bloqueada`.

El plan está dividido **por categoría**, igual que el catálogo de `docs/areas/`. Las claves de tarea llevan el prefijo de su área (`T-FIN-01`), así que una tarea siempre dice a qué archivo de catálogo pertenece.

## Orden general

| Fase | Qué se construye | Funciones |
|---|---|---|
| **0 · Fundación** | Plataforma, bus de eventos, libro contable, motores. No pertenece a ningún área: todas dependen de ella | — |
| **1 · Nivel Esencial** | Las 118 funciones `E` de las 7 áreas | 118 |
| **2 · Nivel Profesional** | Las 163 funciones `P` | 163 |
| **3 · Nivel Avanzado** | Las 121 funciones `A` | 121 |

Dentro de la fase 1, el orden entre áreas lo manda la dependencia de datos, no la preferencia:

```
Tecnología (plataforma) → Comercial → Finanzas → Operaciones → Personas → Legal → Dirección
     identidad y roles     quién       el dinero    el trabajo    la gente   el riesgo  la lectura
```

Dirección va al final siempre, en las tres fases: no captura datos propios, lee de las demás. Un tablero construido antes que sus fuentes muestra ceros.

## Antes de construir (checklist)
- [x] ~~Validar el stack~~ **Confirmado** el 24/09/2026: Next.js + TypeScript estricto + PostgreSQL sobre Supabase + Vercel + PWA. Ver `ADR-0005`
- [ ] Crear proyectos: repositorio Git, Supabase (dev y prod), Vercel, Resend
- [ ] Elegir PAC y obtener credenciales de sandbox (atajo T4: el PAC sella, el CSD vive en el PAC)
- [ ] Elegir proveedor de descarga masiva SAT (atajo T5) o asumir la implementación propia con e.firma
- [ ] El contador valida `docs/07-reglas-contables.md` y firma los casos dorados del doc 12
- [ ] Cargar catálogos SAT vigentes y parámetros fiscales del año (UMA, salario mínimo, tablas ISR, subsidio, cuotas IMSS, ISN por estado)
- [ ] (Para producción) RFC, e.firma y CSD de la empresa; cuenta bancaria empresarial

---

# Fase 0 · Fundación

Nada de esto es opcional y nada se puede reordenar: las siete áreas se apoyan aquí.

| ID | Tarea | Dep. | Docs | Criterio de aceptación | Estado |
|---|---|---|---|---|---|
| T-PLT-01 | Inicializar proyecto: Next.js, TS estricto, Tailwind, shadcn/ui, ESLint boundaries, Vitest, Playwright, pnpm, estructura de carpetas | — | 03, CLAUDE | `pnpm lint typecheck test` en verde; estructura igual a CLAUDE.md | pendiente |
| T-PLT-02 | Migración base: esquemas, empresas, sucursales, usuarios, roles, permisos, terceros, productos y servicios, folios, configuración, con RLS | T-PLT-01 | 04 | `supabase db reset` limpio; pruebas de aislamiento por empresa | pendiente |
| T-PLT-03 | Auth: login, 2FA TOTP, selección de empresa, sesión con empresa activa | T-PLT-02 | 06 | Login con 2FA; usuario sin empresa no entra | pendiente |
| T-PLT-04 | Permisos: `requirePermiso`, semilla de la matriz de roles, **varios roles por usuario con resolución por unión**, menú según permisos efectivos | T-PLT-03 | 06 | Pruebas por rol y por combinación de roles; acciones ocultas y bloqueadas; unión determinista verificada | pendiente |
| T-PLT-05 | Bus de eventos: outbox, despachador (pg_cron + Edge Function), suscriptores, idempotencia, reintentos, bandeja de errores | T-PLT-02 | 02, 05 | Evento procesado una sola vez; fallo → reintento → error → alerta | pendiente |
| T-PLT-06 | Bitácora automática y visor de historial por registro | T-PLT-02 | 02 | Toda escritura de prueba deja rastro | pendiente |
| T-PLT-07 | Archivos: Storage, hash, versiones, URLs firmadas, componente de carga | T-PLT-02 | 04 | Subir y descargar con permisos; hash guardado | pendiente |
| T-PLT-08 | Vault y `secretos_ref`; pantalla de integraciones | T-PLT-02 | 09 | Un secreto nunca vuelve a ser visible tras guardarlo | pendiente |
| T-PLT-09 | Motor de flujos: aprobaciones por monto y rol; bandeja "Mis pendientes" | T-PLT-04 | 02 | Aprobación de prueba con umbral | pendiente |
| T-PLT-10 | Motor de alertas: reglas, tarea diaria de vencimientos, notificación en app y correo | T-PLT-05 | 05 | Vencimiento simulado genera alerta | pendiente |
| T-PLT-11 | Motor de documentos: plantillas y generación de PDF | T-PLT-07 | 10 | PDF generado con datos de prueba | pendiente |
| T-PLT-12 | Catálogos SAT y parámetros fiscales con vigencia; selector reutilizable | T-PLT-02 | 08 | Consulta por fecha devuelve el valor vigente | pendiente |
| T-PLT-23 | Catálogo de regímenes fiscales con base de acumulación; motor intérprete de definiciones de cálculo (lenguaje restringido, decimal exacto, papel de trabajo, versión y vigencia) | T-PLT-12 | 08, `ADR-0006` | Una definición se carga y se ejecuta sin desplegar código; recalcular un periodo anterior reproduce su resultado; una definición que falla un caso dorado no se activa | pendiente |
| T-PLT-24 | Base de acumulación en las reglas contables: la misma venta genera póliza distinta en devengado y en flujo | T-PLT-14, T-PLT-23 | 07, 08 | Casos dorados `CD-11` y `CD-12` en verde, sin condicional por régimen en el código | pendiente |
| T-PLT-13 | Libro contable: cuentas, periodos, pólizas inmutables con hash encadenado, partidas, saldos, **y zona de preparación (pólizas en borrador)** | T-PLT-05 | 04, 07 | UPDATE/DELETE fallan en el libro y funcionan en el borrador; póliza descuadrada se rechaza al aprobar; un borrador no aparece en balanza | pendiente |
| T-PLT-14 | Motor contable: reglas como datos, suscriptor genérico evento→póliza, reversas, **operación corregir (reversa + sustituta en una transacción), reclasificación con póliza de ajuste y consulta de la cadena de correcciones** | T-PLT-13 | 07 | Casos dorados contables en verde; corregir deja el saldo como si el error no hubiera ocurrido; la cadena es visible desde la balanza | pendiente |
| T-PLT-15 | Motor fiscal: modelo CFDI 4.0, validador, adaptador PAC, timbrado y cancelación, XML y PDF a Storage | T-PLT-12, T-PLT-08 | 08, 09 | CD-01 y CD-03 timbrados en sandbox | pendiente |
| T-PLT-16 | PWA: instalación, cámara, geolocalización, cola sin conexión | T-PLT-01 | 10 | Evidencia capturada sin red se sincroniza al volver | pendiente |

---

# Fase 1 · Nivel Esencial (118 funciones)

## Tecnología y Datos — 7 funciones `E`
Archivo: `docs/areas/07-tecnologia-datos.md`

| ID | Tarea | Funciones | Dep. | Estado |
|---|---|---|---|---|
| T-TEC-01 | Consola de usuarios y roles: asignar varios roles, pantalla de **permisos efectivos**, matriz de incompatibilidades, autorización de excepciones por el Propietario, accesos ligados a altas y bajas | `TEC-001`, `TEC-004` | T-PLT-04 | pendiente |
| T-TEC-02 | Configuración del sistema: campos, flujos, catálogos | `TEC-005` | T-PLT-04 | pendiente |
| T-TEC-03 | Integraciones y llaves de API; respaldos y restauración | `TEC-006`, `TEC-007` | T-PLT-08 | pendiente |
| T-TEC-04 | Inventario de equipos y licencias; mesa de ayuda de TI | `TEC-002`, `TEC-003` | T-PLT-04 | pendiente |

## Comercial — 21 funciones `E`
Archivo: `docs/areas/03-comercial.md`

| ID | Tarea | Funciones | Dep. | Estado |
|---|---|---|---|---|
| T-COM-01 | Maestro de clientes y contactos; ficha 360 | `COM-002` | T-PLT-02 | pendiente |
| T-COM-02 | Prospectos, embudo de oportunidades, actividades y seguimiento | `COM-001`, `COM-003`, `COM-004` | T-COM-01 | pendiente |
| T-COM-03 | Cotizaciones y pedidos | `COM-005`, `COM-006` | T-COM-01 | pendiente |
| T-COM-04 | Facturación desde pedido (CFDI 4.0) | `COM-007` | T-COM-03, T-PLT-15 | pendiente |
| T-COM-05 | Historial de correo y WhatsApp; metas por vendedor; tablero de ventas | `COM-008`, `COM-009`, `COM-010` | T-COM-02 | pendiente |
| T-COM-06 | Marketing esencial: segmentación, formularios y landing, campañas de correo, calendario de contenido, origen de prospectos, biblioteca de marca | `COM-011` a `COM-016` | T-COM-02 | pendiente |
| T-COM-07 | Servicio al cliente: tickets multicanal, SLA, base de conocimiento, quejas y devoluciones, CSAT | `COM-017` a `COM-021` | T-COM-01 | pendiente |

## Finanzas — 27 funciones `E`
Archivo: `docs/areas/01-finanzas.md`

| ID | Tarea | Funciones | Dep. | Estado |
|---|---|---|---|---|
| T-FIN-01 | Catálogo de cuentas con código agrupador SAT; pólizas automáticas y manuales | `FIN-001` a `FIN-003` | T-PLT-14 | pendiente |
| T-FIN-02 | Libros, balanza y estados financieros básicos | `FIN-004`, `FIN-005` | T-FIN-01 | pendiente |
| T-FIN-03 | Bancos y cajas; importación de estados de cuenta y conciliación | `FIN-018`, `FIN-019` | T-FIN-01 | pendiente |
| T-FIN-04 | Complemento de pagos 2.0; cuentas por cobrar y antigüedad | `FIN-020` | T-COM-04, T-FIN-03 | pendiente |
| T-FIN-05 | Cobranza automatizada y crédito a clientes | `FIN-021`, `FIN-022` | T-FIN-04, T-PLT-10 | pendiente |
| T-FIN-06 | Buzón CFDI: descarga masiva, lectura de XML, estado SAT | `FIN-009` | T-PLT-15 | pendiente |
| T-FIN-07 | Clasificación de gastos, cuentas por pagar, conciliación CFDI vs contabilidad | `FIN-010`, `FIN-023` | T-FIN-06 | pendiente |
| T-FIN-08 | Autorización y programación de pagos; caja chica y gastos de empleados | `FIN-024`, `FIN-025` | T-FIN-07, T-PLT-09 | pendiente |
| T-FIN-09 | Cierre de periodo con bloqueo; depreciación contable y fiscal | `FIN-007`, `FIN-008` | T-FIN-02 | pendiente |
| T-FIN-11 | Definiciones de cálculo por régimen: ISR provisional y anual del general, RESICO PM, coordinados, PF actividad empresarial y RESICO PF, cada una con sus casos dorados firmados por el contador | `FIN-011` | T-PLT-23, T-FIN-09 | pendiente |
| T-FIN-12 | Calendario de obligaciones derivado del régimen; cambio de régimen con fecha de efecto | `FIN-012` | T-FIN-11 | pendiente |
| T-FIN-10 | Contabilidad electrónica XML: catálogo, balanza y pólizas | `FIN-006` | T-FIN-09 | pendiente |
| T-FIN-11 | Impuestos: ISR provisional, IVA en flujo, retenciones, DIOT | `FIN-011` a `FIN-014` | T-FIN-09, T-FIN-07 | pendiente |
| T-FIN-12 | Declaración anual y base PTU; calendario fiscal; validación 69-B | `FIN-015`, `FIN-016`, `FIN-017` | T-FIN-11 | pendiente |
| T-FIN-13 | Flujo de efectivo real y proyectado a 13 semanas; presupuesto simple | `FIN-026`, `FIN-027` | T-FIN-04, T-FIN-08 | pendiente |

## Operaciones y Abastecimiento — 23 funciones `E`
Archivo: `docs/areas/04-operaciones.md`

| ID | Tarea | Funciones | Dep. | Estado |
|---|---|---|---|---|
| T-OPE-01 | Órdenes de trabajo, plantillas, planeación y agenda, asignación de recursos | `OPE-001` a `OPE-004` | T-PLT-04 | pendiente |
| T-OPE-02 | Seguimiento en tiempo real, checklists, evidencias móviles | `OPE-005` a `OPE-007` | T-OPE-01, T-PLT-16 | pendiente |
| T-OPE-03 | Consumos por orden, incidencias, cierre de orden y facturación, tablero operativo | `OPE-008` a `OPE-011` | T-OPE-02, T-COM-04 | pendiente |
| T-OPE-04 | Proveedores con documentos y opinión de cumplimiento | `OPE-012` | T-FIN-07 | pendiente |
| T-OPE-05 | Compras: requisiciones con aprobación, cotizaciones y comparativo, órdenes de compra | `OPE-013` a `OPE-015` | T-OPE-04, T-PLT-09 | pendiente |
| T-OPE-06 | Recepción, conciliación OC-recepción-factura, precios por proveedor, devoluciones | `OPE-016` a `OPE-019` | T-OPE-05 | pendiente |
| T-OPE-07 | Inventario básico (condicional): existencias, entradas y salidas, costo promedio, punto de reorden | `OPE-020` a `OPE-023` | T-OPE-06 | pendiente |

## Personas — 25 funciones `E`
Archivo: `docs/areas/02-personas.md`

| ID | Tarea | Funciones | Dep. | Estado |
|---|---|---|---|---|
| T-PER-01 | Expediente digital, puestos y organigrama, contratos laborales, con RLS estricta en salarios | `PER-001` a `PER-003` | T-PLT-04 | pendiente |
| T-PER-02 | Incidencias, control de asistencia con geolocalización, vacaciones y permisos | `PER-009` a `PER-011` | T-PER-01, T-PLT-16 | pendiente |
| T-PER-03 | Motor de nómina: cálculo de ISR, subsidio, SDI, IMSS | `PER-005`, `PER-006` | T-PER-02, T-PLT-12 | pendiente |
| T-PER-04 | Timbrado de nómina 1.2 y dispersión | `PER-007`, `PER-008` | T-PER-03, T-PLT-15 | pendiente |
| T-PER-05 | Movimientos IMSS, SUA, INFONAVIT, FONACOT, ISN estatal | `PER-004`, `PER-015`, `PER-016` | T-PER-03 | pendiente |
| T-PER-06 | Aguinaldo y prima, finiquitos y liquidaciones, reparto de PTU, constancias anuales | `PER-012` a `PER-014`, `PER-017` | T-PER-03 | pendiente |
| T-PER-07 | Capacitación obligatoria y DC-3 | `PER-018` | T-PER-01 | pendiente |
| T-PER-08 | Seguridad y Salud: NOM-035, buzón de quejas, comisión mixta, accidentes, EPP, protección civil, prima de riesgo | `PER-019` a `PER-025` | T-PER-01 | pendiente |

## Legal y Riesgo — 8 funciones `E`
Archivo: `docs/areas/05-legal-riesgo.md`

| ID | Tarea | Funciones | Dep. | Estado |
|---|---|---|---|---|
| T-LEG-01 | Contratos: repositorio, plantillas, vencimientos; solicitudes desde otras áreas | `LEG-001`, `LEG-002` | T-PLT-07, T-PLT-10 | pendiente |
| T-LEG-02 | Firma electrónica con constancia NOM-151 | `LEG-003` | T-LEG-01 | pendiente |
| T-LEG-03 | Documentos corporativos, poderes y facultades, beneficiario controlador | `LEG-004` a `LEG-006` | T-PLT-07 | pendiente |
| T-LEG-04 | Marcas y propiedad intelectual; permisos y licencias con vigencias | `LEG-007`, `LEG-008` | T-PLT-10 | pendiente |

## Dirección — 7 funciones `E`
Archivo: `docs/areas/06-direccion.md`

| ID | Tarea | Funciones | Dep. | Estado |
|---|---|---|---|---|
| T-DIR-01 | Vistas analíticas base sobre todas las áreas | — | todas las anteriores | pendiente |
| T-DIR-02 | Tablero ejecutivo y alertas críticas | `DIR-001`, `DIR-002` | T-DIR-01 | pendiente |
| T-DIR-03 | Aprobaciones centralizadas; objetivos del negocio | `DIR-003`, `DIR-004` | T-PLT-09 | pendiente |
| T-DIR-04 | Juntas, minutas y acuerdos; reporte automático periódico | `DIR-005`, `DIR-006` | T-DIR-02 | pendiente |
| T-DIR-05 | Consulta del negocio en lenguaje natural | `DIR-007` | T-DIR-01 | pendiente |

## Multiempresa y distribución comercial

Estas tareas no pertenecen a un área: sostienen el modelo de venta a varias empresas. El diseño completo está en `docs/srs/20-multiempresa-y-distribucion.md` y en `docs/adr/0004-multiempresa-agrupada.md`.

| ID | Tarea | Cuándo se vuelve necesaria | Estado |
|---|---|---|---|
| T-PLT-17 | Suscripciones y módulos contratados, con verificación en el servidor | Antes del segundo cliente | pendiente |
| T-PLT-18 | Banderas de función por empresa, con pantalla de administración | Antes del segundo cliente | pendiente |
| T-PLT-19 | Exportación lógica diaria por empresa, incluidos sus archivos | Antes del primer cliente externo | pendiente |
| T-PLT-20 | Reimportación y reemplazo de los datos de una empresa, con bitácora | Antes del primer cliente externo | pendiente |
| T-PLT-21 | Métricas y límites de consumo por empresa | Con 5 a 10 clientes | pendiente |
| T-PLT-22 | Empresa demo con datos sintéticos que se reinicia sola | Cuando haya algo que vender | pendiente |

## Cierre de la fase 1
| ID | Tarea | Criterio | Estado |
|---|---|---|---|
| T-END-01 | E2E de los flujos del doc 12 | Playwright en verde | pendiente |
| T-END-02 | Seguridad: pruebas RLS completas, revisión de secretos y permisos | Sin hallazgos críticos | pendiente |
| T-END-03 | Carga inicial: catálogo contable, saldos iniciales, clientes, proveedores, empleados | Balanza inicial igual a la del contador | pendiente |
| T-END-04 | Producción: Supabase prod, Vercel, dominio, PAC productivo, respaldos | Primer CFDI real timbrado | pendiente |
| T-END-05 | Operación en paralelo durante 2 cierres mensuales | Diferencias resueltas; visto bueno del contador | pendiente |
| T-END-06 | Prueba de aislamiento entre empresas, obligatoria en cada integración | Un usuario de la empresa A no lee ni escribe nada de la empresa B, por ninguna vía | pendiente |

**Criterio para cerrar la fase 1:** una empresa real opera un mes calendario completo dentro del sistema —vende, factura, cobra, compra, paga, paga nómina, contabiliza, cierra y declara— sin una sola hoja de cálculo paralela, y las cifras coinciden con lo presentado ante el SAT.

---

# Fase 2 · Nivel Profesional (163 funciones)

Se abre cuando la fase 1 cumplió su criterio. El orden entre áreas es el mismo. Cada tarea se detalla al llegar; el alcance está en la columna `P` de cada archivo de `docs/areas/`.

| Área | Funciones `P` | Bloques de trabajo |
|---|---|---|
| Finanzas | 24 | Centros de costo y multimoneda · FP&A (presupuesto, costeo, rentabilidad, KPIs, proyecciones) · Contraloría · Tesorería avanzada (layouts, financiamiento, inversiones) · Papeles de trabajo y saldos a favor |
| Personas | 27 | Talento y desarrollo (ATS, onboarding, desempeño) · Compensaciones y beneficios · Relaciones laborales y REPSE · Préstamos y multiempresa patronal · Exámenes y accidentabilidad |
| Comercial | 30 | Ventas avanzadas (territorios, secuencias, pronóstico, portal de cliente) · Marketing (nutrición, calificación, ROI) · Servicio (autoservicio, enrutamiento, pólizas) · Pricing · Experiencia del cliente · Producto · Inteligencia de mercado |
| Operaciones | 32 | Proyectos y capacidad · Calidad (ISO 9001) · Activos y mantenimiento · Servicios generales · Compras avanzadas |
| Legal y Riesgo | 21 | Cumplimiento (obligaciones, antilavado, datos personales, denuncia) · Riesgos y seguros · Seguridad corporativa · Litigios y despachos |
| Dirección | 13 | Planeación estratégica y OKRs · PMO · Secretaría corporativa |
| Tecnología | 16 | Ciberseguridad · Datos e IA (reportes, tableros, BI, agentes personalizados) · Automatizaciones y control de cambios |

# Fase 3 · Nivel Avanzado (121 funciones)

| Área | Funciones `A` | Bloques de trabajo |
|---|---|---|
| Finanzas | 16 | Consolidación multiempresa · NIF/IFRS · Riesgos financieros · Factoraje y tesorería de grupo |
| Personas | 11 | Planes de carrera y 9-box · Valuación de puestos · Cultura y clima |
| Comercial | 19 | Planes de cuenta y pronóstico predictivo · Atribución multicanal · CLV · Comunicación corporativa |
| Operaciones | 21 | Programación optimizada con IA · Confiabilidad y predictivo · Compras estratégicas · Bienes raíces corporativos |
| Legal y Riesgo | 21 | Anticorrupción y monitoreo continuo · Continuidad del negocio · Asuntos públicos · ESG · Fundación |
| Dirección | 19 | Estrategia corporativa y asignación de capital · M&A · Auditoría interna |
| Tecnología | 14 | SSO, SIEM, pentesting · Modelos predictivos · Gobierno de datos · Arquitectura empresarial |

---

## Cómo se agrega una tarea

1. Se agrega o se ajusta la función en su archivo de `docs/areas/`.
2. Se agrega la tarea en la sección de su área, con el siguiente número libre del prefijo (`T-FIN-14`).
3. Se declaran sus dependencias y su criterio de aceptación **antes** de empezar a programar.
4. Si la tarea toca dinero, impuestos o nómina, su criterio de aceptación es un caso dorado del doc 12, no una descripción.
