# Informe de Análisis de Vulnerabilidades

**Cliente / Curso:** _______________________
**Activo evaluado:** Windows XP Professional x64 Edition SP1 — `192.168.56.20`
**Autor:** _______________________
**Fecha:** _______________________
**Clasificación:** Confidencial — Uso educativo

---

## 1. Resumen ejecutivo

> Media página, lenguaje no técnico. Qué se encontró, qué riesgo supone para la
> organización y qué se recomienda hacer de inmediato.

El equipo evaluado puede ser controlado por completo por un atacante de la red
local **sin necesidad de credenciales ni interacción del usuario**, debido a que
ejecuta un sistema operativo fuera de soporte con servicios vulnerables expuestos.
Durante la prueba se obtuvo control total (nivel SYSTEM) en pocos minutos. Se
recomienda su **retirada o aislamiento inmediato**.

---

## 2. Alcance y metodología

- **En alcance:** host `192.168.56.20`.
- **Fuera de alcance:** resto de la red, hipervisor, Internet.
- **Tipo de prueba:** caja negra.
- **Marco de referencia:** PTES / NIST SP 800-115.
- **Severidad:** CVSS v3.1.
- **Fecha de ejecución:** _______________________

---

## 3. Resumen de hallazgos

| ID | Hallazgo | CVE | CVSS | Severidad | Estado |
|----|----------|-----|------|-----------|--------|
| V-01 | RCE en servicio Server (SMB) | CVE-2008-4250 | 9.8 | Crítica | Abierto |
| V-02 | SMBv1 habilitado | — | 7.5 | Alta | Abierto |
| V-03 | Firewall desactivado | — | 6.5 | Media | Abierto |
| V-05 | Sistema operativo EOL | — | 9.0 | Crítica | Abierto |

*(Completa con tus hallazgos reales.)*

---

## 4. Hallazgos detallados

### [V-01] Ejecución remota de código en el servicio Server (SMB)

- **Severidad:** Crítica (CVSS 9.8 — `AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`)
- **CVE / Boletín:** CVE-2008-4250 / MS08-067
- **Activo:** `192.168.56.20`, puertos 139/445
- **Estado:** Abierto

**Descripción**
Fallo en el servicio *Server* de Windows que permite a un atacante remoto ejecutar
código arbitrario sin autenticación mediante una petición RPC manipulada sobre SMB.

**Evidencia**
Detección: `evidencias/04-nmap-vuln.txt`.
Explotación: `evidencias/05-getuid-system.png` (sesión con privilegios `NT AUTHORITY\SYSTEM`).

**Impacto**
Control total del sistema: lectura y exfiltración de archivos, volcado de credenciales,
espionaje del usuario y persistencia. Compromiso total de Confidencialidad, Integridad
y Disponibilidad.

**Remediación**
Migrar el equipo a un SO con soporte o, de forma transitoria, aislarlo en red segmentada
sin acceso a Internet y bloquear 139/445 desde redes no confiables.

---

*(Repite la ficha anterior para V-02, V-03, V-05...)*

---

## 5. Demostración de impacto (toma de control)

Narrativa de la cadena de ataque, paso a paso, con referencia a las evidencias:

1. Descubrimiento del host (`evidencias/02-host-vivo.png`).
2. Enumeración de SMB y versión de SO (`evidencias/03-smb-enum.txt`).
3. Identificación de MS08-067 (`evidencias/04-nmap-vuln.txt`).
4. Explotación y obtención de shell SYSTEM (`evidencias/05-exploit-lanzado.png`).
5. Post-explotación: hashes, captura de pantalla, shell (`evidencias/06-*.png`).

| Dimensión | Comprometida | Evidencia |
|-----------|--------------|-----------|
| Confidencialidad | Total | Exfiltración / hashdump |
| Integridad | Total | Creación de usuarios / comandos |
| Disponibilidad | Total | Control del sistema |

---

## 6. Plan de remediación

| ID | Acción | Prioridad | Responsable | Plazo |
|----|--------|-----------|-------------|-------|
| V-01 | Migrar/aislar SO | Inmediata | | |
| V-02 | Deshabilitar SMBv1 | Alta | | |
| V-03 | Activar firewall | Alta | | |
| V-05 | Retirar SO EOL | Inmediata | | |

---

## 7. Conclusiones

> Postura general de seguridad del activo y mensaje final para la dirección.

---

## 8. Anexos

- Salidas completas de herramientas (`evidencias/`).
- Reporte del escáner de vulnerabilidades (si aplica).
- Matriz de riesgos (`plantillas/matriz-riesgos.csv`).
