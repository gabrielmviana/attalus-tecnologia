# 02 — Topologia da Rede da ATTALUS Tecnologia

Este documento detalha a estrutura lógica e física da rede ATTALUS.

---

## 📡 Equipamentos Principais

- Mikrotik Router (modelo atual do laboratório)
- Notebook Dell (administração)
- Servidor em aquisição
- Switch (futuro)
- Access Point (futuro)

---

## 🗺 Topologia Lógica (planejada)

- VLAN 10 — Administração
- VLAN 20 — Servidores
- VLAN 30 — Usuários
- VLAN 40 — IoT
- VLAN 50 — Guest

---

## 📐 Diagrama (versão inicial)

> O diagrama será adicionado na pasta `assets/diagramas` após criação no Draw.io.

---

## 📌 Endereçamento Inicial

- Sub-rede principal: `192.168.10.0/24`
- Gateway: `192.168.10.1`
- DNS: Servidor Windows Server (futuro)
- DHCP: Mikrotik

---

## 🔧 Tarefas Futuras

- Criar o diagrama final no Draw.io
- Documentar portas físicas do Switch e Mikrotik
- Inserir imagens na pasta assets

