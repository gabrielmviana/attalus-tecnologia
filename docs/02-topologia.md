# 02 — Topologia da Rede da ATTALUS Tecnologia

Este documento apresenta a topologia física e lógica da infraestrutura, servindo como referência para configurações e expansões futuras.

---

## 🌐 Objetivos da topologia

- Organizar os fluxos de tráfego.
- Definir VLANs e segmentação.
- Documentar conexões físicas.
- Facilitar troubleshooting e alterações futuras.

---

## 🗺 Topologia Física (L1)

**Equipamentos previstos:**
- Mikrotik hEX (ou similar)
- Servidor local (LAB-SRV01)
- Notebook host (LAB-NOTE01)
- Switch não gerenciável (futuro upgrade para gerenciável)

---

## 🧩 Topologia Lógica (L2/L3)

### VLANs sugeridas (inicial):

| VLAN | Nome        | Função                         |
|------|-------------|---------------------------------|
| 10   | Management  | Acesso ao Mikrotik e servidores |
| 20   | Users       | Tráfego geral interno          |
| 30   | Lab         | Testes, VMs e sandbox          |
| 99   | Native      | Gerenciamento do switch        |

---

## 📌 Endereçamento IPv4

Exemplo inicial:

- Rede principal (LAN): `192.168.10.0/24`
- Servidor: `192.168.10.10`
- Mikrotik (gateway): `192.168.10.1`
- Range DHCP: `192.168.10.100-192.168.10.200`

O plano será expandido conforme o servidor for adquirido.

---

## 🔜 Diagramas Visuais

Os diagramas serão incluídos na pasta: assets/diagramas/


