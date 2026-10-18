# Fase 3 — Escaneo y enumeración

> **Objetivo:** mapear puertos abiertos, identificar servicios y versiones, y **enumerar** en profundidad los servicios de Windows (SMB, NetBIOS, RPC) para extraer toda la información posible del objetivo.

Esta es la fase que más información aporta. "Enumerar" significa sacar cuentas de usuario, recursos compartidos, versión exacta del SO, etc.

---

## 3.1 Escaneo de puertos

### Escaneo rápido de los puertos más comunes

```bash
nmap -sS -T4 192.168.56.20
```

- `-sS`: escaneo SYN (sigiloso, rápido).
- `-T4`: plantilla de velocidad agresiva (apto para LAN/laboratorio).

### Escaneo completo con detección de servicios y SO

```bash
nmap -sS -sV -O -p- 192.168.56.20 -oN evidencias/03-nmap-completo.txt
```

- `-sV`: detecta **versión** de cada servicio.
- `-O`: huella del sistema operativo.
- `-p-`: los **65535** puertos.
- `-oN`: guarda la salida en un archivo (para tu informe).

### Salida típica de un Windows XP

```
PORT     STATE SERVICE       VERSION
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds  Microsoft Windows XP microsoft-ds
3389/tcp open  ms-wbt-server Microsoft Terminal Service (si RDP está activo)

Service Info: OS: Windows XP; CPE: cpe:/o:microsoft:windows_xp
```

> Los puertos **135 (RPC)**, **139 (NetBIOS)** y **445 (SMB)** son la puerta de entrada clásica de los sistemas Windows antiguos.

---

## 3.2 Scripts de enumeración de Nmap (NSE)

Nmap trae scripts que enumeran SMB a fondo:

```bash
nmap -p 139,445 --script "smb-os-discovery,smb-enum-shares,smb-enum-users,smb-security-mode" \
     192.168.56.20 -oN evidencias/03-smb-enum.txt
```

- `smb-os-discovery`: confirma versión exacta de Windows, nombre de equipo y dominio/grupo de trabajo.
- `smb-enum-shares`: recursos compartidos.
- `smb-enum-users`: cuentas de usuario.
- `smb-security-mode`: nivel de seguridad SMB (firma de mensajes, etc.).

---

## 3.3 Enumeración con enum4linux

`enum4linux` automatiza la enumeración de SMB/NetBIOS:

```bash
enum4linux -a 192.168.56.20 | tee evidencias/03-enum4linux.txt
```

`-a` ejecuta **todo**: usuarios, grupos, shares, política de contraseñas, información del SO y del grupo de trabajo. Revisa especialmente:

- **Users** → nombres de cuentas (ej. `Administrator`, `Invitado`, `HelpAssistant`).
- **Share Enumeration** → carpetas accesibles (`IPC$`, `ADMIN$`, `C$`).
- **OS information** → confirma "Windows XP".

---

## 3.4 Enumeración de NetBIOS

```bash
nbtscan 192.168.56.20
```

Devuelve el nombre NetBIOS del equipo y el grupo de trabajo, útil para el informe.

---

## 3.5 Prueba de acceso a recursos compartidos (SMB)

Intenta listar shares con sesión nula (sin credenciales):

```bash
smbclient -L //192.168.56.20 -N
```

- `-L`: listar shares.
- `-N`: sin contraseña (sesión nula). En XP antiguos esto a menudo funciona.

Si aparece `IPC$`, el canal está disponible y es la vía habitual de explotación remota de SMB.

---

## 3.6 Consolidar la información

Rellena tu tabla de servicios:

| Puerto | Servicio | Versión | Observación |
|--------|----------|---------|-------------|
| 135/tcp | msrpc | Windows RPC | Endpoint mapper |
| 139/tcp | netbios-ssn | — | Sesión NetBIOS |
| 445/tcp | microsoft-ds | Windows XP | **Objetivo principal** |
| 3389/tcp | ms-wbt-server | (si aplica) | RDP |

---

## 3.7 Evidencia a guardar

- `03-nmap-completo.txt` — escaneo completo.
- `03-smb-enum.txt` — scripts NSE de SMB.
- `03-enum4linux.txt` — enumeración completa.
- `03-smbclient-shares.png` — captura del listado de shares.

---

## Checklist de la fase

- [ ] Puertos abiertos identificados (135/139/445 como mínimo).
- [ ] Versión exacta de Windows confirmada.
- [ ] Usuarios y shares enumerados.
- [ ] Tabla de servicios completada.
- [ ] Evidencias guardadas.

➡️ Continúa con [`04-identificacion-vulnerabilidades.md`](04-identificacion-vulnerabilidades.md)
