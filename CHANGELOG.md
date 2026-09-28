# Bitácora de cambios

Formato: [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/). Versionado semántico a partir de la primera versión desplegada.

## [Sin publicar]

### Agregado
- El SRS dividido en **20 documentos** bajo `docs/srs/`, con índice y navegación entre ellos, más dos anexos nuevos: **departamentos, características y funciones** (los 46 departamentos descritos) y **catálogo de diagramas** (36 diagramas, 6 de ellos vistas de conjunto).
- **`docs/SRS.md`**: especificación de requisitos de software completa — alcance y objetivos, dominio y glosario, necesidades del negocio, 11 procesos, 48 casos de uso, 164 requisitos funcionales, 75 no funcionales, arquitectura con 22 diagramas, comportamiento y máquinas de estado, escalabilidad, calidad, riesgos, decisiones abiertas y matrices de trazabilidad.
- Catálogo completo del núcleo dividido por área en `docs/areas/`: 402 funciones en 7 archivos editables, con clave, nivel, descripción y columna de notas.
- Documentos de seguridad y cumplimiento (16), operación y despliegue (17) y glosario (18).
- Registro de decisiones de arquitectura en `docs/adr/`: monolito modular, libro contable inmutable, atajos fiscales.
- `CONTRIBUTING.md`, `SECURITY.md`, CI, `.editorconfig`, `.nvmrc`.
- Migraciones base: plataforma con RLS, eventos y bitácora, libro contable inmutable. Probadas contra PostgreSQL 16.

### Cambiado
- El plan de construcción se reorganizó por categoría: fase 0 de fundación y después las 7 áreas, con claves de tarea por área (`T-FIN-04`).
- El alcance es el núcleo completo: se retiró el recorte por versiones y el satélite de industria.

### Retirado
- Documentación y tareas del satélite de Transporte. Se replanifica cuando el núcleo esté terminado.
