# Módulo · Plataforma
**Propósito:** base común: empresa, identidad, permisos, eventos, bitácora, archivos, secretos, aprobaciones, alertas, catálogos.
**Funciones:** TEC-001, TEC-005, TEC-006, TEC-007 + requisitos de plataforma.
**Tablas:** esquema `plataforma` (doc 04).
**Publica:** plataforma.evento_fallido. **Escucha:** personas.empleado_alta (crea usuario), personas.empleado_baja (revoca).
**Reglas:**
- Empresa activa en sesión; todas las consultas filtradas por `empresa_id` (RLS con `auth.jwt()` → claims de empresa).
- 2FA obligatorio para roles con acceso financiero.
- Administrador no ve contenido de negocio.
- Folios con bloqueo de fila para evitar duplicados.
**Pantallas:** Configuración (doc 10). **Pruebas:** RLS multiempresa, permisos por rol, idempotencia de eventos.
