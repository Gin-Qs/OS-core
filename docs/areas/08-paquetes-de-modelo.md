# Paquetes de modelo de negocio — 140 funciones (add-on, fuera del núcleo)

> **Esto no es núcleo.** Son add-ons que se contratan aparte. Está documentado aquí para que el modelo de datos y los límites de módulo se diseñen sabiendo lo que puede llegar después, y para que nadie lo reinvente a medias dentro del núcleo.

Se activan por **modelo de negocio**, no por industria. Dentro de cada paquete, el plan define la profundidad: `E` Esencial (Basic) · `P` Profesional (Pro) · `A` Avanzado (Max).

## 1. Inventarios y Cadena de Suministro (40)

Base previa: inventario básico en el nivel Esencial del núcleo, condicional (solo si la empresa maneja bienes físicos).

### Almacén e Inventarios
- **E:** Multi-almacén · Traspasos · Lotes y series · Caducidades (FEFO) · Ubicaciones · Conteos cíclicos · Kits y ensambles · Códigos de barras y app móvil · Métodos de costeo (promedio, PEPS) · Reservas por pedido
- **P:** Surtido y embarque · Recepción con inspección · Reabasto entre almacenes · Consignación · Análisis ABC y obsolescencia · Mermas con autorización
- **A:** Optimización de ubicaciones · RFID e IoT

### Logística y Distribución
- **E:** Envíos y guías · Integración con paqueterías · Rutas de reparto · Evidencias de entrega · Rastreo para el cliente · Carta Porte de traslados propios
- **P:** Optimización de rutas · Flota de reparto · Costo logístico por pedido · Logística inversa · Citas y ventanas de entrega
- **A:** Torre de control · Diseño de red de distribución · Multimodal

### Planeación de Demanda (S&OP)
- **E:** Pronóstico simple por histórico
- **P:** Plan de abastecimiento · Reunión S&OP · Stock de seguridad dinámico · Nivel de servicio (fill rate)
- **A:** Pronóstico con IA · Simulación de cadena · Riesgo en la cadena de suministro

El MRP de materiales vive en el satélite de Manufactura, no aquí.

## 2. Canales de Venta (31)

### Comercio Electrónico y Punto de Venta
- **E:** Tienda en línea · Pagos en línea (pasarela) · Pedidos web a pedido interno · Inventario sincronizado · Portal de autofactura · Punto de venta físico
- **P:** Marketplaces · Carrito abandonado · Cupones · Reseñas · Portal B2B de pedidos
- **A:** Omnicanalidad (compra en línea, recoge en tienda) · Personalización con IA

### Canales y Alianzas
- **E:** Registro de distribuidores · Listas de precios por canal · Pedidos de distribuidores
- **P:** Portal de socios · Comisiones y rebates · Registro de oportunidades de socios · Metas por socio · Capacitación de socios
- **A:** Franquicias (regalías, estándares, auditorías) · Sell-in / sell-out · Fondos de co-marketing

### Cuentas Clave
- **E:** Clasificación de cuentas
- **P:** Mapa de decisores · Revisión trimestral de negocio · Rentabilidad por cuenta · Contratos marco con clientes
- **A:** Equipos de cuenta · Cuentas globales

## 3. Operación Internacional (31)

### Comercio Exterior y Aduanas
- **E:** Pedimentos · Agentes aduanales · Costeo de importación (landed cost) · CFDI con complemento de comercio exterior · Fracción arancelaria · Incoterms
- **P:** Anexo 24 (IMMEX) · Certificación IVA/IEPS · Certificados de origen · Permisos y NOMs de importación · Seguimiento de embarques · Cartas de crédito
- **A:** Programas IMMEX/PROSEC completos · Auditoría de comercio exterior · Operador Económico Autorizado

### Tributación Internacional
- **E:** Retenciones a residentes en el extranjero · Residencia fiscal y tratados · Pagos al extranjero
- **P:** Operaciones con partes relacionadas · Documentación de precios de transferencia · Informativa de partes relacionadas
- **A:** Declaraciones maestra, local y país por país · Planeación fiscal internacional · Impuestos en otras jurisdicciones

### Movilidad Internacional
- **E:** Viajes internacionales y gastos multimoneda
- **P:** Expatriados · Visas y permisos de trabajo · Nómina dividida
- **A:** Políticas de movilidad · Igualación fiscal · Repatriación

## 4. Grupo Empresarial (38)

### Servicios Compartidos
- **E:** Multiempresa en una cuenta · Operaciones intercompañía espejo · Catálogos compartidos · Usuarios en varias empresas
- **P:** Empresa prestadora de servicios al grupo · Prorrateo de servicios compartidos · Conciliación intercompañía · Tableros consolidados · Préstamos intercompañía
- **A:** Acuerdos de nivel de servicio internos · Precios intercompañía ligados a precios de transferencia

### Direcciones Regionales
- **E:** Estructura por región · Resultados por región
- **P:** Metas y presupuestos regionales · Comparativo entre regiones · Políticas corporativas vs locales
- **A:** Operación multipaís · Estructura matricial

### Relación con Inversionistas
- **E:** Registro de inversionistas y participaciones · Reportes periódicos a socios
- **P:** Portal de inversionistas · Rondas y cap table · Dividendos · Reportes a acreedores y covenants
- **A:** Eventos relevantes y mercado de valores · Guía y consenso · Asamblea anual de accionistas

### Family Office
- **E:** Patrimonio familiar consolidado · Documentos patrimoniales
- **P:** Protocolo familiar · Consejo de familia · Inversiones y portafolio · Presupuesto familiar · Fideicomisos
- **A:** Plan de sucesión · Filantropía familiar · Formación de la siguiente generación · Reporte patrimonial multiactivo

---

**Total: 140 funciones en 4 paquetes.**

Lo único que estos paquetes exigen del núcleo desde ahora: que `empresa_id` y las políticas RLS existan en toda tabla de negocio desde la primera migración (paquete 4), y que el modelo de productos y servicios admita un futuro control de existencias sin rediseñarse (paquete 1).
