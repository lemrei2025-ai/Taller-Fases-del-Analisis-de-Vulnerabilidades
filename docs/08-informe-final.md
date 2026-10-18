# Fase 8 — Informe final

> **Objetivo:** consolidar todo el trabajo en un entregable profesional. El informe es el verdadero producto del análisis: traduce lo técnico a decisiones de negocio.

Usa la plantilla [`../plantillas/informe-vulnerabilidades.md`](../plantillas/informe-vulnerabilidades.md) como base.

---

## 8.1 Estructura de un informe profesional

1. **Portada** — título, cliente/curso, autor, fecha, confidencialidad.
2. **Resumen ejecutivo** — para dirección, sin jerga: ¿qué se encontró, qué riesgo supone, qué hacer? Media página.
3. **Alcance y metodología** — qué se evaluó, cuándo, con qué marco (PTES/NIST 800-115), tipo de prueba.
4. **Resumen de hallazgos** — tabla con todos los hallazgos, severidad y estado.
5. **Hallazgos detallados** — uno por vulnerabilidad (ver plantilla de ficha abajo).
6. **Demostración de impacto** — la narrativa de la toma de control, con evidencias.
7. **Plan de remediación** — acciones priorizadas con responsables y plazos.
8. **Conclusiones** — postura general de seguridad del objetivo.
9. **Anexos** — salidas de herramientas, evidencias completas.

---

## 8.2 Cómo redactar el resumen ejecutivo

- Escribe para alguien **no técnico**.
- Empieza por el impacto de negocio, no por la herramienta.
- Ejemplo de tono: *"El equipo evaluado puede ser controlado por completo por un atacante de la red local sin necesidad de contraseña, debido a que ejecuta un sistema operativo sin soporte. Se recomienda su retirada o aislamiento inmediato."*
- Incluye un dato contundente: *"Se obtuvo control total (nivel SYSTEM) del equipo en menos de 5 minutos."*

---

## 8.3 Ficha de hallazgo (repetir por cada vulnerabilidad)

```
### [V-01] Ejecución remota de código en el servicio Server (SMB)

- Severidad:      Crítica (CVSS 9.8)
- CVE:            CVE-2008-4250  (Boletín MS08-067)
- Activo afectado: 192.168.56.20 (Windows XP x64 SP1), puertos 139/445
- Estado:         Abierto

Descripción
  Explicación clara del fallo y por qué existe.

Evidencia
  Comandos ejecutados y capturas (referencia a evidencias/05-getuid-system.png).

Impacto
  Qué consigue el atacante (control total, robo de datos, etc.).

Remediación
  Acción concreta y priorizada.
```

> Enmascara siempre datos sensibles (hashes, contraseñas) en el informe.

---

## 8.4 Visualizar el riesgo

Incluye la **matriz de riesgos** (de `plantillas/matriz-riesgos.csv`) y, si puedes, un gráfico sencillo de hallazgos por severidad (p. ej. 1 Crítica, 2 Altas, 1 Media). Ayuda a la dirección a ver la foto completa de un vistazo.

---

## 8.5 Exportar el informe

Desde Markdown a PDF con `pandoc` (en Kali/Linux):

```bash
sudo apt install -y pandoc texlive-latex-base texlive-fonts-recommended
pandoc plantillas/informe-vulnerabilidades.md -o informe-final.pdf
```

---

## 8.6 Entregables finales del taller

- [ ] Informe completo (PDF o Markdown).
- [ ] Matriz de riesgos.
- [ ] Carpeta `evidencias/` con todas las capturas.
- [ ] Plan de remediación.
- [ ] Acuerdo de uso firmado.

---

## Rúbrica sugerida de evaluación (para el docente)

| Criterio | Peso |
|----------|------|
| Laboratorio montado y aislado correctamente | 10 % |
| Reconocimiento y enumeración completos | 15 % |
| Identificación correcta de CVE y CVSS | 20 % |
| Demostración de explotación con evidencia | 20 % |
| Análisis del impacto (post-explotación) | 15 % |
| Plan de remediación | 10 % |
| Calidad del informe y resumen ejecutivo | 10 % |

---

🎓 **Fin del taller.** Has recorrido el ciclo completo del análisis de vulnerabilidades: de descubrir un host a demostrar su control total y proponer cómo blindarlo.
