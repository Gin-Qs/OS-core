# 02 · Arquitectura V1

## Capas
```
1 EXPERIENCIA   Web (oficina) · PWA móvil (campo y colaborador)
2 ACCESO        Supabase Auth + 2FA · empresa (tenant) · 10 roles · RLS
3 MÓDULOS       comercial · operaciones · finanzas · contabilidad · personas · legal · direccion · tecnologia
   MOTORES      fiscal · contable · flujos · documentos · alertas
4 EVENTOS       plataforma.eventos_outbox → despachador (pg_cron + Edge Function) → suscriptores
5 DATOS         ① esquemas por módulo ② contabilidad aislada ③ Vault ④ bitácora + alta frecuencia ⑤ Storage ⑥ vistas
6 INTELIGENCIA  tablero · alertas · costeo · rentabilidad
INTEGRACIONES   PAC · SAT (vía proveedor) · bancos (archivos) · IMSS/SUA (archivos) · correo
```

## Reglas
1. Un módulo no escribe en el esquema de otro; se comunica por `contracts/` (lectura) y eventos (escritura indirecta).
2. El evento se inserta en `eventos_outbox` en la misma transacción que el cambio.
3. Solo el motor contable escribe en `contabilidad`; pólizas inmutables con hash encadenado.
4. RLS por `empresa_id` en todas las tablas; permisos finos en acciones de servidor.
5. Secretos en Vault; salarios en tabla con RLS restringida.

## Almacenes en V1
| # | Almacén | Implementación |
|---|---|---|
| ① | Operativa | PostgreSQL (Supabase), esquemas: plataforma, comercial, operaciones, finanzas, contabilidad, personas, legal, direccion |
| ② | Libro contable | Esquema `contabilidad`; triggers bloquean UPDATE/DELETE; hash encadenado |
| ③ | Bóveda | Supabase Vault; `plataforma.secretos_ref` guarda solo la referencia |
| ④ | Eventos | `plataforma.bitacora` y, en general, todo dato de alta frecuencia que no sea un registro de negocio |
| ⑤ | Archivos | Supabase Storage (buckets: cfdi, evidencias, contratos, expedientes, bancos) + `plataforma.archivos` |
| ⑥ | Analítico | Vistas en esquema `analitica` (solo lectura) |

## Motores
| Motor | Ubicación | Responsabilidad |
|---|---|---|
| Fiscal | `src/engines/fiscal` | Construcción CFDI 4.0 (ingreso, pago, nómina), adaptador PAC, adaptador SAT, cálculos ISR/IVA/retenciones/DIOT/nómina |
| Contable | `src/engines/contable` + funciones SQL | Reglas evento→póliza, periodos, cierre, saldos, contabilidad electrónica, depreciación y arrendamientos |
| Flujos | `src/engines/flujos` | Aprobaciones configurables por tipo, monto y rol |
| Documentos | `src/engines/documentos` | Carga, hash, versiones, lectura de XML CFDI, URLs firmadas |
| Alertas | `src/platform/alertas` + pg_cron | Vencimientos y tareas programadas |

## Despachador de eventos
- pg_cron cada minuto invoca la Edge Function `despachador`.
- Lee eventos `pendiente` en orden, llama a cada suscriptor registrado, registra `eventos_procesados`.
- Reintentos con espera exponencial; tras 5 fallos pasa a `error` y genera alerta a Tecnología.
- Los suscriptores viven en `src/modules/*/subscribers` y se exponen por una ruta interna protegida.
