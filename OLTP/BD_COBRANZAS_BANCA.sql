CREATE DATABASE bd_cobranzas_banca

use bd_cobranzas_banca

GO

CREATE TABLE personas_naturales(
id INT IDENTITY(1,1) PRIMARY KEY,
dni CHAR(8) NOT NULL UNIQUE,
nombres varchar(50) NOT NULL,
apellidos varchar(50) NOT NULL,
direccion varchar(200) NOT NULL,
celular varchar(30) NOT NULL,
email varchar(50) NOT NULL,
fecha_nacimiento DATE NOT NULL,
genero VARCHAR(30),
estado_civil VARCHAR(30),
profesion VARCHAR(50)
)
GO

CREATE TABLE personas_juridicas(
id INT IDENTITY(1,1) PRIMARY KEY,
ruc CHAR(11) NOT NULL UNIQUE,
razon_social VARCHAR(100) NOT NULL,
direccion VARCHAR(200) NOT NULL,
email VARCHAR(200) NOT NULL,
telefono VARCHAR(30) NOT NULL,
tipo_empresa VARCHAR(50) NOT NULL,
rubro VARCHAR(50) NOT NULL,
fecha_creacion DATE NOT NULL
)
GO

CREATE TABLE clientes(
id INT IDENTITY(1,1) PRIMARY KEY,
id_personas INT NOT NULL,
tipo_cliente varchar(30) NOT NULL,
FOREIGN KEY(id_personas) REFERENCES personas_naturales(id),
FOREIGN KEY(id_personas) REFERENCES personas_juridicas(id)
)
GO

CREATE TABLE canal_contacto(
id INT IDENTITY(1,1) PRIMARY KEY,
nombre_canal VARCHAR(50) NOT NULL
)
GO

CREATE TABLE gestor(
id INT IDENTITY(1,1) PRIMARY KEY,
nombres VARCHAR(50) NOT NULL,
apellidos VARCHAR(50) NOT NULL,
cargo VARCHAR(50) NOT NULL,
departamento_cobranza VARCHAR(50) NOT NULL
)
GO

CREATE TABLE estado_mora(
id INT IDENTITY(1,1) PRIMARY KEY,
dias_mora INT NOT NULL,
clasificacion VARCHAR(100) NOT NULL,
historial VARCHAR(100) not null
)
GO

CREATE TABLE creditos(
id INT IDENTITY(1,1) PRIMARY KEY,
id_estado_mora INT NOT NULL,
id_clientes INT NOT NULL,
monto NUMERIC(18,2) NOT NULL,
moneda VARCHAR(30) NOT NULL,
cuotas_programadas INT NOT NULL,
cuotas_pagadas INT NOT NULL,
cuotas_pendientes INT NOT NULL,
monto_atrasado NUMERIC(18,2) NOT NULL,
capital_pendiente NUMERIC(18,2) NOT NULL,
FOREIGN KEY(id_estado_mora) REFERENCES estado_mora(id),
FOREIGN KEY(id_clientes) REFERENCES clientes(id)
)
GO

CREATE TABLE gestion(
id INT IDENTITY(1,1) PRIMARY KEY,
id_canal INT NOT NULL,
id_gestor INT NOT NULL,
id_credito INT NOT NULL,
detalle_gestion VARCHAR(500) NOT NULL,
resultado_gestion VARCHAR(50) NOT NULL,
FOREIGN KEY(id_canal) REFERENCES canal_contacto(id),
FOREIGN KEY(id_gestor) REFERENCES gestor(id),
FOREIGN KEY(id_credito) REFERENCES creditos(id)
)
GO

CREATE TABLE CONVENIO_PAGO(
id INT IDENTITY(1,1) PRIMARY KEY,
id_credito INT NOT NULL,
monto NUMERIC(18,2) NOT NULL,
fecha_registro DATETIME NOT NULL,
fecha_promesa_pago DATE NOT NULL,
fecha_vencimiento_promesa DATE NOT NULL,
FOREIGN KEY (id_credito) REFERENCES creditos(id)
)
GO

CREATE TABLE PAGOS(
id INT IDENTITY(1,1) PRIMARY KEY,
id_credito INT NOT NULL,
fecha_pago DATETIME NOT NULL,
monto NUMERIC(18,2) NOT NULL,
medio_pago VARCHAR(30),
FOREIGN KEY(id_credito) REFERENCES creditos(id)
)