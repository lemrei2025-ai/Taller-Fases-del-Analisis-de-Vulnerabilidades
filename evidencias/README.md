# Evidencias

Guarda aquí **tus** capturas de pantalla y salidas de comandos, siguiendo la
nomenclatura `NN-descripcion.ext` (el número es la fase).

## Nomenclatura esperada

| Archivo | Fase | Contenido |
|---------|------|-----------|
| `00-topologia-red.png` | 0 | Config de red de las VMs |
| `00-sin-internet-xp.png` | 0 | XP sin salida a Internet |
| `00-ping-kali-a-xp.png` | 0 | Conectividad Kali ↔ XP |
| `01-snapshot-previo.png` | 1 | Snapshot de la VM objetivo |
| `02-host-vivo.txt` | 2 | Descubrimiento de host |
| `03-nmap-completo.txt` | 3 | Escaneo de puertos y versiones |
| `03-smb-enum.txt` | 3 | Enumeración SMB (NSE) |
| `03-enum4linux.txt` | 3 | Enumeración ampliada |
| `04-nmap-vuln.txt` | 4 | Detección de vulnerabilidades |
| `04-searchsploit.txt` | 4 | Exploits disponibles |
| `05-exploit-lanzado.png` | 5 | Sesión Meterpreter abierta |
| `05-getuid-system.png` | 5 | Privilegio SYSTEM confirmado |
| `06-hashdump.png` | 6 | Volcado de hashes (enmascarar) |
| `06-screenshot-victima.png` | 6 | Captura de la víctima |
| `06-shell-system.png` | 6 | Shell con `whoami = system` |

> ⚠️ **No subas a un repositorio público** hashes, contraseñas ni capturas con datos
> reales sensibles. El `.gitignore` ya excluye volcados; enmascara lo demás.
