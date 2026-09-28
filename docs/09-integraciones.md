# 09 · Integraciones V1

Cada integración vive detrás de un **adaptador** (`src/engines/*/adapters` o `src/platform/integraciones`) con interfaz propia, para cambiar de proveedor sin tocar módulos. Credenciales en Vault vía `plataforma.integraciones`.

| Integración | Interfaz | Modo | Pendiente |
|---|---|---|---|
| PAC | `timbrar(xml|json)`, `cancelar(uuid, motivo, sustituto)`, `estado(uuid)` | API REST; sellado por el PAC con CSD cargado (T4); sandbox para desarrollo | Elegir proveedor que soporte CFDI 4.0, pagos 2.0, nómina 1.2 |
| SAT descarga masiva | `solicitar`, `verificar`, `descargar` | Vía API de proveedor (T5); tarea diaria con pg_cron | Elegir proveedor (idealmente el mismo PAC) |
| Bancos | `importarEstadoCuenta(archivo, banco)` → movimientos; `generarLayoutPagos(pagos, banco)` | Archivos CSV/XLSX/TXT por banco; parser por banco | Definir banco y obtener sus formatos |
| IMSS / SUA / INFONAVIT | `generarArchivoMovimientos(tipo, empleados)` | Archivos para carga manual en IDSE/SUA | Validar formatos vigentes con contador |
| Correo | `enviar(plantilla, destinatarios, adjuntos)` | Resend: facturas (XML+PDF), recordatorios de cobranza, alertas | Dominio de correo configurado |
| n8n / Slack | Webhooks salientes de eventos seleccionados | Opcional, desactivado | — |

## Cómo se agrega una integración

1. Se define la **interfaz** desde las necesidades del sistema, no desde la API del proveedor.
2. El adaptador traduce el formato del proveedor a esa interfaz. Ningún módulo de negocio conoce al proveedor.
3. Las credenciales se guardan en Vault vía `plataforma.integraciones`; en las tablas solo queda la referencia.
4. Todo webhook entrante se valida por firma y es idempotente: recibir el mismo evento dos veces no duplica nada.
5. Todo error del proveedor se guarda con su código y su mensaje, no como "falló".

Un satélite de industria agrega sus propias integraciones (telemetría, paqueterías) siguiendo estas mismas reglas, sin tocar las de aquí.
