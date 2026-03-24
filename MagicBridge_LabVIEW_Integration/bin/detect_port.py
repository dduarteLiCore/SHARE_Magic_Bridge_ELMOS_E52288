#!/usr/bin/env python3
"""
Helper Script: Detectar puerto COM del MagicBridge
Uso desde LabVIEW con System Exec.vi
"""
import sys
import serial.tools.list_ports

def detect_magicbridge():
    """Detecta el puerto COM del MagicBridge"""
    for port in serial.tools.list_ports.comports():
        # Buscar por VID:PID o descripción
        if ("1d50:6015" in port.hwid.lower() or 
            "elmos" in port.description.lower() or 
            "licore" in port.description.lower()):
            return port.device
    return ""

if __name__ == "__main__":
    port = detect_magicbridge()
    if port:
        print(port)  # Solo imprime el puerto, ej: "COM3"
        sys.exit(0)
    else:
        print("NOT_FOUND")
        sys.exit(1)
