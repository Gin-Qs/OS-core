# Comercial — 70 funciones

Prefijo `COM` · claves `COM-001` a `COM-070` · esquema de base de datos `comercial` · 8 departamentos

**Nivel:** `E` Esencial (plan Basic) · `P` Profesional (Pro) · `A` Avanzado (Max). Cada plan incluye los niveles anteriores.

## Cómo se edita este archivo

- Una fila es una función. **Las claves son estables**: se usan en los commits, en el plan de construcción y en las pruebas. No se renumeran ni se reutilizan.
- Para **agregar** una función: se toma el siguiente número libre del área (`COM-071`), aunque quede al final de la tabla del departamento que le toca.
- Para **quitar** una función: se marca `retirada` en Notas y se deja la fila. Borrarla libera una clave que ya vive en otros documentos.
- Para **mover** una función de nivel: se cambia la columna Nivel. Eso cambia en qué plan aparece, no su clave.
- La columna **Notas** está vacía a propósito: es para decisiones, dudas y recordatorios.

## Resumen por departamento

| Departamento | E | P | A | Total |
|---|---|---|---|---|
| Ventas | 10 | 7 | 2 | 19 |
| Marketing | 6 | 4 | 1 | 11 |
| Servicio al Cliente | 5 | 4 | 1 | 10 |
| Pricing y Revenue Management | 0 | 4 | 3 | 7 |
| Experiencia del Cliente | 0 | 4 | 2 | 6 |
| Producto e Innovación | 0 | 4 | 2 | 6 |
| Inteligencia de Mercado | 0 | 3 | 2 | 5 |
| Comunicación Corporativa | 0 | 0 | 6 | 6 |
| **Total** | **21** | **30** | **19** | **70** |

---

## Ventas (19)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `COM-001` | Prospectos | E | Captura de prospectos desde web, WhatsApp y formularios | |
| `COM-002` | Clientes y contactos | E | Ficha del cliente con historial completo de interacciones | |
| `COM-003` | Embudo de oportunidades | E | Etapas de venta con valor y probabilidad de cierre | |
| `COM-004` | Actividades y seguimiento | E | Llamadas, visitas, reuniones y recordatorios | |
| `COM-005` | Cotizaciones | E | Plantillas, envío y aceptación en línea | |
| `COM-006` | Pedidos | E | La cotización aceptada se vuelve pedido y avisa a Operaciones | |
| `COM-007` | Facturación desde pedido | E | El pedido genera el CFDI sin volver a capturar | |
| `COM-008` | Historial de correo y WhatsApp | E | Conversaciones ligadas a cada cliente | |
| `COM-009` | Metas por vendedor | E | Objetivos mensuales y avance | |
| `COM-010` | Tablero de ventas | E | Ventas, embudo y conversión en tiempo real | |
| `COM-022` | Asignación y territorios | P | Reparto automático de prospectos por zona o carga de trabajo | |
| `COM-023` | Secuencias de seguimiento | P | Recordatorios y mensajes automáticos por etapa | |
| `COM-024` | Contratos y renovaciones | P | Vencimientos y alertas de renovación | |
| `COM-025` | Pronóstico de ventas | P | Proyección de cierres por periodo | |
| `COM-026` | App de ventas en campo | P | Visitas con geolocalización y pedidos desde el celular | |
| `COM-027` | Análisis ganadas/perdidas | P | Motivos de pérdida y patrones de éxito | |
| `COM-028` | Portal de cliente | P | El cliente consulta pedidos, facturas y estado de cuenta | |
| `COM-052` | Planes de cuenta | A | Estrategia por cliente estratégico | |
| `COM-053` | Pronóstico predictivo | A | Probabilidad de cierre calculada con IA | |

## Marketing (11)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `COM-011` | Segmentación de contactos | E | Listas por industria, zona o comportamiento | |
| `COM-012` | Formularios y landing pages | E | Captura de prospectos directa al CRM | |
| `COM-013` | Campañas de correo | E | Envíos masivos con métricas de apertura y clics | |
| `COM-014` | Calendario de contenido | E | Planeación de publicaciones y redes sociales | |
| `COM-015` | Origen de prospectos | E | De qué canal llega cada cliente | |
| `COM-016` | Biblioteca de marca | E | Logos, plantillas y lineamientos de marca | |
| `COM-029` | Automatización de nutrición | P | Flujos de mensajes según el interés del prospecto | |
| `COM-030` | Calificación de prospectos | P | Puntaje de qué tan listo está un prospecto para comprar | |
| `COM-031` | Presupuesto y ROI | P | Gasto por campaña contra ventas generadas | |
| `COM-032` | Eventos | P | Ferias, registros y seguimiento de asistentes | |
| `COM-054` | Atribución multicanal | A | Qué combinación de canales genera las ventas | |

## Servicio al Cliente (10)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `COM-017` | Tickets multicanal | E | Correo, WhatsApp, teléfono y web en una sola bandeja | |
| `COM-018` | SLA | E | Tiempos de respuesta comprometidos y alertas de vencimiento | |
| `COM-019` | Base de conocimiento | E | Respuestas frecuentes internas y públicas | |
| `COM-020` | Quejas, devoluciones y garantías | E | Registro, seguimiento y resolución | |
| `COM-021` | Satisfacción (CSAT) | E | Encuesta al cerrar cada caso | |
| `COM-033` | Portal de autoservicio | P | El cliente abre y consulta sus casos | |
| `COM-034` | Enrutamiento y escalamiento | P | Asignación automática por tipo y prioridad | |
| `COM-035` | Servicio en campo | P | Visitas técnicas con agenda y evidencias | |
| `COM-036` | Pólizas de servicio | P | Contratos de soporte y mantenimiento a clientes | |
| `COM-055` | Análisis de causa raíz | A | Problemas recurrentes y su origen | |

## Pricing y Revenue Management (7)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `COM-037` | Listas de precios | P | Precios por cliente, canal, región o volumen | |
| `COM-038` | Descuentos con autorización | P | Límites por rol; lo que excede requiere aprobación | |
| `COM-039` | Promociones | P | Vigencias, condiciones y resultados | |
| `COM-040` | Margen por precio | P | Rentabilidad real de cada precio vendido | |
| `COM-056` | Simulador de elasticidad | A | Cómo cambia la demanda al mover el precio | |
| `COM-057` | Precios dinámicos | A | Ajuste de precios por demanda, temporada o capacidad | |
| `COM-058` | Precios de competencia | A | Monitoreo y comparación de precios | |

## Experiencia del Cliente (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `COM-041` | Recorrido del cliente | P | Mapa de puntos de contacto y fricciones | |
| `COM-042` | NPS | P | Encuestas de lealtad en momentos clave | |
| `COM-043` | Salud del cliente | P | Puntaje de riesgo de cancelación | |
| `COM-044` | Lealtad y referidos | P | Programas de puntos y recomendación | |
| `COM-059` | Voz del cliente | A | Análisis con IA de comentarios y quejas | |
| `COM-060` | Valor de vida (CLV) | A | Cuánto vale cada cliente en el tiempo | |

## Producto e Innovación (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `COM-045` | Roadmap | P | Plan de mejoras y lanzamientos | |
| `COM-046` | Banco de ideas | P | Propuestas de clientes y empleados con votación | |
| `COM-047` | Ciclo de vida | P | Lanzamiento, madurez y retiro de productos | |
| `COM-048` | Fichas técnicas | P | Especificaciones y documentación de productos | |
| `COM-061` | Desarrollo por etapas | A | Proyectos con fases y aprobación entre cada una | |
| `COM-062` | Pilotos y retroalimentación | A | Pruebas con clientes y resultados | |

## Inteligencia de Mercado (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `COM-049` | Competidores | P | Fichas, precios y comparativos de la competencia | |
| `COM-050` | Mercado y segmentos | P | Tamaño y características de cada segmento | |
| `COM-051` | Encuestas y estudios | P | Diseño, aplicación y resultados | |
| `COM-063` | Monitoreo de tendencias | A | Noticias y cambios del sector resumidos con IA | |
| `COM-064` | Participación de mercado | A | Posición frente a la competencia | |

## Comunicación Corporativa (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `COM-065` | Sala de prensa | A | Comunicados y material para medios | |
| `COM-066` | Relación con medios | A | Contactos, entrevistas y publicaciones | |
| `COM-067` | Monitoreo de reputación | A | Menciones en medios y redes sociales | |
| `COM-068` | Protocolo de crisis | A | Plan, responsables y mensajes preaprobados | |
| `COM-069` | Mensajes clave y voceros | A | Quién habla por la empresa y qué dice | |
| `COM-070` | Informe anual | A | Reporte institucional anual | |

---

## Micro apps del área

- **E:** Margen vs markup · Cotizador rápido · Comisiones · ROI de campaña · NPS · Conversión de embudo
- **P:** CAC y LTV · Rentabilidad de promoción · TAM/SAM/SOM

Las micro apps son calculadoras independientes: no escriben en la base de datos de negocio, solo leen parámetros vigentes. No llevan clave porque no son funciones del catálogo.

## Agentes de IA del área

- **E:** Asistente de ventas · Agente de atención (escala a humano)
- **P:** Contenido de marketing · Riesgo de cancelación
- **A:** Inteligencia competitiva

Todo agente hereda los permisos del usuario que lo invoca. Un agente nunca ve lo que su usuario no puede ver.

## Reglas del área

- El catálogo de productos y servicios y el maestro de clientes viven en la plataforma (compartidos con Finanzas y Operaciones).
- Cadena completa: Cotización → Pedido → Operaciones → Factura (motor fiscal) → Cobranza (tesorería).
- Las comisiones se calculan aquí pero se pagan en Compensaciones (Personas).
- Comercio electrónico, canales y cuentas clave no están aquí: son el paquete de modelo "Canales de Venta".
