# Fase 7 — Remediación

> **Objetivo:** cerrar el ciclo. Para cada vulnerabilidad demostrada, indicar **cómo se corrige** y **cómo se habría prevenido**. Un análisis sin plan de remediación está incompleto.

---

## 7.1 Remediación específica de la vulnerabilidad crítica (MS08-067)

| Nivel | Acción |
|-------|--------|
| **Parche** | Aplicar la actualización del boletín MS08-067. *En XP ya no hay soporte*, por lo que el parche no siempre está disponible — lo que nos lleva a la medida de fondo. |
| **Mitigación de red** | Bloquear el acceso a los puertos 139/445 desde redes no confiables; segmentar el equipo. |
| **Configuración** | Activar el firewall de Windows y restringir el uso compartido de archivos. |

---

## 7.2 La medida de fondo: retirar el software sin soporte

La causa raíz no es "un puerto abierto": es un **sistema operativo fuera de soporte (EOL)**. Windows XP dejó de recibir parches en 2014.

**Recomendación principal:** migrar a un sistema operativo con soporte (Windows 10/11 LTSC, o Linux según el caso de uso) y **dar de baja** el XP. Si por un motivo industrial/legacy no se puede migrar de inmediato:

- Aislarlo en una **VLAN/red segmentada** sin acceso a Internet ni a la red general.
- Permitir únicamente las conexiones estrictamente necesarias (lista blanca de IP/puertos).
- Monitorizar cualquier tráfico hacia/desde ese equipo.

---

## 7.3 Controles defensivos transversales

Medidas que elevan la seguridad del parque completo, no solo de este equipo:

1. **Gestión de parches** — proceso periódico y documentado de actualización (patch management).
2. **Segmentación de red** — separar equipos críticos y legacy; principio de mínimo privilegio en la red.
3. **Firewall de host y de red** — cerrar todo lo que no sea imprescindible; denegar por defecto.
4. **Desactivar SMBv1 / protocolos obsoletos** en todo el parque.
5. **Hardening** — guías CIS Benchmark; deshabilitar servicios innecesarios.
6. **EDR/Antivirus** actualizado en endpoints con soporte.
7. **Registro centralizado (SIEM)** — enviar logs fuera del equipo para que no puedan borrarse localmente.
8. **Copias de seguridad** probadas y aisladas, para recuperación tras incidente.
9. **Gestión de identidades** — contraseñas robustas, bloqueo de cuentas, MFA donde sea posible.
10. **Análisis de vulnerabilidades recurrente** — repetir este proceso de forma periódica.

---

## 7.4 Mapa hallazgo → remediación

Para el informe, asocia cada hallazgo con su corrección y una prioridad:

| ID | Hallazgo | Remediación | Prioridad |
|----|----------|-------------|-----------|
| V-01 | RCE SMB (CVE-2008-4250) | Migrar SO / aislar + parchear | **Inmediata** |
| V-02 | SMBv1 habilitado | Deshabilitar SMBv1 | Alta |
| V-03 | Firewall desactivado | Activar y configurar firewall | Alta |
| V-04 | Sesión nula SMB | Restringir sesiones anónimas | Media |

*(Ajusta según tus hallazgos reales.)*

---

## 7.5 Verificación de la remediación (re-test)

Tras aplicar las medidas, **se vuelve a probar** para confirmar que el hallazgo quedó cerrado:

```bash
# El equipo remediado NO debe volver a reportar la vulnerabilidad
nmap -p 139,445 --script smb-vuln-ms08-067 192.168.56.20
```

Un hallazgo no se marca como "Cerrado" en la matriz de riesgos hasta que el re-test lo confirma.

---

## Checklist de la fase

- [ ] Remediación específica por hallazgo definida.
- [ ] Recomendación de fondo (EOL) documentada.
- [ ] Controles transversales propuestos.
- [ ] Plan de verificación (re-test) descrito.

➡️ Continúa con [`08-informe-final.md`](08-informe-final.md)
