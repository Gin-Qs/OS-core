# 16 · Seguridad y cumplimiento

Este documento define la línea base de seguridad del producto. **Nada de aquí es add-on ni configurable a la baja**: aplica a toda empresa, en todo plan, desde el primer día.

## 1. Identidad y acceso

| Control | Regla |
|---|---|
| Autenticación | Correo + contraseña con 2FA TOTP obligatorio para los roles Propietario, Administrador, Dirección, Tesorería y Contabilidad |
| Sesión | Expira por inactividad; el cierre de sesión revoca el token; la sesión guarda la empresa activa |
| Modelo de permiso | `recurso + acción + alcance de datos + campos sensibles`. Acciones: ver, crear, editar, aprobar, eliminar, exportar |
| Visibilidad | Lo que un usuario ve = lo contratado ∩ lo que permite su rol. Lo que no puede ver, no aparece en el menú |
| Verificación | En el servidor, siempre: `requirePermiso(recurso, accion)`. Ocultar en la UI no es un control de seguridad |
| Altas y bajas | La baja de un empleado revoca sus accesos el mismo día (`TEC-004`) |
| Agentes de IA | Heredan los permisos del usuario que los invoca. Un agente nunca ve lo que su usuario no puede ver |

## 2. Aislamiento entre empresas

El sistema es multiempresa desde la primera migración. Toda tabla de negocio lleva `empresa_id` y una política RLS que compara contra la empresa activa de la sesión.

- **RLS nunca se desactiva.** Ni para depurar, ni para una migración, ni "un momento".
- Las funciones que corren con privilegios elevados (`security definer`) se revisan una por una y se documentan.
- Cada módulo incluye una prueba que confirma que un usuario de la empresa A no lee ni escribe datos de la empresa B.

## 3. Datos sensibles

| Dato | Dónde vive | Quién lo ve |
|---|---|---|
| CSD, e.firma, credenciales de PAC, banco y API | Supabase Vault; en las tablas solo la referencia | Nadie: se usan, no se leen. Una vez guardados no se vuelven a mostrar |
| CLABE y datos bancarios de terceros | Vault | Tesorería, enmascarados salvo los últimos dígitos |
| Salarios y percepciones | Tabla con RLS restringida | Rol Personas y Propietario |
| Incapacidades y exámenes médicos | Tabla con RLS restringida, separada del expediente general | Rol Personas |
| Datos personales de clientes y empleados | Tablas de negocio con RLS | Según rol y alcance de datos |

Regla general: un dato sensible que se puede derivar no se guarda. Si se guarda, se cifra y se restringe por rol, no por pantalla.

## 4. Rastro y evidencia

- **Bitácora.** Toda escritura de negocio registra quién, qué, cuándo, desde dónde y el valor anterior. La bitácora no se edita ni se borra.
- **Libro contable inmutable.** Pólizas y partidas son de solo inserción, con hash encadenado. Los errores se corrigen con póliza de reversa, no con UPDATE.
- **Periodos cerrados.** Un periodo contable cerrado rechaza escrituras. Reabrirlo es una acción registrada que solo puede hacer Contabilidad con aprobación de Dirección.
- **Archivos.** Se guardan con hash y versión. Los documentos legales y fiscales no se borran: se archivan.

## 5. Obligaciones legales que el sistema debe soportar

| Obligación | Dónde se cumple |
|---|---|
| Conservación de contabilidad y comprobantes 5 años (CFF art. 30) | Archivos con versión y hash; los periodos cerrados no se borran |
| CFDI 4.0, complemento de pagos 2.0, nómina 1.2 | Motor fiscal (doc 08) |
| Contabilidad electrónica con código agrupador SAT | `FIN-006` |
| DIOT y declaraciones informativas | `FIN-014`, `FIN-015` |
| Ley Federal de Protección de Datos Personales: derechos ARCO, aviso de privacidad, inventario de datos | `LEG-016` (nivel Profesional); la base técnica —RLS, bitácora, cifrado— está desde Esencial |
| Antilavado: identificación de clientes en actividades vulnerables | `LEG-017` (Profesional) |
| Beneficiario controlador (CFF art. 32-B Ter) | `LEG-006` |
| NOM-035 (riesgos psicosociales) | `PER-019` |
| NOM-151 (constancia de conservación de mensajes de datos) | `LEG-003`, vía proveedor autorizado |

## 6. Respaldos y recuperación

- Respaldo diario automático de la base de datos, con retención mínima de 30 días.
- Prueba de restauración **trimestral**, documentada. Un respaldo que nunca se restauró no es un respaldo.
- Exportación bajo demanda de los datos de una empresa, en formato abierto: el cliente puede irse con su información.
- Objetivo de recuperación: RPO 24 h, RTO 8 h. Si el proveedor no lo sostiene, se ajusta el objetivo, no la promesa.

## 7. Desarrollo seguro

- Secretos solo en variables de entorno o Vault. Ningún secreto en el repositorio: si uno se filtra, se rota antes de borrarlo del historial.
- Dependencias con versión fija y auditoría en CI.
- Toda entrada se valida con Zod en el servidor, aunque el formulario ya la haya validado.
- Sin SQL concatenado: consultas parametrizadas siempre.
- Los datos de prueba nunca son datos reales de un cliente.

## 8. Reporte de vulnerabilidades

Ver `SECURITY.md` en la raíz del repositorio.
