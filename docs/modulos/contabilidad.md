# Motor · Contable
**Propósito:** libro contable inmutable alimentado por eventos.
**Funciones:** FIN-001..008, FIN-030, FIN-031 (aplicación mensual).
**Tablas:** esquema `contabilidad` (solo este motor escribe; rol de BD dedicado).
**Publica:** periodo_cerrado, depreciacion_aplicada. **Escucha:** todos los eventos con regla en `reglas_contables` (doc 07).
**Reglas:** ver doc 07 "Reglas del libro". Hash = sha256(hash_anterior + contenido canónico de la póliza y partidas). Cierre: verifica conciliaciones completas, CFDI recibidos registrados, depreciación/amortización/provisiones aplicadas; luego bloquea periodo y recalcula saldos.
**Pantallas:** doc 10 Contabilidad. **Pruebas:** inmutabilidad, cuadre, idempotencia, R-01..R-16.
