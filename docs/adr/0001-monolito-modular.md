# ADR-0001 · Monolito modular en vez de microservicios

- **Fecha:** 2026-09-16
- **Estado:** aceptada

## Contexto
El sistema cubre siete áreas de negocio que comparten datos constantemente (una factura toca Comercial, Finanzas y Contabilidad en la misma operación). Lo construye principalmente una persona con ayuda de IA. Los microservicios repartirían ese trabajo en despliegues, contratos de red y consistencia eventual que ese equipo no puede operar.

Al mismo tiempo, un monolito sin fronteras internas se vuelve imposible de mantener en cuanto pasa de unas decenas de funciones, y aquí son 402.

## Decisión
Construir una sola aplicación desplegable, dividida en módulos con fronteras reales: cada módulo con su propio código, su propio esquema de base de datos y un único punto de entrada público (`contracts/`). La comunicación entre módulos es por eventos, no por llamadas directas a internals.

## Alternativas consideradas
| Alternativa | Por qué no |
|---|---|
| Microservicios | Costo de operación desproporcionado para el equipo; la consistencia entre áreas se volvería un problema diario |
| Monolito sin fronteras | Se degrada en meses; con 402 funciones, imposible razonar sobre el impacto de un cambio |
| Varias aplicaciones separadas por área | El usuario vive en una sola pantalla; separar la experiencia para simplificar el código es optimizar lo equivocado |

## Consecuencias
- Más fácil: una transacción, un despliegue, un esquema de pruebas, refactorizar entre módulos.
- Más difícil: escalar un área sola, o darle a un área su propio ritmo de despliegue.
- La frontera hay que **hacerla cumplir por herramienta** (`eslint-plugin-boundaries`), no por disciplina: una frontera que solo vive en la cabeza no existe.

## Cómo se revierte
Un módulo con contrato y esquema propios puede extraerse a un servicio separado sin reescribir su dominio: se reemplaza su contrato local por uno remoto y su suscripción a eventos por una cola. Es un trabajo acotado, no una reescritura.
