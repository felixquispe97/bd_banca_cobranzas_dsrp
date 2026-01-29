CREATE DATABASE bd_cobranzas_bi;
GO
USE bd_cobranzas_bi;
GO

use bd_cobranzas_bi

CREATE TABLE dim_tiempo (
    id_tiempo INT IDENTITY(1,1 ) NOT NULL PRIMARY KEY,
    fecha DATE,
    anio INT,
    mes INT,
    nombre_mes VARCHAR(20),
    dia INT,
    trimestre INT,
    dia_semana VARCHAR(20)
);


CREATE TABLE dim_cliente (
    id_cliente INT IDENTITY(1,1 ) NOT NULL PRIMARY KEY,
    tipo_cliente CHAR(1),
    dni CHAR(8),
    ruc CHAR(11),
    nombres VARCHAR(100),
    razon_social VARCHAR(100),
    rubro VARCHAR(50),
    genero VARCHAR(20),
    estado_civil VARCHAR(30)
);


CREATE TABLE dim_credito (
    id_credito INT IDENTITY(1,1 ) NOT NULL PRIMARY KEY,
    moneda VARCHAR(20),
    monto_original NUMERIC(18,2),
    cuotas_programadas INT
);



CREATE TABLE dim_gestor (
    id_gestor INT IDENTITY(1,1 ) NOT NULL PRIMARY KEY,
    nombres VARCHAR(50),
    apellidos VARCHAR(50),
    cargo VARCHAR(50),
    departamento VARCHAR(50)
);


CREATE TABLE dim_canal (
    id_canal INT IDENTITY(1,1 ) NOT NULL PRIMARY KEY,
    nombre_canal VARCHAR(50)
);


CREATE TABLE dim_estado_mora (
    id_estado_mora INT IDENTITY(1,1 ) NOT NULL PRIMARY KEY,
    dias_mora INT,
    clasificacion VARCHAR(100)
);


CREATE TABLE fact_gestion_cobranza (
    id_fact INT IDENTITY(1,1) PRIMARY KEY,

    id_tiempo INT,
    id_cliente INT,
    id_credito INT,
    id_gestor INT,
    id_canal INT,
    id_estado_mora INT,

    cantidad_gestion INT,
    monto_atrasado NUMERIC(18,2),
    capital_pendiente NUMERIC(18,2),
    monto_pagado NUMERIC(18,2),

    FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo),
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    FOREIGN KEY (id_credito) REFERENCES dim_credito(id_credito),
    FOREIGN KEY (id_gestor) REFERENCES dim_gestor(id_gestor),
    FOREIGN KEY (id_canal) REFERENCES dim_canal(id_canal),
    FOREIGN KEY (id_estado_mora) REFERENCES dim_estado_mora(id_estado_mora)
);

