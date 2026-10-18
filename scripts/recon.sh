#!/usr/bin/env bash
#
# recon.sh - Descubrimiento y reconocimiento del objetivo (Fases 2-3)
# Taller de Analisis de Vulnerabilidades - USO EXCLUSIVO EN LABORATORIO AISLADO
#
# Uso:   sudo ./recon.sh <IP_OBJETIVO>
# Ej.:   sudo ./recon.sh 192.168.56.20
#
set -euo pipefail

TARGET="${1:-}"
OUTDIR="../evidencias"

if [[ -z "$TARGET" ]]; then
  echo "Uso: sudo $0 <IP_OBJETIVO>"
  exit 1
fi

echo "[!] RECUERDA: solo contra tu VM de laboratorio aislada. No sistemas de terceros."
echo "[*] Objetivo: $TARGET"
mkdir -p "$OUTDIR"

echo "[*] (1/4) Comprobando que el host esta vivo..."
nmap -sn "$TARGET" | tee "$OUTDIR/02-host-vivo.txt"

echo "[*] (2/4) Escaneo completo de puertos + versiones + SO..."
nmap -sS -sV -O -p- "$TARGET" -oN "$OUTDIR/03-nmap-completo.txt"

echo "[*] (3/4) Enumeracion de SMB/NetBIOS con scripts NSE..."
nmap -p 139,445 \
  --script "smb-os-discovery,smb-enum-shares,smb-enum-users,smb-security-mode" \
  "$TARGET" -oN "$OUTDIR/03-smb-enum.txt"

echo "[*] (4/4) Enumeracion ampliada (enum4linux + nbtscan)..."
command -v enum4linux >/dev/null && enum4linux -a "$TARGET" | tee "$OUTDIR/03-enum4linux.txt" || echo "   enum4linux no instalado, omitido."
command -v nbtscan   >/dev/null && nbtscan "$TARGET"       | tee "$OUTDIR/03-nbtscan.txt"    || echo "   nbtscan no instalado, omitido."

echo "[+] Reconocimiento finalizado. Evidencias en: $OUTDIR"
