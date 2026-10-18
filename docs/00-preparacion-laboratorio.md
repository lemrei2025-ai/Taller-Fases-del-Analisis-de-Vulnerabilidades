# Fase 0 — Preparación del laboratorio

> **Objetivo:** montar un entorno controlado y **aislado** con una máquina atacante (Kali) y la máquina objetivo (Windows XP x64), verificar que se ven entre sí y que **no tienen salida a Internet**.

---

## 0.1 Topología

| Rol | SO | IP sugerida | Red |
|-----|----|-------------|-----|
| Atacante | Kali Linux 2024.x | `192.168.56.10` | Red solo-anfitrión |
| Objetivo | Windows XP Pro x64 SP1 | `192.168.56.20` | Red solo-anfitrión |

> Si usas DHCP, anota las IP que realmente te asigne el hipervisor; el resto del taller usa estas de ejemplo.

---

## 0.2 Crear la red aislada

### En VirtualBox

1. `Archivo → Herramientas → Administrador de red`.
2. Pestaña **Redes solo-anfitrión** → **Crear**. Se genera `vboxnet0` (p. ej. `192.168.56.1/24`).
3. En **cada** VM: `Configuración → Red → Adaptador 1 → Conectado a: Red solo-anfitrión → vboxnet0`.
4. **Desactiva** cualquier segundo adaptador en modo NAT o Puente del objetivo.

### En QEMU/KVM (el de la captura del curso)

Crea una red aislada sin reenvío a la red física:

```bash
# Definir una red NAT aislada (sin DHCP hacia Internet)
sudo virsh net-define /dev/stdin <<'EOF'
<network>
  <name>lab-aislada</name>
  <bridge name="virbr-lab"/>
  <ip address="192.168.56.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.56.10" end="192.168.56.50"/>
    </dhcp>
  </ip>
</network>
EOF
sudo virsh net-start lab-aislada
sudo virsh net-autostart lab-aislada
```

Luego conecta ambas VMs a `lab-aislada` y **no** le añadas la interfaz `default` (que sí tiene NAT a Internet).

> **Comprobación crítica:** desde el XP objetivo intenta navegar a cualquier web. **No debe cargar nada.** Si carga, el laboratorio NO está aislado: detente y corrige.

---

## 0.3 Preparar la máquina atacante (Kali)

```bash
# Actualizar e instalar el herramental del taller
sudo apt update
sudo apt install -y nmap metasploit-framework enum4linux smbclient \
                    nbtscan exploitdb net-tools dnsutils

# Verificar versiones
nmap --version
msfconsole --version
searchsploit -u        # actualiza la base de ExploitDB
```

Asigna IP estática (opcional) a la interfaz del laboratorio:

```bash
sudo ip addr add 192.168.56.10/24 dev eth1   # ajusta el nombre de interfaz
sudo ip link set eth1 up
ip addr show eth1
```

---

## 0.4 Preparar la máquina objetivo (Windows XP x64)

Para que el laboratorio sea realista y los exploits clásicos funcionen, el XP debe estar **sin parches posteriores** y con los servicios por defecto activos:

1. **Firewall de Windows:** desactívalo *solo dentro del laboratorio aislado*
   `Panel de control → Firewall de Windows → Desactivado`.
   > Esto simula un equipo mal configurado; es intencional y seguro **solo** porque la red está aislada.
2. **Compartir archivos e impresoras** activado (habilita SMB/NetBIOS en 139/445).
3. Anota la IP del XP:
   `Inicio → Ejecutar → cmd → ipconfig`

---

## 0.5 Verificar conectividad entre ambas máquinas

Desde Kali:

```bash
ping -c 3 192.168.56.20
```

Debes recibir respuesta. Si no responde:
- Verifica que ambas VMs estén en la **misma** red solo-anfitrión.
- En XP, confirma que el firewall permite ICMP o está desactivado.

Desde XP (opcional):

```cmd
ping 192.168.56.10
```

---

## 0.6 Evidencia a guardar

Guarda en `evidencias/`:

- `00-topologia-red.png` — captura de la configuración de red de ambas VMs.
- `00-sin-internet-xp.png` — captura mostrando que el XP **no** navega a Internet.
- `00-ping-kali-a-xp.png` — captura del `ping` exitoso.

---

## Checklist de la fase

- [ ] Red solo-anfitrión creada y ambas VMs conectadas a ella.
- [ ] Objetivo **sin** salida a Internet (verificado).
- [ ] Kali con el herramental instalado y actualizado.
- [ ] Conectividad Kali ↔ XP confirmada con `ping`.
- [ ] Evidencias capturadas.

➡️ Continúa con [`01-planificacion-alcance.md`](01-planificacion-alcance.md)
