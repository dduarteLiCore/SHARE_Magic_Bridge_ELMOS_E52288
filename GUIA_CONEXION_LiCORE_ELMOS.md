# Guía de Conexión: Adaptación de Placa LiCORE para Controlador Magic Bridge

Esta guía documenta la asignación de pines y consideraciones eléctricas al adaptar una placa "LiCORE - Digital Output Protection" para comunicarse con un chip controlador ELMOS (como el E522.88) a través de un bus I2C / Serial.

## 1. Verificación del Pinout Físico

De acuerdo al análisis visual de la placa provista:

![](/home/david/Documents/SHARE_Magic_Bridge_ELMOS_E52288/MagicBridge_Protected_Package/docs/Conector.png)

- **Lado Derecho (TB1 - Bloque de terminales verde)**: Cuenta con 5 borneras etiquetadas de arriba a abajo como `VOUT`, `PGND`, `CAN-H`, `CAN-L` y `WRITE`.
- **Lado Izquierdo (Pads de soldadura)**: 5 orificios numerados del 1 al 5.
- **Componentes Visibles**: Diodos TVS (`TVSD1`), LED indicador (`LD1`) y un banco de resistencias de montaje superficial para atenuación de transitorios (las que tienen serigrafía "330" son resistencias de 33Ω puestas en serie a las líneas de datos).

## 2.  Instrucciones de Cableado (Mapeo)

La adaptación reemplaza un bus diferencial (CAN) por señales de datos (SDA/SCL/PROG). El circuito pasivo de la placa LiCORE es **eléctricamente compatible** con líneas de baja velocidad/voltaje como I2C las resistencias limitadoras de corriente y el TVS proporcionan una excelente protección ESD para el microcontrolador.

| Terminal Placa LiCORE | Tu Adaptación | Función para ELMOS |
| :--- | :--- | :--- |
| **VOUT** | **VCC** | Alimentación lógica (usualmente 3.3V o 5V) |
| **PGND** | **GND** | Tierra común de referencia |
| **CAN-H** | **SDA** | Señal de datos (Serial Data) |
| **CAN-L** | **SCL** | Señal de reloj (Serial Clock) |
| **WRITE** | **PROG** | Señal de programación o direccionamiento |

---

