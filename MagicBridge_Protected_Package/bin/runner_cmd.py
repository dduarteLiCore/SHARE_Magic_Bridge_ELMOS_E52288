"""
MagicBridge runner - ejecutar comando
Pre-carga hmf_loader explicitamente antes de ejecutar el script principal.
"""
import sys
import os
import importlib.util

bin_dir = os.path.dirname(os.path.abspath(__file__))

# Pre-cargar hmf_loader en sys.modules (por si el comando lo necesita)
_hmf_pyc = os.path.join(bin_dir, "hmf_loader.cpython-311.pyc")
if os.path.exists(_hmf_pyc):
    _spec = importlib.util.spec_from_file_location("hmf_loader", _hmf_pyc)
    _mod = importlib.util.module_from_spec(_spec)
    sys.modules["hmf_loader"] = _mod
    _spec.loader.exec_module(_mod)

# Ejecutar el script principal como __main__
_main_pyc = os.path.join(bin_dir, "2_ejecutar_comando_v3.cpython-311.pyc")
_spec = importlib.util.spec_from_file_location("__main__", _main_pyc)
_main_mod = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_main_mod)
