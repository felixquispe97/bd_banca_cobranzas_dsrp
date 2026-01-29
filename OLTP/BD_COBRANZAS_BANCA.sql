CREATE DATABASE bd_cobranzas_banca;
GO

USE bd_cobranzas_banca;
GO

CREATE TABLE clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    tipo_cliente CHAR(1) NOT NULL
        CHECK (tipo_cliente IN ('N','J'))
);
GO

CREATE TABLE personas_naturales (
    id_cliente INT PRIMARY KEY,
    dni CHAR(8) NOT NULL UNIQUE,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    direccion VARCHAR(200),
    celular VARCHAR(30),
    email VARCHAR(50),
    fecha_nacimiento DATE,
    genero VARCHAR(30),
    estado_civil VARCHAR(30),
    profesion VARCHAR(50),
    CONSTRAINT fk_pn_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
GO


CREATE TABLE personas_juridicas (
    id_cliente INT PRIMARY KEY,
    ruc CHAR(11) NOT NULL UNIQUE,
    razon_social VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    email VARCHAR(100),
    telefono VARCHAR(30),
    tipo_empresa VARCHAR(50),
    rubro VARCHAR(50),
    fecha_creacion DATE,
    CONSTRAINT fk_pj_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
GO


CREATE TABLE canal_contacto (
    id_canal INT IDENTITY PRIMARY KEY,
    nombre_canal VARCHAR(50) NOT NULL
);
GO

CREATE TABLE gestor (
    id_gestor INT IDENTITY PRIMARY KEY,
    nombres VARCHAR(50),
    apellidos VARCHAR(50),
    cargo VARCHAR(50),
    departamento_cobranza VARCHAR(50)
);
GO


CREATE TABLE estado_mora (
    id_estado_mora INT IDENTITY PRIMARY KEY,
    dias_mora INT NOT NULL,
    clasificacion VARCHAR(100)
);
GO


CREATE TABLE creditos (
    id_credito INT IDENTITY PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_estado_mora INT NOT NULL,
    monto NUMERIC(18,2),
    moneda VARCHAR(20),
    cuotas_programadas INT,
    cuotas_pagadas INT,
    cuotas_pendientes INT,
    monto_atrasado NUMERIC(18,2),
    capital_pendiente NUMERIC(18,2),
    CONSTRAINT fk_credito_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_credito_mora
        FOREIGN KEY (id_estado_mora) REFERENCES estado_mora(id_estado_mora)
);
GO


CREATE TABLE gestion (
    id_gestion INT IDENTITY PRIMARY KEY,
    id_credito INT NOT NULL,
    id_gestor INT NOT NULL,
    id_canal INT NOT NULL,
    detalle_gestion VARCHAR(500),
    resultado_gestion VARCHAR(50),
    CONSTRAINT fk_gestion_credito
        FOREIGN KEY (id_credito) REFERENCES creditos(id_credito),
    CONSTRAINT fk_gestion_gestor
        FOREIGN KEY (id_gestor) REFERENCES gestor(id_gestor),
    CONSTRAINT fk_gestion_canal
        FOREIGN KEY (id_canal) REFERENCES canal_contacto(id_canal)
);
GO


CREATE TABLE pagos (
    id_pago INT IDENTITY PRIMARY KEY,
    id_credito INT NOT NULL,
    fecha_pago DATETIME,
    monto NUMERIC(18,2),
    medio_pago VARCHAR(30),
    CONSTRAINT fk_pago_credito
        FOREIGN KEY (id_credito) REFERENCES creditos(id_credito)
);
GO


CREATE TABLE convenio_pago (
    id_convenio INT IDENTITY PRIMARY KEY,
    id_credito INT NOT NULL,
    monto NUMERIC(18,2),
    fecha_registro DATETIME,
    fecha_promesa_pago DATE,
    fecha_vencimiento DATE,
    CONSTRAINT fk_convenio_credito
        FOREIGN KEY (id_credito) REFERENCES creditos(id_credito)
);
GO






-----INSERTAR DATOS



INSERT INTO canal_contacto (nombre_canal) VALUES
('Llamada telefónica'),
('WhatsApp'),
('Correo electrónico'),
('Visita domiciliaria'),
('SMS');


INSERT INTO gestor (nombres, apellidos, cargo, departamento_cobranza) VALUES
('Ana','Ramos','Gestor Senior','Cobranzas'),
('Luis','Pérez','Gestor Junior','Cobranzas'),
('María','Torres','Supervisor','Cobranzas'),
('Carlos','Gómez','Gestor Senior','Cobranzas'),
('Lucía','Fernández','Gestor Junior','Cobranzas');


INSERT INTO estado_mora (dias_mora, clasificacion) VALUES
(0,'Vigente'),
(15,'Mora temprana'),
(30,'Mora media'),
(60,'Mora alta'),
(90,'Mora crítica');


INSERT INTO clientes (tipo_cliente) VALUES
('N'),('N'),('N'),('J'),('J');

INSERT INTO personas_naturales
(id_cliente, dni, nombres, apellidos, direccion, celular, email, fecha_nacimiento, genero, estado_civil, profesion)
VALUES
(1,'72345678','Juan','Paredes','Av Lima 123','987654321','juan@gmail.com','1990-05-12','M','Soltero','Ingeniero'),
(2,'73456789','Pedro','Ríos','Av Grau 456','987654322','pedro@gmail.com','1988-08-22','M','Casado','Contador'),
(3,'74567890','María','Salas','Jr Perú 789','987654323','maria@gmail.com','1995-02-10','F','Soltera','Abogada');


INSERT INTO personas_juridicas
(id_cliente, ruc, razon_social, direccion, email, telefono, tipo_empresa, rubro, fecha_creacion)
VALUES
(4,'20123456789','Inversiones Andinas SAC','Av Industrial 100','contacto@andinas.com','014445555','SAC','Construcción','2015-03-01'),
(5,'20456789123','Servicios Globales SRL','Av Comercio 200','info@globales.com','014446666','SRL','Servicios','2018-07-15');



---TABLAS TRANSACCIONALES

INSERT INTO creditos
(id_cliente, id_estado_mora, monto, moneda, cuotas_programadas, cuotas_pagadas, cuotas_pendientes, monto_atrasado, capital_pendiente)
VALUES
(1,2,10000,'PEN',12,8,4,1500,3500),
(2,3,8000,'PEN',10,5,5,2000,4000),
(3,1,5000,'PEN',8,8,0,0,0),
(4,4,25000,'USD',24,10,14,6000,14000),
(5,5,30000,'USD',36,12,24,12000,18000);


INSERT INTO gestion
(id_credito, id_gestor, id_canal, detalle_gestion, resultado_gestion)
VALUES
(1,1,1,'Llamada recordatoria','Contacto efectivo'),
(1,2,2,'Mensaje WhatsApp','Promesa de pago'),
(1,3,3,'Correo enviado','Sin respuesta'),
(2,1,1,'Llamada seguimiento','No contesta'),
(2,2,2,'WhatsApp seguimiento','Contacto efectivo'),
(2,3,3,'Correo cobranza','Promesa de pago'),
(3,4,1,'Llamada','Pago confirmado'),
(3,5,2,'WhatsApp','Pago realizado'),
(4,1,4,'Visita domiciliaria','Cliente ausente'),
(4,2,1,'Llamada','Contacto efectivo'),
(4,3,2,'WhatsApp','Promesa de pago'),
(4,4,3,'Correo','Sin respuesta'),
(5,1,1,'Llamada','No contesta'),
(5,2,2,'WhatsApp','Contacto efectivo'),
(5,3,3,'Correo','Promesa de pago'),
(5,4,4,'Visita','Pago parcial'),
(1,5,1,'Llamada','Pago parcial'),
(2,4,2,'WhatsApp','Sin respuesta'),
(3,2,1,'Llamada','Pago total'),
(4,5,3,'Correo','Seguimiento pendiente');



INSERT INTO pagos (id_credito, fecha_pago, monto, medio_pago) VALUES
(1,GETDATE(),500,'Transferencia'),
(2,GETDATE(),800,'Depósito'),
(3,GETDATE(),1000,'Transferencia'),
(4,GETDATE(),1200,'Transferencia'),
(5,GETDATE(),1500,'Depósito');



INSERT INTO convenio_pago
(id_credito, monto, fecha_registro, fecha_promesa_pago, fecha_vencimiento)
VALUES
(1,1500,GETDATE(),'2026-02-10','2026-02-15'),
(2,2000,GETDATE(),'2026-02-12','2026-02-18'),
(4,6000,GETDATE(),'2026-02-20','2026-02-28');



