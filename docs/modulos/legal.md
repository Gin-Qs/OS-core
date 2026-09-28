# Módulo · Legal y Riesgo
**Propósito:** contratos, permisos, seguros y siniestros con control de vencimientos.
**Funciones:** LEG-001, LEG-008, LEG-023, LEG-024.
**Tablas:** esquema `legal`.
**Publica:** poliza_seguro_por_vencer, permiso_por_vencer (vía alertas), siniestro_abierto. **Escucha:** operaciones.incidencia_reportada (sugiere siniestro en robo/accidente).
**Reglas:** alertas a 60, 30 y 7 días de vencer (configurable); permiso o póliza vencida bloquea asignación de la unidad ligada; prima de seguro pagada crea provisión (FIN-031).
**Pantallas:** doc 10 Legal. **Pruebas:** bloqueo por vencimiento.
