#!/usr/bin/env python3
"""
MagicBridge API Wrapper para LabVIEW
Proporciona interfaz simplificada para llamadas desde LabVIEW
"""
import sys
import json
import subprocess
import os
from pathlib import Path

class MagicBridgeAPI:
    """API wrapper para MagicBridge"""
    
    def __init__(self, scripts_dir=None):
        """Inicializar API
        
        Args:
            scripts_dir: Directorio donde están los scripts Python
        """
        if scripts_dir is None:
            # Asumir que está en la misma carpeta
            scripts_dir = Path(__file__).parent.parent / "bin"
        
        self.scripts_dir = Path(scripts_dir)
        self.script_load = self.scripts_dir / "1_cargar_datos_v3.cpython-312.pyc"
        self.script_cmd = self.scripts_dir / "2_ejecutar_comando_v3.cpython-312.pyc"
        
    def load_data(self, hmf_file, port, pcb, variant, timeout=300):
        """Cargar datos HMF al MagicBridge
        
        Args:
            hmf_file: Ruta al archivo HMF
            port: Puerto COM (ej: "COM3")
            pcb: Número de PCB (3, 5, 6)
            variant: Variante ("D" o "E")
            timeout: Timeout en segundos
            
        Returns:
            dict: {"success": bool, "message": str, "data": dict}
        """
        import tempfile
        json_file = tempfile.mktemp(suffix=".json")
        
        cmd = [
            sys.executable,
            str(self.script_load),
            str(hmf_file),
            port,
            str(pcb),
            variant.upper(),
            "--json", json_file,
            "--quiet"
        ]
        
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=timeout
            )
            
            # Leer resultado JSON
            if os.path.exists(json_file):
                with open(json_file, 'r') as f:
                    data = json.load(f)
                os.unlink(json_file)
            else:
                data = {}
            
            if result.returncode == 0:
                return {
                    "success": True,
                    "message": "Datos cargados exitosamente",
                    "data": data,
                    "exit_code": 0
                }
            else:
                return {
                    "success": False,
                    "message": f"Error al cargar datos: {result.stderr}",
                    "data": data,
                    "exit_code": result.returncode
                }
                
        except subprocess.TimeoutExpired:
            return {
                "success": False,
                "message": "Timeout al cargar datos",
                "data": {},
                "exit_code": -1
            }
        except Exception as e:
            return {
                "success": False,
                "message": f"Excepción: {str(e)}",
                "data": {},
                "exit_code": -2
            }
    
    def execute_command(self, port, command, timeout=60):
        """Ejecutar comando en MagicBridge
        
        Args:
            port: Puerto COM
            command: Comando (ej: "W5d", "R3e", "P6d")
            timeout: Timeout en segundos
            
        Returns:
            dict: {"success": bool, "message": str, "data": dict}
        """
        import tempfile
        json_file = tempfile.mktemp(suffix=".json")
        
        cmd = [
            sys.executable,
            str(self.script_cmd),
            port,
            command,
            "--json", json_file,
            "--quiet"
        ]
        
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=timeout
            )
            
            # Leer resultado JSON
            if os.path.exists(json_file):
                with open(json_file, 'r') as f:
                    data = json.load(f)
                os.unlink(json_file)
            else:
                data = {}
            
            if result.returncode == 0:
                return {
                    "success": True,
                    "message": f"Comando {command} ejecutado exitosamente",
                    "data": data,
                    "exit_code": 0
                }
            else:
                return {
                    "success": False,
                    "message": f"Error al ejecutar comando: {result.stderr}",
                    "data": data,
                    "exit_code": result.returncode
                }
                
        except subprocess.TimeoutExpired:
            return {
                "success": False,
                "message": "Timeout al ejecutar comando",
                "data": {},
                "exit_code": -1
            }
        except Exception as e:
            return {
                "success": False,
                "message": f"Excepción: {str(e)}",
                "data": {},
                "exit_code": -2
            }

# CLI para uso desde LabVIEW System Exec
def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="MagicBridge API CLI")
    subparsers = parser.add_subparsers(dest='command', help='Comando a ejecutar')
    
    # Comando: load
    load_parser = subparsers.add_parser('load', help='Cargar datos HMF')
    load_parser.add_argument('hmf_file', help='Archivo HMF')
    load_parser.add_argument('port', help='Puerto COM')
    load_parser.add_argument('pcb', type=int, choices=[3,5,6], help='Número de PCB')
    load_parser.add_argument('variant', choices=['D','E','d','e'], help='Variante')
    
    # Comando: exec
    exec_parser = subparsers.add_parser('exec', help='Ejecutar comando')
    exec_parser.add_argument('port', help='Puerto COM')
    exec_parser.add_argument('cmd', help='Comando (ej: W5d, R3e)')
    
    # Comando: detect
    subparsers.add_parser('detect', help='Detectar puerto COM')
    
    args = parser.parse_args()
    
    api = MagicBridgeAPI()
    
    if args.command == 'load':
        result = api.load_data(args.hmf_file, args.port, args.pcb, args.variant)
        print(json.dumps(result, indent=2))
        sys.exit(0 if result['success'] else 1)
        
    elif args.command == 'exec':
        result = api.execute_command(args.port, args.cmd)
        print(json.dumps(result, indent=2))
        sys.exit(0 if result['success'] else 1)
        
    elif args.command == 'detect':
        import serial.tools.list_ports
        for port in serial.tools.list_ports.comports():
            if ("1d50:6015" in port.hwid.lower() or 
                "elmos" in port.description.lower()):
                print(json.dumps({"success": True, "port": port.device}))
                sys.exit(0)
        print(json.dumps({"success": False, "port": ""}))
        sys.exit(1)
    else:
        parser.print_help()
        sys.exit(1)

if __name__ == "__main__":
    main()
