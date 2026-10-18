# Fase 4 — Identificación y evaluación de vulnerabilidades

> **Objetivo:** tomar la información de la enumeración, **detectar** las vulnerabilidades del objetivo, **mapearlas a CVE**, verificar si hay exploit disponible y **priorizarlas** con CVSS. Aquí convertimos datos en hallazgos.

---

## 4.1 Escaneo de vulnerabilidades con Nmap NSE

Nmap incluye una categoría de scripts `vuln` que detecta debilidades conocidas:

```bash
nmap -p 139,445 --script vuln 192.168.56.20 -oN evidencias/04-nmap-vuln.txt
```

En un Windows XP sin parches, es típico ver detecciones como:

```
| smb-vuln-ms08-067:
|   VULNERABLE:
|   Microsoft Windows system vulnerable to remote code execution (MS08-067)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2008-4250
|     Risk factor: HIGH
```

> **MS08-067 (CVE-2008-4250)** es la vulnerabilidad didáctica por excelencia del XP: un fallo en el servicio *Server* (SMB) que permite **ejecución remota de código** sin autenticación. Es la que usaremos para demostrar la toma de control.

Dependiendo de la configuración del XP, los scripts también pueden señalar `smb-vuln-ms17-010` u otras.

---

## 4.2 Escáner de vulnerabilidades dedicado (opcional pero recomendado)

Para un análisis profesional se usa un escáner como **OpenVAS/Greenbone** o **Nessus Essentials**. Flujo general (OpenVAS en Kali):

```bash
sudo gvm-setup          # primera vez; descarga feeds de vulnerabilidades
sudo gvm-start          # levanta la interfaz web (https://127.0.0.1:9392)
```

Luego, desde la interfaz web:
1. `Scans → Tasks → New Task`.
2. Target: `192.168.56.20`.
3. Scan Config: *Full and fast*.
4. Lanza y espera el reporte: lista cada hallazgo con su CVE, CVSS y solución.

> El escáner genera la base de tu matriz de riesgos. Exporta el reporte a PDF/CSV para el informe.

---

## 4.3 Buscar exploits disponibles (searchsploit)

Con la versión del servicio y el CVE, verifica si existe código de explotación público:

```bash
searchsploit windows xp smb remote
searchsploit ms08-067
```

Salida típica:

```
Microsoft Windows - 'NetAPI32.dll' Code Execution (MS08-067) | windows/remote/...
```

Esto confirma que el hallazgo es **explotable en la práctica**, no solo teórico — dato clave para el impacto en el informe.

---

## 4.4 Mapear hallazgo → CVE → CVSS

Para cada vulnerabilidad construye una ficha. Ejemplo con MS08-067:

| Campo | Valor |
|-------|-------|
| **Hallazgo** | Ejecución remota de código en el servicio Server (SMB) |
| **CVE** | CVE-2008-4250 |
| **Boletín** | MS08-067 |
| **Vector CVSS v3.1** | `AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| **Puntuación CVSS** | **9.8 (Crítica)** |
| **Puertos afectados** | 139/tcp, 445/tcp |
| **Exploit público** | Sí (Metasploit, ExploitDB) |
| **Impacto** | Control total del sistema sin autenticación |

> Para calcular/validar el vector CVSS usa la calculadora oficial de FIRST: https://www.first.org/cvss/calculator/3.1

### Interpretación de la severidad CVSS v3.1

| Rango | Severidad |
|-------|-----------|
| 0.1 – 3.9 | Baja |
| 4.0 – 6.9 | Media |
| 7.0 – 8.9 | Alta |
| 9.0 – 10.0 | Crítica |

---

## 4.5 Rellenar la matriz de riesgos

Abre [`../plantillas/matriz-riesgos.csv`](../plantillas/matriz-riesgos.csv) y añade una fila por hallazgo:

```
ID,Hallazgo,CVE,CVSS,Severidad,Probabilidad,Impacto,Riesgo,Estado
V-01,RCE en servicio Server (SMB),CVE-2008-4250,9.8,Critica,Alta,Alto,Critico,Abierto
```

El **riesgo** combina **probabilidad** (¿hay exploit, es accesible?) e **impacto** (¿qué se pierde si se explota?).

---

## 4.6 Priorización

Ordena los hallazgos por riesgo. Las **críticas con exploit público y accesibles desde la red** van primero: son las que un atacante usaría en segundos. En este laboratorio, MS08-067 encabeza la lista.

---

## 4.7 Evidencia a guardar

- `04-nmap-vuln.txt` — detección de vulnerabilidades.
- `04-searchsploit.png` — exploits disponibles.
- `04-reporte-openvas.pdf` — (si usaste OpenVAS/Nessus).
- `matriz-riesgos.csv` — actualizada.

---

## Checklist de la fase

- [ ] Vulnerabilidades detectadas y mapeadas a CVE.
- [ ] CVSS calculado para cada hallazgo.
- [ ] Disponibilidad de exploit verificada.
- [ ] Matriz de riesgos poblada y priorizada.
- [ ] Evidencias guardadas.

➡️ Continúa con [`05-explotacion.md`](05-explotacion.md)
