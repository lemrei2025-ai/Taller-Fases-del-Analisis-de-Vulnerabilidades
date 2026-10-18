# Taller Práctico de Análisis de Vulnerabilidades

> Laboratorio guiado, de principio a fin, sobre un objetivo **Windows XP Professional x64 Edition (SP1)** virtualizado y **totalmente aislado**. Recorre las **8 fases** del análisis de vulnerabilidades, demuestra con evidencias **qué ocurre cuando una vulnerabilidad toma el control del sistema** y cierra con el informe profesional y la remediación.

![Estado](https://img.shields.io/badge/estado-material_did%C3%A1ctico-blue)
![Licencia](https://img.shields.io/badge/licencia-MIT-green)
![Entorno](https://img.shields.io/badge/entorno-laboratorio_aislado-red)
![Nivel](https://img.shields.io/badge/nivel-intermedio-orange)

---

## Aviso legal y ético (LÉELO PRIMERO)

Este material es **exclusivamente educativo**. Todas las técnicas se ejecutan contra una máquina virtual de laboratorio, propiedad del estudiante y **aislada de cualquier red de producción o Internet**.

- **Nunca** apliques estas técnicas sobre sistemas, redes o datos que no sean de tu propiedad o para los que no cuentes con **autorización escrita y explícita**.
- El acceso no autorizado a sistemas informáticos es un **delito** en prácticamente todas las legislaciones (en Colombia, Ley 1273 de 2009; en España, arts. 197 bis y 264 del Código Penal; en EE. UU., Computer Fraud and Abuse Act; etc.).
- El autor y los facilitadores del curso **no se responsabilizan** del uso indebido de este contenido. La responsabilidad es **100 % del estudiante**.

> Firma el documento [`plantillas/acuerdo-de-uso.md`](plantillas/acuerdo-de-uso.md) antes de iniciar el taller.

---

## ¿Por qué Windows XP x64?

El objetivo del laboratorio es un **Windows XP Professional x64 Edition, Versión 2003, Service Pack 1**, corriendo sobre QEMU/VirtualBox (ver captura en `evidencias/`).

Se eligió este sistema porque:

- Está **fuera de soporte** (EOL: abril de 2014), por lo que acumula vulnerabilidades **conocidas, documentadas y reproducibles** — ideal para enseñar sin "adivinar".
- Permite ilustrar el ciclo completo: desde el descubrimiento hasta la **toma total de control** (SYSTEM) de forma didáctica.
- Refuerza la lección más importante del curso: **el software sin soporte es una bomba de tiempo**.

---

## Las 8 fases del taller

| # | Fase | Documento | Objetivo |
|---|------|-----------|----------|
| 0 | Preparación del laboratorio | [`docs/00-preparacion-laboratorio.md`](docs/00-preparacion-laboratorio.md) | Montar atacante + objetivo en red aislada |
| 1 | Planificación y alcance | [`docs/01-planificacion-alcance.md`](docs/01-planificacion-alcance.md) | Reglas del juego, objetivos, autorización |
| 2 | Reconocimiento | [`docs/02-reconocimiento.md`](docs/02-reconocimiento.md) | Descubrir el host y mapear la superficie |
| 3 | Escaneo y enumeración | [`docs/03-escaneo-enumeracion.md`](docs/03-escaneo-enumeracion.md) | Puertos, servicios, versiones, SMB/NetBIOS |
| 4 | Identificación de vulnerabilidades | [`docs/04-identificacion-vulnerabilidades.md`](docs/04-identificacion-vulnerabilidades.md) | Detectar, mapear a CVE y puntuar con CVSS |
| 5 | Explotación (toma de control) | [`docs/05-explotacion.md`](docs/05-explotacion.md) | Demostrar el impacto real: shell SYSTEM |
| 6 | Post-explotación (evidencia del impacto) | [`docs/06-post-explotacion.md`](docs/06-post-explotacion.md) | Qué puede hacer el atacante una vez dentro |
| 7 | Remediación | [`docs/07-remediacion.md`](docs/07-remediacion.md) | Cómo se habría evitado / cómo se corrige |
| 8 | Informe final | [`docs/08-informe-final.md`](docs/08-informe-final.md) | Redactar el entregable profesional |

---

## Arquitectura del laboratorio

```
            Red "solo-anfitrión" / NAT-Network aislada (sin salida a Internet)
                                 192.168.56.0/24
      ┌───────────────────────────┐             ┌───────────────────────────┐
      │        ATACANTE           │             │         OBJETIVO          │
      │   Kali Linux (2024.x)     │◄───────────►│  Windows XP Pro x64 SP1   │
      │   192.168.56.10           │             │  192.168.56.20            │
      │   nmap, metasploit,       │             │  SMB 445 / NetBIOS 139    │
      │   enum4linux, searchsploit│             │  RPC 135                  │
      └───────────────────────────┘             └───────────────────────────┘
```

> **Regla de oro:** la tarjeta de red del objetivo **jamás** debe estar en modo puente (bridge) ni con acceso a Internet. Un XP sin parches conectado a la red real se compromete solo en minutos.

---

## Requisitos previos

- Hipervisor: **VirtualBox 7.x** o **QEMU/KVM**.
- Máquina atacante: **Kali Linux** (o Parrot OS).
- Imagen objetivo: **Windows XP Professional x64 Edition SP1** (la del curso).
- Conocimientos básicos de redes TCP/IP y línea de comandos Linux.
- 8 GB de RAM recomendados en el anfitrión (4 GB mínimo).

---

## Cómo usar este repositorio

1. Lee y firma el acuerdo de uso (`plantillas/acuerdo-de-uso.md`).
2. Sigue los documentos de `docs/` **en orden**, de la fase 0 a la 8.
3. En cada fase, **captura evidencias** (capturas de pantalla, salidas de comandos) y guárdalas en `evidencias/` siguiendo la nomenclatura indicada.
4. Completa la **matriz de riesgos** (`plantillas/matriz-riesgos.csv`) a medida que avanzas.
5. Al final, redacta tu informe usando `plantillas/informe-vulnerabilidades.md`.

```bash
git clone https://github.com/<tu-usuario>/taller-analisis-vulnerabilidades.git
cd taller-analisis-vulnerabilidades
```

---

## Entregables del estudiante

- [ ] Acuerdo de uso firmado.
- [ ] Evidencias de cada fase en `evidencias/`.
- [ ] Matriz de riesgos completa.
- [ ] Informe final de vulnerabilidades (PDF o Markdown).
- [ ] Plan de remediación propuesto.

---

## Estructura del repositorio

```
taller-analisis-vulnerabilidades/
├── README.md
├── LICENSE
├── .gitignore
├── docs/                 # Las 8 fases, paso a paso
├── plantillas/           # Informe, matriz de riesgos, acuerdo de uso
├── scripts/              # Automatización de reconocimiento y escaneo
└── evidencias/           # Aquí van tus capturas y salidas
```

---

## Créditos y licencia

Material didáctico para el **curso de Análisis de Vulnerabilidades**.
Distribuido bajo licencia **MIT** (ver [`LICENSE`](LICENSE)). Úsalo, modifícalo y compártelo con atribución y responsabilidad.
