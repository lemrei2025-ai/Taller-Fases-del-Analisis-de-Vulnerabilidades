# Fase 1 — Planificación y alcance

> **Objetivo:** antes de tocar una sola herramienta, definir **qué** se va a evaluar, **hasta dónde**, **con qué autorización** y **cómo** se medirá el éxito. Esta fase es la que separa un análisis profesional de un ataque.

En un análisis real esta fase se traduce en un contrato y unas *Rules of Engagement (ROE)*. En el laboratorio la replicamos a escala.

---

## 1.1 Autorización

Todo análisis **parte de un permiso por escrito**. Sin él, no hay análisis: hay un delito.

➡️ Firma [`../plantillas/acuerdo-de-uso.md`](../plantillas/acuerdo-de-uso.md). En un encargo real, este documento lo firma el **propietario del sistema**, no el analista.

---

## 1.2 Definición del alcance (scope)

| Elemento | Definición para este taller |
|----------|------------------------------|
| **Objetivo en alcance** | Únicamente el host `192.168.56.20` (Windows XP x64) |
| **Fuera de alcance** | El hipervisor anfitrión, la máquina atacante, cualquier otra IP, Internet |
| **Tipo de prueba** | Caja negra (black-box): partimos sin credenciales ni información interna |
| **Ventana de ejecución** | La sesión de clase / fecha del taller |
| **Técnicas permitidas** | Escaneo activo, enumeración, explotación controlada, post-explotación demostrativa |
| **Técnicas prohibidas** | Ataques de denegación de servicio destructivos, borrado de datos, cualquier acción fuera del host objetivo |

> **Regla práctica:** si una acción pudiera afectar algo que **no** está explícitamente en alcance, no se ejecuta.

---

## 1.3 Objetivos del análisis

1. Descubrir y documentar la superficie de ataque del objetivo.
2. Identificar vulnerabilidades, mapearlas a CVE y priorizarlas por CVSS.
3. **Validar el impacto real** de al menos una vulnerabilidad crítica demostrando toma de control.
4. Evidenciar qué puede hacer un atacante tras comprometer el sistema.
5. Entregar un informe con hallazgos, riesgos y un plan de remediación.

---

## 1.4 Metodología de referencia

Este taller sigue una metodología estándar de la industria. Puedes citar como marco de referencia cualquiera de estos (son complementarios):

- **PTES** — Penetration Testing Execution Standard.
- **OWASP WSTG** / **OSSTMM** para la parte metodológica.
- **NIST SP 800-115** — *Technical Guide to Information Security Testing and Assessment*.
- Para puntuar severidad: **CVSS v3.1** (First.org).

El flujo que usaremos:

```
Planificación → Reconocimiento → Escaneo/Enumeración → Identificación
       → Explotación → Post-explotación → Remediación → Informe
```

---

## 1.5 Criterios de éxito y gestión del riesgo

- **Éxito:** se documentan ≥ 3 hallazgos y se demuestra ≥ 1 explotación con evidencia.
- **Snapshot obligatorio:** antes de la fase de explotación, toma una **instantánea (snapshot)** de la VM objetivo para poder revertirla. La explotación puede dejar el sistema inestable.
- **Plan de contingencia:** si el objetivo se cuelga, se revierte al snapshot y se reanuda.

---

## 1.6 Evidencia a guardar

- `01-alcance-definido.md` — tu tabla de alcance rellenada.
- `01-snapshot-previo.png` — captura mostrando el snapshot creado de la VM.

---

## Checklist de la fase

- [ ] Acuerdo de uso firmado.
- [ ] Alcance (host en/ fuera) definido por escrito.
- [ ] Objetivos y criterios de éxito claros.
- [ ] Snapshot de la VM objetivo creado.

➡️ Continúa con [`02-reconocimiento.md`](02-reconocimiento.md)
