# Legal y Riesgo — 50 funciones

Prefijo `LEG` · claves `LEG-001` a `LEG-050` · esquema de base de datos `legal` · 7 departamentos

**Nivel:** `E` Esencial (plan Basic) · `P` Profesional (Pro) · `A` Avanzado (Max). Cada plan incluye los niveles anteriores.

## Cómo se edita este archivo

- Una fila es una función. **Las claves son estables**: se usan en los commits, en el plan de construcción y en las pruebas. No se renumeran ni se reutilizan.
- Para **agregar** una función: se toma el siguiente número libre del área (`LEG-051`), aunque quede al final de la tabla del departamento que le toca.
- Para **quitar** una función: se marca `retirada` en Notas y se deja la fila. Borrarla libera una clave que ya vive en otros documentos.
- Para **mover** una función de nivel: se cambia la columna Nivel. Eso cambia en qué plan aparece, no su clave.
- La columna **Notas** está vacía a propósito: es para decisiones, dudas y recordatorios.

## Resumen por departamento

| Departamento | E | P | A | Total |
|---|---|---|---|---|
| Legal | 8 | 4 | 1 | 13 |
| Cumplimiento | 0 | 7 | 2 | 9 |
| Riesgos y Seguros | 0 | 5 | 2 | 7 |
| Seguridad Corporativa | 0 | 5 | 2 | 7 |
| Asuntos Públicos | 0 | 0 | 5 | 5 |
| Sostenibilidad / ESG | 0 | 0 | 5 | 5 |
| Fundación | 0 | 0 | 4 | 4 |
| **Total** | **8** | **21** | **21** | **50** |

---

## Legal (13)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `LEG-001` | Contratos | E | Repositorio, plantillas y alertas de vencimiento | |
| `LEG-002` | Solicitudes de contrato | E | Otras áreas piden un contrato y Legal lo atiende | |
| `LEG-003` | Firma electrónica | E | Firma de documentos con constancia NOM-151 vía proveedor autorizado | |
| `LEG-004` | Documentos corporativos y libros | E | Acta constitutiva, estatutos y actas de asamblea | |
| `LEG-005` | Poderes y facultades | E | Quién puede firmar qué y hasta cuándo | |
| `LEG-006` | Beneficiario controlador | E | Registro obligatorio de beneficiarios controladores | |
| `LEG-007` | Marcas y propiedad intelectual | E | Registros y vencimientos ante el IMPI | |
| `LEG-008` | Permisos y licencias | E | Vigencias de permisos con alertas | |
| `LEG-009` | Litigios | P | Expedientes, audiencias y estatus | |
| `LEG-010` | Despachos externos | P | Asuntos asignados a abogados externos y honorarios | |
| `LEG-011` | Negociación de contratos | P | Versiones y cambios entre las partes | |
| `LEG-012` | Análisis de contratos con IA | P | Detecta cláusulas de riesgo | |
| `LEG-030` | Estructura societaria del grupo | A | Empresas, participaciones y órganos de gobierno | |

## Cumplimiento (9)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `LEG-013` | Matriz de obligaciones | P | Todas las obligaciones regulatorias con responsable | |
| `LEG-014` | Políticas y código de ética | P | Publicación y acuse de lectura | |
| `LEG-015` | Línea de denuncia | P | Canal anónimo con seguimiento | |
| `LEG-016` | Datos personales | P | Solicitudes ARCO e inventario de datos personales | |
| `LEG-017` | Antilavado (onboarding) | P | Identificación de clientes y avisos para actividades vulnerables | |
| `LEG-018` | Debida diligencia de terceros | P | Revisión en listas negras y de personas políticamente expuestas | |
| `LEG-019` | Capacitación de cumplimiento | P | Cursos obligatorios con constancia | |
| `LEG-031` | Programa anticorrupción | A | Regalos, conflictos de interés e interacción con gobierno | |
| `LEG-032` | Monitoreo continuo | A | Pruebas automáticas de controles | |

## Riesgos y Seguros (7)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `LEG-020` | Registro de riesgos | P | Probabilidad, impacto y dueño de cada riesgo | |
| `LEG-021` | Mapa de calor | P | Visualización de los riesgos principales | |
| `LEG-022` | Planes de mitigación | P | Acciones y seguimiento por riesgo | |
| `LEG-023` | Pólizas de seguro | P | Coberturas, primas y vigencias | |
| `LEG-024` | Siniestros | P | Reclamaciones a la aseguradora | |
| `LEG-033` | Continuidad del negocio | A | Plan de recuperación ante desastres | |
| `LEG-034` | Indicadores de riesgo | A | Alertas cuando un riesgo crece | |

## Seguridad Corporativa (7)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `LEG-025` | Incidentes | P | Robos, daños y amenazas | |
| `LEG-026` | Accesos físicos | P | Control de entrada a instalaciones | |
| `LEG-027` | Rondas y guardias | P | Recorridos de vigilancia registrados | |
| `LEG-028` | Investigaciones internas | P | Casos con evidencia y resolución | |
| `LEG-029` | Protocolos | P | Procedimientos de seguridad y de viaje | |
| `LEG-035` | Riesgo por zona | A | Mapa de riesgo de ubicaciones y rutas | |
| `LEG-036` | Protección ejecutiva | A | Seguridad de directivos | |

## Asuntos Públicos (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `LEG-037` | Mapa de autoridades | A | Autoridades y actores relevantes para la empresa | |
| `LEG-038` | Monitoreo regulatorio | A | Cambios en el DOF y regulación resumidos con IA | |
| `LEG-039` | Cámaras y asociaciones | A | Membresías, comités y participación | |
| `LEG-040` | Trámites con gobierno | A | Gestiones y reuniones con autoridades | |
| `LEG-041` | Licitaciones públicas | A | Búsqueda y seguimiento de licitaciones de gobierno | |

## Sostenibilidad / ESG (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `LEG-042` | Huella de carbono | A | Emisiones de alcance 1, 2 y 3 | |
| `LEG-043` | Indicadores ESG | A | Métricas ambientales, sociales y de gobierno | |
| `LEG-044` | Reportes de sostenibilidad | A | Informes bajo estándares de sostenibilidad | |
| `LEG-045` | Cumplimiento ambiental | A | Permisos ambientales y manejo de residuos | |
| `LEG-046` | Metas | A | Objetivos de sostenibilidad y avance | |

## Fundación (4)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `LEG-047` | Programas sociales | A | Proyectos de impacto en la comunidad | |
| `LEG-048` | Donativos y recibos | A | Registro de donativos y comprobantes | |
| `LEG-049` | Voluntariado | A | Actividades y participación de empleados | |
| `LEG-050` | Medición de impacto | A | Resultados sociales de los programas | |

---

## Micro apps del área

- **E:** Generador de contratos básicos · Calculadora de plazos legales
- **P:** Matriz probabilidad × impacto
- **A:** Huella de carbono

Las micro apps son calculadoras independientes: no escriben en la base de datos de negocio, solo leen parámetros vigentes. No llevan clave porque no son funciones del catálogo.

## Agentes de IA del área

- **E:** Alertas de vencimientos (contratos, poderes, permisos)
- **P:** Revisor de contratos
- **A:** Monitoreo regulatorio (DOF)

Todo agente hereda los permisos del usuario que lo invoca. Un agente nunca ve lo que su usuario no puede ver.

## Reglas del área

- Los documentos legales tienen retención mínima de 5 años y no se borran: se archivan con versión y hash.
- Vencimientos (contratos, poderes, permisos, pólizas) alimentan el motor de alertas.
