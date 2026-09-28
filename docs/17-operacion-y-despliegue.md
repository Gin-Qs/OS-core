# 17 · Operación y despliegue

## 1. Entornos

| Entorno | Para qué | Datos | Quién entra |
|---|---|---|---|
| **local** | Desarrollo diario | Semillas y datos falsos | Quien construye |
| **dev** (Supabase + Vercel preview) | Integración, pruebas E2E, revisión de ramas | Datos falsos, PAC en sandbox | Quien construye |
| **prod** | La empresa real | Datos reales, PAC productivo | Acceso restringido y registrado |

Reglas de entorno:

- **Nunca se copian datos de prod a dev.** Si hace falta reproducir un caso, se construye la semilla que lo reproduce.
- Cada entorno tiene sus propias credenciales de PAC, banco y correo. Un secreto no se comparte entre entornos.
- El PAC de sandbox y el productivo se configuran por entorno, nunca por bandera dentro del código.

## 2. Migraciones de base de datos

- Toda migración es un archivo SQL versionado en `supabase/migrations/`, con nombre `AAAAMMDDHHMMSS_descripcion.sql`.
- Las migraciones son **acumulativas y hacia adelante**: no se editan las ya aplicadas en prod. Un error se corrige con una migración nueva.
- Toda migración que crea una tabla de negocio crea también su política RLS **en la misma migración**. Una tabla sin RLS no se mezcla.
- Tras cada migración: `supabase gen types typescript --local > src/platform/db/types.ts`.
- Antes de aplicar en prod: respaldo, y `supabase db reset` en local en verde.
- Una migración que borra datos o columnas requiere su propio ADR (`docs/adr/`).

## 3. Despliegue

```
rama → push → CI (lint, typecheck, test, migraciones) → preview en Vercel → revisión → merge a main → producción
```

- `main` siempre debe poder desplegarse. No se mezcla nada en rojo.
- Las migraciones de prod se aplican **antes** del despliegue del código que las necesita.
- Un cambio que rompe compatibilidad se hace en dos pasos: primero el código que tolera ambos estados, después la migración que elimina el viejo.

## 4. Tareas programadas

| Tarea | Frecuencia | Qué hace | Dónde |
|---|---|---|---|
| Despachador de eventos | cada minuto | Procesa el outbox, reintenta fallos | pg_cron + Edge Function |
| Descarga masiva CFDI | diaria | Baja los CFDI emitidos y recibidos del SAT | Edge Function |
| Alertas y vencimientos | diaria | Contratos, permisos, pólizas, obligaciones fiscales, CxC | pg_cron |
| Cobranza automatizada | diaria | Recordatorios de facturas vencidas | Edge Function |
| Respaldo | diaria | Respaldo completo con retención de 30 días | Proveedor |
| Tipo de cambio DOF | diaria | Actualiza el tipo de cambio del día | Edge Function |

Toda tarea programada es **idempotente**: correrla dos veces el mismo día no duplica nada.

## 5. Monitoreo y errores

- **Bandeja de eventos fallidos.** Un evento que agota sus reintentos va a dead-letter y genera alerta. Nadie se entera de un evento perdido por casualidad.
- **Errores de timbrado.** Todo rechazo del PAC se guarda con su código y su mensaje, no solo "falló".
- Métricas mínimas a vigilar: eventos en cola, eventos fallidos, timbrados rechazados, tareas programadas que no corrieron, tiempo de respuesta de las páginas de captura.
- Los logs no contienen datos sensibles: ni CLABE, ni salarios, ni contenido de XML con RFC completo.

## 6. Puesta en marcha de una empresa nueva

Orden obligatorio: cada paso depende del anterior.

1. Alta de la empresa: RFC, régimen fiscal, domicilio, logo, sucursales.
2. Catálogos SAT vigentes y parámetros fiscales del año.
3. Catálogo de cuentas con código agrupador (revisado por el contador).
4. Usuarios y roles.
5. Credenciales: PAC, banco, correo. Se cargan a Vault, no a una tabla.
6. Maestros: clientes, proveedores, productos y servicios, empleados.
7. **Saldos iniciales**: balanza de apertura, CxC y CxP abiertas, activos con su depreciación acumulada.
8. Verificación: la balanza inicial del sistema es igual a la del contador, al centavo.
9. Un timbrado de prueba en sandbox y uno real.
10. Dos cierres mensuales en paralelo con el método anterior antes de apagarlo.

El paso 8 es el que no se puede saltar. Un sistema contable que arranca con saldos que no cuadran nunca vuelve a cuadrar.

## 7. Costos de operación a vigilar

Supabase (base de datos, almacenamiento, transferencia) · Vercel · PAC (por timbre) · correo transaccional · proveedor de descarga masiva · consumo de IA por agentes. El costo por timbre y el consumo de IA son los que escalan con el uso: se miden desde el primer mes.
