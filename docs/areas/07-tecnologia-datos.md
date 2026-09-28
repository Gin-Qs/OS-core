# Tecnología y Datos — 37 funciones

Prefijo `TEC` · claves `TEC-001` a `TEC-037` · esquema de base de datos `plataforma` · 4 departamentos

**Nivel:** `E` Esencial (plan Basic) · `P` Profesional (Pro) · `A` Avanzado (Max). Cada plan incluye los niveles anteriores.

## Cómo se edita este archivo

- Una fila es una función. **Las claves son estables**: se usan en los commits, en el plan de construcción y en las pruebas. No se renumeran ni se reutilizan.
- Para **agregar** una función: se toma el siguiente número libre del área (`TEC-038`), aunque quede al final de la tabla del departamento que le toca.
- Para **quitar** una función: se marca `retirada` en Notas y se deja la fila. Borrarla libera una clave que ya vive en otros documentos.
- Para **mover** una función de nivel: se cambia la columna Nivel. Eso cambia en qué plan aparece, no su clave.
- La columna **Notas** está vacía a propósito: es para decisiones, dudas y recordatorios.

## Resumen por departamento

| Departamento | E | P | A | Total |
|---|---|---|---|---|
| Tecnología / Sistemas | 7 | 3 | 1 | 11 |
| Ciberseguridad | 0 | 7 | 4 | 11 |
| Datos e IA | 0 | 6 | 4 | 10 |
| Arquitectura Empresarial | 0 | 0 | 5 | 5 |
| **Total** | **7** | **16** | **14** | **37** |

---

## Tecnología / Sistemas (11)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `TEC-001` | Consola de usuarios y roles | E | Invitar usuarios, asignar roles y suspender accesos | |
| `TEC-002` | Inventario de equipos y licencias | E | Qué tiene cada quien y cuánto cuesta | |
| `TEC-003` | Mesa de ayuda de TI | E | Tickets internos de soporte | |
| `TEC-004` | Accesos ligados a altas y bajas | E | Al contratar se crea el usuario; al salir se revoca | |
| `TEC-005` | Configuración del sistema | E | Campos, flujos y catálogos propios | |
| `TEC-006` | Integraciones y API | E | Llaves y conexiones con otros sistemas | |
| `TEC-007` | Respaldos | E | Copias de seguridad y recuperación | |
| `TEC-008` | Proveedores de TI | P | Contratos de software e internet | |
| `TEC-009` | Automatizaciones sin código | P | Reglas tipo cuando pase X, haz Y | |
| `TEC-010` | Control de cambios | P | Historial y reversión de configuraciones | |
| `TEC-024` | Ambiente de pruebas | A | Probar cambios sin afectar la operación | |

## Ciberseguridad (11)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `TEC-011` | Políticas de acceso | P | Contraseñas, sesiones y horarios permitidos | |
| `TEC-012` | Recertificación de accesos | P | Revisión periódica de quién tiene qué acceso | |
| `TEC-013` | Actividad sospechosa | P | Alertas de accesos anómalos | |
| `TEC-014` | Dispositivos autorizados | P | Desde qué equipos se puede entrar | |
| `TEC-015` | Incidentes de seguridad | P | Registro y respuesta a incidentes | |
| `TEC-016` | Simulacros de phishing | P | Pruebas y capacitación a empleados | |
| `TEC-017` | Riesgo de proveedores de TI | P | Evaluación de terceros con acceso a sistemas | |
| `TEC-025` | SSO corporativo | A | Inicio de sesión con la cuenta de la empresa | |
| `TEC-026` | Monitoreo continuo | A | Envío de eventos a herramientas de seguridad (SIEM) | |
| `TEC-027` | Pruebas de penetración | A | Seguimiento de hallazgos de seguridad | |
| `TEC-028` | Clasificación de información | A | Información pública, interna y confidencial | |

## Datos e IA (10)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `TEC-018` | Constructor de reportes | P | Reportes propios sin programar | |
| `TEC-019` | Tableros personalizados | P | Vistas a la medida por rol | |
| `TEC-020` | Conexión a BI | P | Integración con Power BI, Looker y similares | |
| `TEC-021` | Calidad de datos | P | Duplicados, vacíos e inconsistencias | |
| `TEC-022` | Agentes personalizados | P | La empresa crea sus propios agentes de IA con permisos | |
| `TEC-023` | Automatizaciones con IA | P | Flujos que leen, clasifican y deciden | |
| `TEC-029` | Modelos predictivos | A | Pronósticos de demanda, flujo de efectivo y cancelaciones | |
| `TEC-030` | Almacén de datos del grupo | A | Datos de todas las empresas juntos | |
| `TEC-031` | Gobierno de datos | A | Catálogo de datos y dueño de cada uno | |
| `TEC-032` | Consumo de IA por área | A | Uso y costo de IA por área | |

## Arquitectura Empresarial (5)

| Clave | Función | Nivel | Qué hace | Notas |
|---|---|---|---|---|
| `TEC-033` | Mapa de sistemas | A | Sistemas e integraciones de la empresa | |
| `TEC-034` | Estándares | A | Lineamientos técnicos y de integración | |
| `TEC-035` | Roadmap tecnológico | A | Plan de evolución tecnológica | |
| `TEC-036` | Gestión avanzada de APIs | A | Control de APIs y webhooks | |
| `TEC-037` | Multi-entorno | A | Ambientes de desarrollo, pruebas y producción | |

---

## Micro apps del área

- **E:** Costo de licencias y equipos
- **P:** Consumo de IA estimado

Las micro apps son calculadoras independientes: no escriben en la base de datos de negocio, solo leen parámetros vigentes. No llevan clave porque no son funciones del catálogo.

## Agentes de IA del área

- **E:** Soporte de TI (resuelve dudas de uso del sistema)
- **P:** Constructor de reportes por lenguaje natural · Seguridad (accesos anómalos)

Todo agente hereda los permisos del usuario que lo invoca. Un agente nunca ve lo que su usuario no puede ver.

## Reglas del área

- Esta área tiene dos caras: el área de sistemas del cliente y el puente de configuración de la plataforma.
- Toda credencial (CSD, e.firma, API, CLABE) vive en Vault; en las tablas solo queda la referencia.
- Un permiso es recurso + acción + alcance de datos + campos sensibles. Los agentes de IA heredan los permisos del usuario que los invoca.
