# ADR-0006 · Regímenes fiscales como catálogo y cálculos como definiciones de datos

- **Fecha:** 2026-09-26
- **Estado:** aceptada
- **Sustituye:** el supuesto implícito de que el cliente es siempre persona moral del régimen general

## Contexto

El SRS declaraba al cliente objetivo como "persona moral del régimen general" y especificaba un único cálculo de ISR (`RF-134`). Eso dejaba fuera a la mayor parte del mercado mexicano: RESICO de personas morales y de personas físicas, personas físicas con actividad empresarial, y coordinados —el régimen del autotransporte terrestre de carga, que es un giro objetivo del producto.

Hay dos problemas distintos detrás:

1. **El régimen cambia el comportamiento del sistema**, no solo un número. El régimen general acumula en **devengado**; RESICO, coordinados y personas físicas acumulan en **flujo de efectivo**. Eso no toca solo al motor fiscal: toca la regla que convierte un evento de negocio en póliza.
2. **La ley fiscal mexicana cambia cada año.** Tarifas, topes, tablas de RESICO, facilidades administrativas del autotransporte. Con el cálculo escrito en código, cada enero es un despliegue urgente, con todos los clientes de la instalación compartida en juego a la vez (`ADR-0004`).

## Decisión

**El régimen fiscal es una fila de un catálogo, y el cálculo es una definición de datos que un motor interpreta.**

1. **Catálogo de regímenes** (`plataforma.regimenes_fiscales`): clave del SAT, fundamento legal, tipo de persona, **base de acumulación** y obligaciones aplicables. Ninguna parte del código menciona un régimen por nombre.
2. **La base de acumulación gobierna la regla contable** (`RF-052`). La misma venta produce pólizas distintas en dos empresas de régimen distinto, con la misma regla y sin condicional en el código.
3. **Definiciones de cálculo versionadas con vigencia** (`RF-053`): una secuencia ordenada de pasos —agregación, parámetro, expresión, tabla progresiva, condicional— que el motor evalúa.
4. **Lenguaje restringido** (`RF-054`): aritmética decimal exacta, sin ciclos, sin llamadas externas, sin acceso fuera del alcance declarado. Toda ejecución termina.
5. **Papel de trabajo obligatorio** (`RF-055`): cada paso con su descripción, su fórmula, sus entradas, su resultado y su fundamento legal. El contador revisa el impuesto sin abrir el código.
6. **Ninguna definición se activa sin pasar sus casos dorados firmados por el contador** (`RF-056`).
7. **Reproducibilidad** (`RF-057`): cada ejecución guarda la versión de definición y de parámetros que usó. Recalcular un ejercicio anterior devuelve el resultado que devolvió entonces.
8. **Las definiciones son del proveedor, no del cliente** (`RF-058`). El cliente configura sus datos y sus opciones declaradas; nunca la mecánica del impuesto.

Regímenes soportados por el núcleo: general de personas morales, RESICO de personas morales, coordinados, persona física con actividad empresarial y profesional, y RESICO de personas físicas.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Un cálculo por régimen escrito en código, detrás de una interfaz común | Resuelve la multiplicidad pero no la temporalidad: cada cambio anual del SAT sigue siendo un despliegue urgente, y recalcular un ejercicio viejo con la ley de entonces exige mantener versiones de código vivas indefinidamente |
| Solo parámetros como datos, algoritmo fijo en código | Es lo que ya había (`RF-012`). Cubre un cambio de tasa, no un cambio de mecánica —y las facilidades administrativas del autotransporte cambian de mecánica, no solo de porcentaje |
| Un régimen por instalación, o una bandera por cliente | Viola directamente la regla 10 de `CLAUDE.md` y `ADR-0004`: nada por cliente |
| Un lenguaje de expresiones general (o ejecutar código del cliente) | Un intérprete sin límites dentro de una instalación multiempresa es una vía de fuga y de denegación de servicio. Por eso el lenguaje es cerrado y las definiciones son del proveedor |
| Soportar todos los regímenes del catálogo del SAT | Cada régimen exige su definición validada por un contador y sus casos dorados. Soportar uno sin validarlo es peor que no soportarlo: produce un número plausible y equivocado |

## Consecuencias

- **Más fácil:** agregar un régimen es una fila, una definición y sus casos dorados —sin tocar el motor. Un cambio del SAT es una carga de datos. Recalcular el pasado es exacto por construcción.
- **Más difícil:** hay que construir el intérprete y el editor de definiciones antes de poder cargar el primer cálculo. Es trabajo adelantado que no se ve en pantalla.
- **Dependencia del contador:** ninguna definición entra sin casos dorados firmados. Eso es deliberado: el cuello de botella es la validación, no la programación, y así debe ser cuando se trata de impuestos ajenos.
- **Riesgo concentrado, acotado:** una definición equivocada afectaría a todas las empresas de ese régimen a la vez. Por eso la puerta de los casos dorados no es negociable, y por eso las definiciones se publican por versión, con la anterior intacta.
- **Límite declarado:** los regímenes no listados no están soportados, y el SRS lo dice (§3.4) en lugar de dejarlo implícito, que fue el error que originó este ADR.

## Cómo se revierte

Volver a un cálculo en código es posible régimen por régimen: la definición activa documenta exactamente qué hay que programar, y el papel de trabajo sirve de prueba de equivalencia. Lo que no se revierte barato es la base de acumulación: si las reglas contables se escribieran con el devengado incrustado, soportar flujo de efectivo después significaría rehacer el motor contable. Por eso la base entra ahora, con las primeras migraciones, y no después.

## Detalle

Regímenes soportados y qué cambia con cada uno: SRS §3.4. Anatomía de una definición de cálculo y sus reglas de seguridad: SRS §7.4.1. Requisitos: `RF-051` a `RF-060`.
