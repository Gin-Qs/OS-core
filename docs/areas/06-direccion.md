# Dirección — 39 funciones

Prefijo `DIR` · claves `DIR-001` a `DIR-039` · esquema de base de datos `direccion` + `analitica` · 7 departamentos

**Nivel:** `E` Esencial (plan Basic) · `P` Profesional (Pro) · `A` Avanzado (Max). Cada plan incluye los niveles anteriores.

## Cómo se edita este archivo

- Una fila es una función. **Las claves son estables**: se usan en los commits, en el plan de construcción y en las pruebas. No se renumeran ni se reutilizan.
- Para **agregar** una función: se toma el siguiente número libre del área (`DIR-040`), aunque quede al final de la tabla del departamento que le toca.
- Para **quitar** una función: se marca `retirada` en Notas y se deja la fila. Borrarla libera una clave que ya vive en otros documentos.
- Para **mover** una función de nivel: se cambia la columna Nivel. Eso cambia en qué plan aparece, no su clave.
- La columna **Notas** está vacía a propósito: es para decisiones, dudas y recordatorios.

## Resumen por departamento

| Departamento | E | P | A | Total |
|---|---|---|---|---|
| Dirección General | 7 | 0 | 0 | 7 |
| Planeación Estratégica | 0 | 5 | 0 | 5 |
| PMO y Transformación | 0 | 4 | 2 | 6 |
| Secretaría Corporativa | 0 | 4 | 1 | 5 |
| Estrategia Corporativa | 0 | 0 | 5 | 5 |
| Desarrollo Corporativo y M&A | 0 | 0 | 5 | 5 |
| Auditoría Interna | 0 | 0 | 6 | 6 |
| **Total** | **7** | **13** | **19** | **39** |

---

## Dirección General (7)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `DIR-001` | Tablero ejecutivo | E | Todas las áreas del negocio en una sola vista | |
| `DIR-002` | Alertas críticas | E | Flujo bajo, cobranza vencida e incumplimientos | |
| `DIR-003` | Aprobaciones centralizadas | E | Todo lo que espera la firma del director | |
| `DIR-004` | Objetivos del negocio | E | Metas anuales y avance | |
| `DIR-005` | Juntas y acuerdos | E | Agenda, minuta y acuerdos con responsable | |
| `DIR-006` | Reporte automático | E | Resumen semanal y mensual del negocio | |
| `DIR-007` | Consulta en lenguaje natural | E | Preguntas sobre el negocio respondidas con datos | |

## Planeación Estratégica (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `DIR-008` | Plan estratégico | P | Misión, visión y análisis FODA | |
| `DIR-009` | OKRs en cascada | P | Objetivos de empresa que bajan a áreas y personas | |
| `DIR-010` | Iniciativas estratégicas | P | Proyectos que ejecutan el plan | |
| `DIR-011` | Revisión trimestral | P | Avance del plan y ajustes | |
| `DIR-012` | Balanced scorecard | P | Indicadores en cuatro perspectivas | |

## PMO y Transformación (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `DIR-013` | Portafolio de proyectos | P | Todos los proyectos de la empresa en una vista | |
| `DIR-014` | Priorización | P | Qué proyecto va primero y por qué | |
| `DIR-015` | Semáforos de avance | P | Estatus, riesgos y retrasos | |
| `DIR-016` | Recursos compartidos | P | Personas repartidas entre proyectos | |
| `DIR-021` | Beneficios logrados | A | Lo prometido por cada proyecto contra lo obtenido | |
| `DIR-022` | Gestión del cambio | A | Adopción de nuevas formas de trabajo | |

## Secretaría Corporativa (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `DIR-017` | Consejo y comités | P | Sesiones, calendario y miembros | |
| `DIR-018` | Asambleas | P | Convocatorias y actas de asamblea | |
| `DIR-019` | Seguimiento de acuerdos | P | Cumplimiento de resoluciones | |
| `DIR-020` | Estructura accionaria | P | Accionistas y movimientos de acciones | |
| `DIR-023` | Portal del consejero | A | Materiales y votaciones del consejo | |

## Estrategia Corporativa (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `DIR-024` | Portafolio de negocios | A | Unidades de negocio del grupo y su desempeño | |
| `DIR-025` | Asignación de capital | A | Dónde invertir los recursos del grupo | |
| `DIR-026` | Valuación de unidades | A | Valor de cada unidad de negocio | |
| `DIR-027` | Tablero consolidado de grupo | A | Indicadores de todas las empresas en una vista | |
| `DIR-028` | Escenarios estratégicos | A | Simulación de decisiones de largo plazo | |

## Desarrollo Corporativo y M&A (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `DIR-029` | Pipeline de oportunidades | A | Empresas y alianzas en evaluación | |
| `DIR-030` | Due diligence y data room | A | Revisión y documentación de adquisiciones | |
| `DIR-031` | Valuación | A | Modelos de valuación de oportunidades | |
| `DIR-032` | Integración post-adquisición | A | Plan para incorporar la empresa adquirida | |
| `DIR-033` | Alianzas y joint ventures | A | Acuerdos con socios estratégicos | |

## Auditoría Interna (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `DIR-034` | Plan basado en riesgos | A | Programa anual de auditorías según riesgo | |
| `DIR-035` | Papeles de trabajo | A | Programas y evidencia de cada auditoría | |
| `DIR-036` | Hallazgos | A | Observaciones y recomendaciones | |
| `DIR-037` | Seguimiento de acciones | A | Cumplimiento de las acciones acordadas | |
| `DIR-038` | Reporte al comité | A | Informe al comité de auditoría | |
| `DIR-039` | Auditoría continua con IA | A | Revisión automática de transacciones | |

---

## Micro apps del área

- **E:** Salud del negocio (semáforo de indicadores)
- **P:** WACC · Valuación rápida por múltiplos
- **A:** Dilución accionaria

Las micro apps son calculadoras independientes: no escriben en la base de datos de negocio, solo leen parámetros vigentes. No llevan clave porque no son funciones del catálogo.

## Agentes de IA del área

- **E:** Resumen ejecutivo diario
- **P:** Seguimiento de OKRs y acuerdos
- **A:** Analista de escenarios

Todo agente hereda los permisos del usuario que lo invoca. Un agente nunca ve lo que su usuario no puede ver.

## Reglas del área

- Dirección no captura datos propios: lee de todas las áreas a través de vistas analíticas. Si un número no existe en otra área, no existe aquí.
- Dirección ≠ Administrador: Dirección es un rol de negocio; Administrador es un rol de sistema.
