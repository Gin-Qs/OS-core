# Módulo · Personas
**Propósito:** expediente, incidencias, vacaciones y nómina con cumplimiento IMSS/SAT/ISN.
**Funciones:** PER-001..009, 011, 015, 016.
**Tablas:** esquema `personas` (`condiciones_salariales` con RLS estricta).
**Publica:** empleado_alta, empleado_baja, nomina_timbrada, nomina_dispersada. **Escucha:** finanzas.gasto_comprobado (afecta saldos del empleado).
**Reglas:**
- Ciclo de nómina: abierto → calculado → autorizado (Dirección ve totales) → timbrado → dispersado → cerrado. No se recalcula tras timbrar; correcciones por nómina extraordinaria.
- Vacaciones por antigüedad según tabla vigente en parámetros; solicitudes con aprobación del jefe.
- Alta de empleado exige RFC, CURP, NSS, CP fiscal, SDI; genera movimiento IMSS pendiente de presentar.
- Datos médicos (incapacidades) visibles solo para Personas.
**Pantallas:** doc 10 Personas. **Pruebas:** CD-06, RLS de salarios.
