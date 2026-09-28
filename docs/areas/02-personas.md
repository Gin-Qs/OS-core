# Personas — 63 funciones

Prefijo `PER` · claves `PER-001` a `PER-063` · esquema de base de datos `personas` · 6 departamentos

**Nivel:** `E` Esencial (plan Basic) · `P` Profesional (Pro) · `A` Avanzado (Max). Cada plan incluye los niveles anteriores.

## Cómo se edita este archivo

- Una fila es una función. **Las claves son estables**: se usan en los commits, en el plan de construcción y en las pruebas. No se renumeran ni se reutilizan.
- Para **agregar** una función: se toma el siguiente número libre del área (`PER-064`), aunque quede al final de la tabla del departamento que le toca.
- Para **quitar** una función: se marca `retirada` en Notas y se deja la fila. Borrarla libera una clave que ya vive en otros documentos.
- Para **mover** una función de nivel: se cambia la columna Nivel. Eso cambia en qué plan aparece, no su clave.
- La columna **Notas** está vacía a propósito: es para decisiones, dudas y recordatorios.

## Resumen por departamento

| Departamento | E | P | A | Total |
|---|---|---|---|---|
| Capital Humano | 18 | 6 | 0 | 24 |
| Seguridad y Salud en el Trabajo | 7 | 3 | 0 | 10 |
| Talento y Desarrollo | 0 | 8 | 2 | 10 |
| Compensaciones y Beneficios | 0 | 4 | 4 | 8 |
| Relaciones Laborales | 0 | 6 | 0 | 6 |
| Cultura y Experiencia del Empleado | 0 | 0 | 5 | 5 |
| **Total** | **25** | **27** | **11** | **63** |

---

## Capital Humano (24)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `PER-001` | Expediente digital | E | Datos, documentos y contratos de cada empleado | |
| `PER-002` | Puestos y organigrama | E | Estructura, jefes directos y descripción de puestos | |
| `PER-003` | Contratos laborales | E | Plantillas de contrato indeterminado, determinado y periodo de prueba | |
| `PER-004` | Movimientos IMSS | E | Altas, bajas y modificaciones de salario ante el IMSS | |
| `PER-005` | Nómina | E | Periodos semanal, quincenal o mensual con percepciones y deducciones | |
| `PER-006` | Cálculo de ISR, subsidio e IMSS | E | Impuestos y cuotas obrero-patronales calculados automáticamente | |
| `PER-007` | Timbrado de nómina | E | CFDI de nómina y recibo digital al colaborador | |
| `PER-008` | Dispersión | E | Pago de nómina mediante archivo bancario | |
| `PER-009` | Incidencias | E | Faltas, incapacidades, horas extra y primas dominicales | |
| `PER-010` | Control de asistencia | E | App con registro de entrada y salida y geolocalización | |
| `PER-011` | Vacaciones y permisos | E | Saldos por antigüedad y solicitudes con aprobación | |
| `PER-012` | Aguinaldo y prima vacacional | E | Cálculo y pago automático de prestaciones de ley | |
| `PER-013` | Finiquitos y liquidaciones | E | Cálculo, recibo y baja en IMSS en un solo flujo | |
| `PER-014` | Reparto de PTU | E | Distribución individual de utilidades con la base de Fiscal | |
| `PER-015` | SUA, INFONAVIT y FONACOT | E | Pagos bimestrales y descuentos de créditos | |
| `PER-016` | Impuesto sobre nómina | E | Cálculo del impuesto estatal por sucursal | |
| `PER-017` | Constancias anuales | E | Constancias de sueldos y retenciones | |
| `PER-018` | Capacitación obligatoria (DC-3) | E | Registro de cursos y constancias ante la STPS | |
| `PER-026` | Préstamos y descuentos | P | Préstamos a empleados con descuento vía nómina | |
| `PER-027` | Multiempresa | P | Varios registros patronales y razones sociales | |
| `PER-028` | Asimilados a salarios | P | Esquema de pago distinto a la nómina ordinaria | |
| `PER-029` | Costo de nómina | P | Costo total por centro de costo conectado a contabilidad | |
| `PER-030` | Plantilla autorizada | P | Puestos presupuestados contra ocupados | |
| `PER-031` | Rotación y ausentismo | P | Indicadores por área, jefe y periodo | |

## Seguridad y Salud en el Trabajo (10)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `PER-019` | NOM-035 | E | Cuestionarios, política y resultados de riesgo psicosocial | |
| `PER-020` | Buzón de quejas | E | Canal confidencial exigido por la NOM-035 | |
| `PER-021` | Comisión de Seguridad e Higiene | E | Integrantes, recorridos y actas | |
| `PER-022` | Accidentes y riesgos de trabajo | E | Registro, investigación y formatos del IMSS | |
| `PER-023` | Equipo de protección personal | E | Entrega y reposición por empleado | |
| `PER-024` | Protección civil | E | Brigadas, simulacros y programa interno | |
| `PER-025` | Prima de riesgo de trabajo | E | Cálculo y declaración anual ante el IMSS | |
| `PER-032` | Exámenes médicos | P | Agenda de exámenes de ingreso y periódicos (datos restringidos) | |
| `PER-033` | Inspecciones de seguridad | P | Recorridos, hallazgos y acciones correctivas | |
| `PER-034` | Indicadores de accidentabilidad | P | Frecuencia y gravedad de accidentes por área | |

## Talento y Desarrollo (10)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `PER-035` | Requisiciones de personal | P | Solicitud de vacante con aprobación y presupuesto | |
| `PER-036` | Vacantes | P | Publicación de vacantes y portal de empleo propio | |
| `PER-037` | Seguimiento de candidatos | P | Pipeline de reclutamiento; el contratado se da de alta solo | |
| `PER-038` | Entrevistas y evaluaciones | P | Agenda, guías de entrevista y calificación | |
| `PER-039` | Onboarding | P | Checklist de ingreso: equipo, accesos, documentos y cursos | |
| `PER-040` | Capacitación | P | Cursos internos, rutas de aprendizaje y seguimiento | |
| `PER-041` | Evaluación de desempeño | P | Objetivos y evaluaciones 90°, 180° o 360° | |
| `PER-042` | Offboarding | P | Checklist de salida, revocación de accesos y entrevista de salida | |
| `PER-053` | Carrera y sucesión | A | Planes de carrera y reemplazos para puestos clave | |
| `PER-054` | Mapa de talento | A | Matriz de desempeño contra potencial (9-box) | |

## Compensaciones y Beneficios (8)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `PER-043` | Tabulador de sueldos | P | Rangos salariales por puesto y nivel | |
| `PER-044` | Bonos e incentivos | P | Comisiones conectadas a Ventas y bonos por metas | |
| `PER-045` | Prestaciones | P | Vales, fondo de ahorro, seguros y beneficios | |
| `PER-046` | Simulador de incrementos | P | Impacto de aumentos en costo total y presupuesto | |
| `PER-055` | Valuación de puestos | A | Peso relativo de cada puesto en la organización | |
| `PER-056` | Comparación con mercado | A | Sueldos contra referencias del mercado | |
| `PER-057` | Previsión social | A | Diseño de beneficios con eficiencia fiscal | |
| `PER-058` | Compensación variable | A | Pago variable ligado a la evaluación de desempeño | |

## Relaciones Laborales (6)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `PER-047` | Reglamento interior | P | Reglamento vigente y constancia de conocimiento | |
| `PER-048` | Actas administrativas | P | Faltas, sanciones y expediente disciplinario | |
| `PER-049` | Contrato colectivo | P | Sindicato y revisiones salariales y contractuales | |
| `PER-050` | REPSE | P | Registro propio y validación de proveedores de servicios especializados | |
| `PER-051` | Conflictos laborales | P | Citatorios de conciliación y demandas, conectado a Legal | |
| `PER-052` | Comisiones mixtas | P | Comisiones de capacitación, PTU y reglamento | |

## Cultura y Experiencia del Empleado (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `PER-059` | Clima laboral | A | Encuestas de clima y eNPS por área | |
| `PER-060` | Reconocimientos | A | Reconocimientos entre compañeros y por logros | |
| `PER-061` | Comunicación interna | A | Campañas y avisos segmentados a empleados | |
| `PER-062` | Bienestar | A | Programas de bienestar y participación | |
| `PER-063` | Diversidad e inclusión | A | Indicadores y seguimiento de iniciativas | |

---

## Micro apps del área

- **E:** Nómina neta/bruta · Costo real del empleado · Finiquito y liquidación · Aguinaldo y prima vacacional · Vacaciones por antigüedad · PTU individual · Horas extra · Cuotas IMSS
- **P:** Simulador de incremento salarial · Costo de rotación

Las micro apps son calculadoras independientes: no escriben en la base de datos de negocio, solo leen parámetros vigentes. No llevan clave porque no son funciones del catálogo.

## Agentes de IA del área

- **E:** Pre-nómina (revisa incidencias y anomalías) · Asistente del colaborador
- **P:** Reclutamiento (filtra; la decisión es humana)
- **A:** Clima laboral

Todo agente hereda los permisos del usuario que lo invoca. Un agente nunca ve lo que su usuario no puede ver.

## Reglas del área

- Salarios, incapacidades y exámenes médicos son campos sensibles: tabla con RLS restringida al rol Personas.
- El motor de cálculo comparte con Finanzas las tablas de ISR, subsidio, UMA, salario mínimo y cuotas IMSS.
- El Espacio del Colaborador consume estas funciones: recibos, vacaciones, permisos, gastos y capacitación.
