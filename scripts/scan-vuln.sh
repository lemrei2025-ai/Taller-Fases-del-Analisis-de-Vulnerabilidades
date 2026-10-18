#!/usr/bin/env bash
#
# scan-vuln.sh - Deteccion de vulnerabilidades conocidas (Fase 4)
# Taller de Analisis de Vulnerabilidades - USO EXCLUSIVO EN LABORATORIO AISLADO
#
# Uso:   sudo ./scan-vuln.sh <IP_OBJETIVO>
# Ej.:   sudo ./scan-vuln.sh 192.168.56.20
#
set -euo pipefail

TARGET="${1:-}"
OUTDIR="../evidencias"

if [[ -z "$TARGET" ]]; then
  echo "Uso: sudo $0 <IP_OBJETIVO>"
  exit 1
fi

echo "[!] RECUERDA: solo contra tu VM de laboratorio aislada."
echo "[*] Objetivo: $TARGET"
mkdir -p "$OUTDIR"

echo "[*] (1/2) Ejecutando scripts de deteccion de vulnerabilidades de Nmap..."
nmap -p 139,445 --script "vuln" "$TARGET" -oN "$OUTDIR/04-nmap-vuln.txt"

echo "[*] (2/2) Buscando exploits publicos asociados (searchsploit)..."
if command -v searchsploit >/dev/null; then
  {
    echo "=== windows xp smb remote ==="
    searchsploit windows xp smb remote || true
    echo; echo "=== ms08-067 ==="
    searchsploit ms08-067 || true
  } | tee "$OUTDIR/04-searchsploit.txt"
else
  echo "   searchsploit no instalado (apt install exploitdb), omitido."
fi

echo "[+] Deteccion finalizada. Revisa $OUTDIR/04-nmap-vuln.txt y mapea a CVE/CVSS."
echo "[i] Calculadora CVSS v3.1: https://www.first.org/cvss/calculator/3.1"
