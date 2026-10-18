# Fase 2 — Reconocimiento

> **Objetivo:** descubrir que el objetivo existe y está vivo en la red, e identificar su dirección sin aún "golpear" sus servicios. En caja negra, es el primer contacto.

En un encargo real el reconocimiento tiene una parte **pasiva** (OSINT: WHOIS, Google dorks, redes sociales, DNS) y una **activa** (tocar la red). En un laboratorio aislado no hay OSINT posible, así que nos centramos en el **descubrimiento activo de host**.

---

## 2.1 Descubrimiento de hosts vivos en el segmento

### Opción A — netdiscover (ARP)

```bash
sudo netdiscover -r 192.168.56.0/24
```

Devuelve las IP y MAC de los equipos vivos. Busca la MAC del fabricante del hipervisor (QEMU/VirtualBox).

### Opción B — arp-scan

```bash
sudo arp-scan --interface=eth1 --localnet
```

### Opción C — Nmap ping sweep

```bash
nmap -sn 192.168.56.0/24
```

`-sn` hace solo descubrimiento (sin escaneo de puertos). Anota la IP del objetivo: debería ser `192.168.56.20`.

---

## 2.2 Identificar que el host responde

```bash
nmap -sn 192.168.56.20
```

Salida esperada (resumida):

```
Nmap scan report for 192.168.56.20
Host is up (0.00053s latency).
MAC Address: 52:54:00:XX:XX:XX (QEMU virtual NIC)
```

> El fabricante de la MAC (`52:54:00` para QEMU, `08:00:27` para VirtualBox) ya te confirma que es una VM.

---

## 2.3 Primera huella del sistema operativo (ligera)

Un TTL de respuesta cercano a **128** sugiere un sistema Windows:

```bash
ping -c 1 192.168.56.20
```

```
64 bytes from 192.168.56.20: icmp_seq=1 ttl=128 time=0.5 ms
                                        ^^^^^^^^
                                        TTL ~128 => probable Windows
```

(Linux suele responder con TTL ~64, dispositivos de red ~255.) Es solo una pista, no una confirmación.

---

## 2.4 Documentar la superficie preliminar

Registra en tu bitácora:

| Dato | Valor |
|------|-------|
| IP objetivo | 192.168.56.20 |
| MAC / fabricante | (anótala) |
| TTL observado | ~128 (probable Windows) |
| ¿Responde a ICMP? | Sí / No |

---

## 2.5 Evidencia a guardar

- `02-netdiscover.png` — salida del descubrimiento de hosts.
- `02-host-vivo.png` — salida de `nmap -sn`.
- `02-ttl-windows.png` — captura del `ping` con el TTL.

---

## Checklist de la fase

- [ ] Host objetivo descubierto en el segmento.
- [ ] IP y MAC anotadas.
- [ ] Pista de SO (TTL ~128) registrada.
- [ ] Evidencias capturadas.

➡️ Continúa con [`03-escaneo-enumeracion.md`](03-escaneo-enumeracion.md)
