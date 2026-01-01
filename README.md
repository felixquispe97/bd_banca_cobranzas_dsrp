# bd_banca_cobranzas_dsrp
📌 Contexto general del problema
Una entidad bancaria necesita gestionar y analizar la recuperación de deudas de sus clientes morosos, con el fin de:
Registrar operaciones diarias de cobranza.

Controlar promesas de pago, cuotas y estados de deuda.

Evaluar la efectividad de los gestores de cobranza.

Analizar indicadores históricos para la toma de decisiones.

🧩 PARTE I: PLANTEAMIENTO DEL PROBLEMA (OLTP – Transaccional)
🔹 Enunciado del problema
El banco actualmente registra información de clientes con deudas vencidas, pagos realizados y gestiones de cobranza de forma desorganizada, lo que genera:
Duplicidad de información.

Dificultad para conocer el estado real de la deuda.

Falta de control sobre las gestiones realizadas por los asesores.

Imposibilidad de medir la eficiencia en la recuperación.

Se requiere diseñar una base de datos transaccional que permita registrar de manera eficiente y segura todas las operaciones relacionadas con la recuperación de deuda.

🔹 Entidades principales (OLTP)
Como alumno, podrías plantear entidades como:
Cliente

Crédito

Deuda

Pago

Gestión de cobranza

Gestor de cobranza

Promesa de pago

Estado de deuda


👉 Aquí se prioriza:
Alta frecuencia de inserciones y actualizaciones.

Datos normalizados.

Integridad referencial.


🔹 Ejemplo de preguntas operativas (OLTP)
¿Qué clientes tienen deudas vencidas hoy?

¿Qué pagos se realizaron en una fecha específica?

¿Qué gestor realizó una gestión a un cliente?

¿Cuál es el saldo actual de una deuda?


📊 PARTE II: PLANTEAMIENTO DEL PROBLEMA (BI – Dimensional)
🔹 Necesidad de análisis
La gerencia necesita analizar el comportamiento histórico de la recuperación de deuda para:
Medir tasas de recuperación.

Identificar clientes de alto riesgo.

Evaluar desempeño por gestor, zona y producto.

Comparar periodos (mes, trimestre, año).


🔹 Enunciado del problema BI
Se requiere diseñar un modelo dimensional que consolide la información histórica de recuperación de deuda, permitiendo el análisis mediante indicadores clave para la toma de decisiones estratégicas.

🔹 Grano del modelo
Una gestión de cobranza realizada a un cliente en una fecha determinada por un gestor para un crédito específico.

🔹 Tabla de hechos (ejemplo)
Hecho_Recuperacion_Deuda
Monto_deuda

Monto_pagado

Saldo_recuperado

Días_mora

Cantidad_gestiones


🔹 Dimensiones
Dim_Cliente

Dim_Tiempo

Dim_Gestor

Dim_Producto_Crediticio

Dim_Estado_Deuda

Dim_Canal_Cobranza (llamada, visita, email, etc.)


🔹 Ejemplos de indicadores (KPI)
% de recuperación mensual.

Monto recuperado por gestor.

Días promedio de mora por producto.

Efectividad de cobranza por canal.


