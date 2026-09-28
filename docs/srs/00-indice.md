# SRS — Especificación de Requisitos de Software
## OS · Sistema Operativo de Negocio — índice maestro

La especificación está dividida en documentos independientes para poder leerla y editarla por partes. Cada archivo es autocontenido y se enlaza con los demás por sus claves (`RF-`, `RNF-`, `CU-`, `RN-`, `P-`, `OB-`), nunca por número de página.

## Documentos

| § | Documento |
|---|---|
| 1 | [Introducción](./01-introduccion.md) |
| 2 | [Descripción general del sistema](./02-descripcion-general.md) |
| 3 | [Dominio del problema](./03-dominio-y-glosario.md) |
| 4 | [Necesidades del negocio](./04-necesidades-del-negocio.md) |
| 5 | [Procesos del negocio](./05-procesos-del-negocio.md) |
| 6 | [Casos de uso](./06-casos-de-uso.md) |
| 7 | [Requisitos funcionales](./07-requisitos-funcionales.md) |
| 8 | [Requisitos no funcionales](./08-requisitos-no-funcionales.md) |
| 9 | [Modelo de datos lógico](./09-modelo-de-datos.md) |
| 10 | [Arquitectura del sistema](./10-arquitectura.md) |
| 11 | [Comportamiento del sistema](./11-comportamiento-del-sistema.md) |
| 12 | [Interfaces](./12-interfaces.md) |
| 13 | [Escalabilidad y evolución](./13-escalabilidad-y-evolucion.md) |
| 14 | [Calidad, pruebas y aceptación](./14-calidad-y-pruebas.md) |
| 15 | [Riesgos](./15-riesgos.md) |
| 16 | [Decisiones abiertas](./16-decisiones-abiertas.md) |
| 17 | [Trazabilidad](./17-trazabilidad.md) |
| A | [Departamentos, características y funciones](./18-departamentos-y-funciones.md) |
| B | [Catálogo de diagramas](./19-diagramas.md) |
| C | [Multiempresa, licencias y distribución](./20-multiempresa-y-distribucion.md) |
| D | [El plano de operación (consola del operador)](./21-plano-de-operacion.md) |
| E | [Mapa de riesgos y resolución](./22-mapa-de-riesgos.md) |

El documento completo en un solo archivo sigue disponible en [`../SRS.md`](../SRS.md), para búsqueda e impresión. El catálogo de las 402 funciones, editable por área, está en [`../areas/`](../areas/00-indice.md).

---

## 0. Control del documento

| Campo | Valor |
|---|---|
| Producto | OS — Sistema Operativo de Negocio (nombre de trabajo) |
| Versión del documento | 1.0 |
| Estado | Línea base para construcción |
| Fecha | 22 de septiembre de 2026 |
| Autor | Gab (propietario del producto) |
| Alcance cubierto | Núcleo universal completo: 402 funciones, 7 áreas, 46 departamentos |
| Fuera de alcance | Satélites de industria · paquetes de modelo de negocio (documentados como extensión futura) |
| Documentos que complementa | `docs/01-alcance.md` · `docs/areas/*` (catálogo de funciones) · `docs/04-modelo-de-datos.md` · `docs/05-catalogo-eventos.md` · `docs/06-matriz-roles.md` · `docs/07-reglas-contables.md` · `docs/08-motor-fiscal.md` · `docs/11-plan-de-construccion.md` · `docs/12-pruebas-y-calidad.md` · `docs/16-seguridad-y-cumplimiento.md` · `docs/17-operacion-y-despliegue.md` |

### 0.1 Para quién es este documento

| Lector | Qué busca aquí | Por dónde empieza |
|---|---|---|
| Quien programa (persona o agente de IA) | Qué construir exactamente y con qué criterio se da por terminado | §7 Requisitos funcionales · §10 Arquitectura · §11 Comportamiento |
| El contador que valida | Que las reglas fiscales y contables sean correctas | §3 Dominio · §5.6 Proceso de cierre · §7.5 Motor contable · §7.4 Motor fiscal |
| Quien vende y define el producto | Qué resuelve, para quién y cómo se mide | §1 Introducción · §4 Necesidades del negocio · §6 Casos de uso |
| Quien audita o revisa cumplimiento | Qué controles existen y cómo se evidencian | §8 Requisitos no funcionales · §10.8 Seguridad · §11.9 Auditoría |
| Quien llegue en dos años a mantenerlo | Por qué está hecho así | §10.10 Decisiones · §13 Escalabilidad |

### 0.2 Convenciones

**Nivel de obligatoriedad.** Este documento usa tres verbos con significado técnico exacto:

| Verbo | Significado | Consecuencia de incumplirlo |
|---|---|---|
| **debe** | Requisito obligatorio | El sistema no se considera conforme. Bloquea la liberación |
| **debería** | Recomendación fuerte | Se puede incumplir solo con justificación registrada en un ADR |
| **puede** | Opcional | Queda a criterio de quien implementa |

**Identificadores.** Todo elemento rastreable lleva clave estable y permanente:

| Prefijo | Qué identifica | Ejemplo |
|---|---|---|
| `OB-nn` | Objetivo de negocio | `OB-03` |
| `OU-nn` | Objetivo de usuario | `OU-07` |
| `P-nn` | Proceso de negocio | `P-01` |
| `CU-nnn` | Caso de uso | `CU-022` |
| `RF-nnn` | Requisito funcional | `RF-108` |
| `RNF-nnn` | Requisito no funcional | `RNF-054` |
| `RN-nnn` | Regla de negocio (invariante del dominio) | `RN-012` |
| `EV-nn` | Evento del bus | `EV-17` |
| `ACT-nn` | Actor | `ACT-04` |
| `RI-nn` | Riesgo | `RI-05` |
| `FIN-nnn` … `TEC-nnn` | Función del catálogo de producto | `FIN-020` |
| `CD-nn` | Caso dorado de prueba | `CD-06` |

Las claves **nunca se renumeran ni se reutilizan**. Un requisito retirado se marca como retirado y conserva su número; su clave sigue viviendo en commits, pruebas y en este documento.

**Prioridad.** Se usa MoSCoW acotado:

| Prioridad | Significado operativo |
|---|---|
| **Obligatorio** | Sin esto el sistema no puede usarse en producción, o incumple la ley |
| **Importante** | El sistema funciona sin esto, pero el usuario sufre o improvisa fuera del sistema |
| **Deseable** | Mejora medible, no bloquea nada |

**Ambigüedad prohibida.** Este documento no usa las palabras "rápido", "amigable", "seguro", "robusto" o "escalable" como requisito. Cada una está traducida a un número verificable en §8. Donde un dato todavía no existe —porque depende de una validación externa— se declara explícitamente como **decisión abierta** en §16 con su responsable y su fecha límite, en lugar de dejarse al criterio de quien programa.
