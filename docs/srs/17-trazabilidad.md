## 17. Trazabilidad

> Parte del [SRS del OS](./00-indice.md). Las claves (`RF-`, `RNF-`, `CU-`, `RN-`) son estables y se referencian entre documentos.

### 17.1 De objetivo de negocio a verificación

| Objetivo | Proceso | Caso de uso | Requisitos | Prueba que lo verifica |
|---|---|---|---|---|
| `OB-01` Contabilidad al día | `P-01`, `P-02`, `P-06` | `CU-022`, `CU-030`, `CU-041` | `RF-121`, `RF-125`, `RF-126` | Flujo E2E 1 y 4 · `CD-05` |
| `OB-02` Cobrar más rápido | `P-01`, `P-07` | `CU-023`, `CU-024` | `RF-142`, `RF-143`, `RF-145` | Flujo E2E 1 · `CD-02` |
| `OB-03` Sin multas ni deducciones perdidas | `P-02`, `P-06` | `CU-030`, `CU-031`, `CU-043` | `RF-131` a `RF-141` | `CD-04`, `CD-07`, `CD-08`, `CD-09` |
| `OB-04` Rentabilidad por trabajo | `P-03` | `CU-050`, `CU-055` | `RF-184`, `RF-188`, `RF-155` | `CD-10` |
| `OB-05` Control de accesos y autorizaciones | `P-08`, `P-02` | `CU-004`, `CU-011`, `CU-033` | `RF-004` a `RF-009`, `RF-028`, `RF-152` | Suite de seguridad |
| `OB-06` Nómina propia y correcta | `P-04` | `CU-061`, `CU-062` | `RF-160` a `RF-175` | Flujo E2E 3 · `CD-06` |
| `OB-07` Dejar de recapturar | `P-01` | `CU-020`, `CU-021`, `CU-022` | `RF-102`, `RF-104`, `RF-116` | Flujo E2E 1, con verificación campo a campo |
| `OB-08` Nada depende de la memoria | `P-05`, `P-08` | `CU-071`, `CU-072` | `RF-025`, `RF-026`, `RF-207` | Prueba de vencimiento simulado |
| `OB-09` Poder demostrar lo hecho | `P-09` | `CU-012` | `RF-024`, `RF-123`, `RNF-070` a `RNF-074` | Verificación de cadena de hash |
| `OB-10` Crecer sin romper | Todos | `CU-001` | `RF-001`, `RF-002`, `RNF-090` a `RNF-098` | Alta de segunda empresa sin código |

### 17.2 De módulo a esquema, catálogo y plan

| Área del catálogo | Módulo de código | Esquema | Archivo del catálogo | Tareas del plan |
|---|---|---|---|---|
| Finanzas | `finanzas`, `contabilidad` | `finanzas`, `contabilidad` | `docs/areas/01-finanzas.md` | `T-FIN-*` |
| Personas | `personas` | `personas` | `docs/areas/02-personas.md` | `T-PER-*` |
| Comercial | `comercial` | `comercial` | `docs/areas/03-comercial.md` | `T-COM-*` |
| Operaciones | `operaciones` | `operaciones` | `docs/areas/04-operaciones.md` | `T-OPE-*` |
| Legal y Riesgo | `legal` | `legal` | `docs/areas/05-legal-riesgo.md` | `T-LEG-*` |
| Dirección | `direccion` | `direccion`, `analitica` | `docs/areas/06-direccion.md` | `T-DIR-*` |
| Tecnología y Datos | `tecnologia` | `plataforma` | `docs/areas/07-tecnologia-datos.md` | `T-TEC-*` |
| — (transversal) | `platform`, `engines/*` | `plataforma`, `contabilidad` | — | `T-PLT-*` |

Esta correspondencia **uno a uno** entre lo que se vende, lo que se programa y dónde se guarda es lo que permite responder en segundos: "¿dónde vive `FIN-020`?" → área Finanzas → módulo `finanzas` → esquema `finanzas` → tarea `T-FIN-04`.

### 17.3 Documentos que complementan este SRS

| Documento | Qué contiene que aquí no está |
|---|---|
| `docs/areas/00-indice.md` y `01` a `08` | El catálogo completo de las 402 funciones, con nivel, departamento y descripción |
| `docs/04-modelo-de-datos.md` | El modelo físico: tablas, columnas, llaves e índices |
| `docs/05-catalogo-eventos.md` | Cada evento con su carga útil y sus suscriptores |
| `docs/06-matriz-roles.md` | La matriz completa de recurso × rol × acción |
| `docs/07-reglas-contables.md` | El catálogo de cuentas y las reglas `R-01` a `R-16` |
| `docs/08-motor-fiscal.md` | El detalle de construcción de cada tipo de comprobante y cada cálculo |
| `docs/09-integraciones.md` | El contrato de cada adaptador |
| `docs/10-pantallas.md` | La navegación y las pantallas por área |
| `docs/11-plan-de-construccion.md` | Las tareas, su orden, sus dependencias y su estado |
| `docs/12-pruebas-y-calidad.md` | El detalle de cada caso dorado |
| `docs/16-seguridad-y-cumplimiento.md` | Los controles de seguridad y las obligaciones legales |
| `docs/17-operacion-y-despliegue.md` | Entornos, migraciones, tareas programadas y puesta en marcha |
| `docs/18-glosario.md` | El glosario extendido |
| `docs/adr/` | Las decisiones de arquitectura con su contexto completo |

### 17.4 Control de cambios de este documento

| Regla |
|---|
| Este SRS es la línea base. Cuando el código y el SRS difieren, **gana el SRS**; si el SRS está equivocado, se corrige aquí primero y después el código |
| Todo cambio de alcance se refleja aquí **antes** de programarse |
| Un requisito retirado se marca como retirado y conserva su número. Las claves nunca se reciclan |
| Un cambio que afecte a un requisito obligatorio exige revisar las pruebas que lo verifican, en el mismo cambio |
| La versión del documento se incrementa en cada cambio de alcance; los cambios de redacción no la incrementan |

---

---

# Anexo A · Departamentos, características y funciones

---

[← 16-decisiones-abiertas](./16-decisiones-abiertas.md) · [Índice](./00-indice.md) · [A · Departamentos y funciones →](./18-departamentos-y-funciones.md)
