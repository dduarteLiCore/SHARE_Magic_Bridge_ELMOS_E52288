# Magic Bridge - Paquete de Distribución

Bienvenido al repositorio de distribución de **Magic Bridge**, una herramienta de programación e integración para el chip **ELMOS E522.88**. 

Este repositorio contiene las herramientas, ejecutables y código de integración necesarios para desplegar y utilizar el Magic Bridge en entornos de producción, especialmente enfocado en su integración con sistemas de prueba automatizados.

## 📦 Estructura del Repositorio

El repositorio se divide en dos componentes principales:

### 1. `MagicBridge_Protected_Package/`
Contiene los archivos ejecutables, binarios y dependencias base compiladas que hacen funcionar el sistema Magic Bridge. Este paquete está optimizado para su despliegue en entornos de producción sin exponer el código fuente original, garantizando la integridad de los scripts de programación.

### 2. `MagicBridge_LabVIEW_Integration/`
Proporciona todos los recursos necesarios para integrar el Magic Bridge con **LabVIEW** en Windows. Incluye:
- Wrappers de Python.
- Plantillas de VIs.
- Documentación detallada de integración (`docs/`).
- Ejemplos paso a paso (`examples/`).

## 🚀 Inicio Rápido

Para comenzar a utilizar las herramientas incluidas en este paquete, por favor dirígete al README de la integración que vayas a utilizar. Si buscas integrar el programador en una estación de pruebas LabVIEW, consulta las instrucciones en:

👉 **[Guía de Integración con LabVIEW](MagicBridge_LabVIEW_Integration/README.md)**

## 📋 Requisitos Generales

Para ejecutar las herramientas contenidas en este repositorio, el sistema host generalmente requerirá:
- **Windows** (recomendado para integración con LabVIEW)
- **Python 3.9+** (con la librería `pyserial`).
- **LabVIEW** (versiones 2018 o superiores para algunas opciones de integración, aunque el paquete soporta adaptaciones genéricas a través de *System Exec*).

## 📞 Soporte
Ante cualquier duda o problema durante la instalación y despliegue del Magic Bridge en su línea de producción, consulte la documentación contenida en las carpetas respectivas.

---
© 2026 LiCore.
