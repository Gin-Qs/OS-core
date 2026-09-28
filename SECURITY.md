# Seguridad

Los controles del producto están en `docs/16-seguridad-y-cumplimiento.md`. Este documento cubre el repositorio.

## Secretos

Ningún secreto entra al repositorio: ni CSD, ni e.firma, ni credenciales de PAC, banco, correo o base de datos. Van en variables de entorno (desarrollo) o en Supabase Vault (producción). `.env.example` documenta qué variables existen, nunca sus valores.

**Si un secreto se filtra:** primero se rota, después se limpia el historial. Al revés no sirve de nada — lo que ya se publicó, ya se publicó.

## Datos de prueba

Los entornos de desarrollo y pruebas nunca contienen datos reales de un cliente: ni RFC reales, ni nóminas, ni CFDI emitidos. Si hace falta reproducir un caso, se construye la semilla que lo reproduce.

## Dependencias

Versiones fijas, auditoría en CI. Una dependencia nueva en el camino del dinero (cálculo fiscal, criptografía, generación de XML) necesita justificación en el PR.

## Reportar una vulnerabilidad

Por correo privado al responsable del repositorio, no como issue público. Incluir qué se puede hacer con ella, cómo reproducirla y qué datos quedarían expuestos. La respuesta llega en 72 horas.

Si la vulnerabilidad afecta datos de una empresa en producción, se notifica a esa empresa antes de publicar cualquier detalle.
