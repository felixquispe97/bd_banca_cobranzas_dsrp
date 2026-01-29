USE bd_cobranzas_bi;
USE bd_cobranzas_banca;

INSERT INTO bd_cobranzas_bi.dbo.dim_tiempo
(fecha, anio, mes, nombre_mes, dia, trimestre, dia_semana)
SELECT DISTINCT
    CONVERT(DATE, fecha_evento) AS fecha,
    YEAR(fecha_evento) AS anio,
    MONTH(fecha_evento) AS mes,
    DATENAME(MONTH, fecha_evento) AS nombre_mes,
    DAY(fecha_evento) AS dia,
    DATEPART(QUARTER, fecha_evento) AS trimestre,
    DATENAME(WEEKDAY, fecha_evento) AS dia_semana
FROM (
    SELECT fecha_pago AS fecha_evento
    FROM bd_cobranzas_banca.dbo.pagos
    UNION
    SELECT fecha_registro
    FROM bd_cobranzas_banca.dbo.convenio_pago
) t
WHERE fecha_evento IS NOT NULL;

----

INSERT INTO bd_cobranzas_bi.dbo.dim_cliente
(tipo_cliente, dni, ruc, nombres, razon_social, rubro, genero, estado_civil)
SELECT DISTINCT
    c.tipo_cliente,
    pn.dni,
    NULL AS ruc,
    CONCAT(pn.nombres, ' ', pn.apellidos),
    NULL AS razon_social,
    NULL AS rubro,
    pn.genero,
    pn.estado_civil
FROM bd_cobranzas_banca.dbo.clientes c
JOIN bd_cobranzas_banca.dbo.personas_naturales pn
    ON c.id_cliente = pn.id_cliente
WHERE c.tipo_cliente = 'N'

UNION ALL

SELECT DISTINCT
    c.tipo_cliente,
    NULL AS dni,
    pj.ruc,
    NULL AS nombres,
    pj.razon_social,
    pj.rubro,
    NULL AS genero,
    NULL AS estado_civil
FROM bd_cobranzas_banca.dbo.clientes c
JOIN bd_cobranzas_banca.dbo.personas_juridicas pj
    ON c.id_cliente = pj.id_cliente
WHERE c.tipo_cliente = 'J';



-----------

INSERT INTO bd_cobranzas_bi.dbo.dim_credito
(moneda, monto_original, cuotas_programadas)
SELECT DISTINCT
    moneda,
    monto,
    cuotas_programadas
FROM bd_cobranzas_banca.dbo.creditos;





------


INSERT INTO bd_cobranzas_bi.dbo.dim_gestor
(nombres, apellidos, cargo, departamento)
SELECT DISTINCT
    nombres,
    apellidos,
    cargo,
    departamento_cobranza
FROM bd_cobranzas_banca.dbo.gestor;




-----




INSERT INTO bd_cobranzas_bi.dbo.dim_canal
(nombre_canal)
SELECT DISTINCT
    nombre_canal
FROM bd_cobranzas_banca.dbo.canal_contacto;




----------------------



INSERT INTO bd_cobranzas_bi.dbo.dim_estado_mora
(dias_mora, clasificacion)
SELECT DISTINCT
    dias_mora,
    clasificacion
FROM bd_cobranzas_banca.dbo.estado_mora;




---------------------------

INSERT INTO fact_gestion_cobranza
(
    id_tiempo,
    id_cliente,
    id_credito,
    id_gestor,
    id_canal,
    id_estado_mora,
    cantidad_gestion,
    monto_atrasado,
    capital_pendiente,
    monto_pagado
)
SELECT
    dt.id_tiempo,
    dc.id_cliente,
    dcr.id_credito,
    dg.id_gestor,
    dca.id_canal,
    dem.id_estado_mora,

    1 AS cantidad_gestion,

    cr.monto_atrasado,
    cr.capital_pendiente,
    ISNULL(p.monto, 0) AS monto_pagado

FROM bd_cobranzas_banca.dbo.gestion g

JOIN bd_cobranzas_banca.dbo.creditos cr
    ON g.id_credito = cr.id_credito

JOIN bd_cobranzas_banca.dbo.clientes c
    ON cr.id_cliente = c.id_cliente

JOIN dim_cliente dc
    ON dc.id_cliente = c.id_cliente

JOIN dim_credito dcr
    ON dcr.id_credito = cr.id_credito

JOIN dim_gestor dg
    ON dg.id_gestor = g.id_gestor

JOIN dim_canal dca
    ON dca.id_canal = g.id_canal

JOIN bd_cobranzas_banca.dbo.estado_mora em
    ON cr.id_estado_mora = em.id_estado_mora

JOIN dim_estado_mora dem
    ON dem.dias_mora = em.dias_mora

JOIN dim_tiempo dt
    ON dt.fecha = CONVERT(DATE, GETDATE())

LEFT JOIN bd_cobranzas_banca.dbo.pagos p
    ON p.id_credito = cr.id_credito;



------------------


USE bd_cobranzas_bi;

DELETE FROM dim_canal
    DBCC CHECKIDENT('dim_canal', RESEED,0);
DELETE FROM dim_cliente
    DBCC CHECKIDENT('dim_cliente', RESEED,0);
DELETE FROM dim_credito
    DBCC CHECKIDENT('dim_credito', RESEED,0);
DELETE FROM dim_estado_mora
    DBCC CHECKIDENT('dim_estado_mora', RESEED,0);
DELETE FROM dim_gestor
    DBCC CHECKIDENT('dim_gestor', RESEED,0);
DELETE FROM dim_tiempo
    DBCC CHECKIDENT('dim_tiempo', RESEED,0);
DELETE FROM fact_gestion_cobranza
    DBCC CHECKIDENT('fact_gestion_cobranza', RESEED,0);

ALTER TABLE dim_cliente
ALTER COLUMN nombres VARCHAR(150);

ALTER TABLE dim_cliente
ALTER COLUMN genero VARCHAR(30);

SELECT * FROM dim_tiempo


SELECT
    dt.id_tiempo,
    dc.id_cliente,
    dcr.id_credito,
    dg.id_gestor,
    dca.id_canal,
    dem.id_estado_mora,

    1 AS cantidad_gestion,
    cr.monto_atrasado,
    cr.capital_pendiente,
    ISNULL(p.monto, 0) AS monto_pagado

FROM bd_cobranzas_banca.dbo.gestion g

JOIN bd_cobranzas_banca.dbo.creditos cr
    ON g.id_credito = cr.id_credito

JOIN bd_cobranzas_banca.dbo.clientes c
    ON cr.id_cliente = c.id_cliente

JOIN bd_cobranzas_bi.dbo.dim_cliente dc
    ON dc.id_cliente = c.id_cliente

JOIN bd_cobranzas_bi.dbo.dim_credito dcr
    ON dcr.id_credito = cr.id_credito

JOIN bd_cobranzas_bi.dbo.dim_gestor dg
    ON dg.id_gestor = g.id_gestor

JOIN bd_cobranzas_bi.dbo.dim_canal dca
    ON dca.id_canal = g.id_canal

JOIN bd_cobranzas_banca.dbo.estado_mora em
    ON cr.id_estado_mora = em.id_estado_mora

JOIN bd_cobranzas_bi.dbo.dim_estado_mora dem
    ON dem.dias_mora = em.dias_mora

JOIN bd_cobranzas_bi.dbo.dim_tiempo dt
    ON dt.fecha = CONVERT(DATE, GETDATE())

LEFT JOIN bd_cobranzas_banca.dbo.pagos p
    ON p.id_credito = cr.id_credito;
