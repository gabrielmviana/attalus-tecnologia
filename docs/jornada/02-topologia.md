# 02 — Topologia da Rede da ATTALUS Tecnologia

Este documento apresenta a topologia física e lógica da infraestrutura, servindo como referência para configurações e expansões futuras.

> **Nota de atualização:** este documento foi revisado para refletir a topologia **efetivamente implementada** no MikroTik (etapas 3.1 e 3.2 em `03-configuracoes.md`), substituindo o planejamento inicial.

---

## 🌐 Objetivos da topologia

- Organizar os fluxos de tráfego.
- Definir VLANs e segmentação.
- Documentar conexões físicas.
- Facilitar troubleshooting e alterações futuras.

---

## 🗺 Topologia Física (L1)

**Equipamentos em uso:**

- **MikroTik RB750Gr3** (RouterOS 7.18.2) — roteador/switch principal do laboratório
  - `ether1` → renomeado `WAN` — conectado à LAN do roteador do provedor (rede doméstica, `192.168.0.0/24`)
  - `ether2` → renomeado `ATTALUS-LAN` — porta de acesso do laboratório, associada à bridge
- Notebook host (dispositivo de gerenciamento/laboratório)
- Servidor local — **ainda não adquirido/implantado** (previsto na Fase 4 do roadmap)
- Switch gerenciável — **ainda não adquirido** (necessário para popular fisicamente as VLANs 20 e 30, hoje sem porta associada)

---

## 🧩 Topologia Lógica (L2/L3)

### Bridge

- `BRIDGE-ATTALUS`, com **VLAN Filtering ativado**, atua como switch virtual central. A porta `ATTALUS-LAN` está associada a ela.

### VLANs implementadas

| VLAN | Nome        | Função                          | Status                                    |
| ---- | ----------- | -------------------------------- | ------------------------------------------ |
| 10   | VLAN10-MGMT | Administração / gerenciamento    | ✅ Operacional — porta `ATTALUS-LAN` untagged (PVID 10) |
| 20   | VLAN20-SERV | Servidores                       | ⚙️ Criada e endereçada — sem porta física associada (aguardando switch/trunk) |
| 30   | VLAN30-LAB  | Testes, VMs e sandbox            | ⚙️ Criada e endereçada — sem porta física associada (aguardando switch/trunk) |

> A VLAN 99 (Native/gerenciamento de switch), cogitada no planejamento inicial, não foi implementada — será reavaliada quando um switch gerenciável entrar no laboratório.

---

## 📌 Endereçamento IPv4

Endereçamento real em uso (substitui o exemplo inicial em `192.168.10.0/24`):

| Rede           | VLAN | Faixa           | Gateway      | Faixa de DHCP            |
| -------------- | ---- | --------------- | ------------ | ------------------------- |
| MGMT           | 10   | 10.10.10.0/24   | 10.10.10.1   | 10.10.10.10 – 10.10.10.254 |
| SERV           | 20   | 10.10.20.0/24   | 10.10.20.1   | 10.10.20.10 – 10.10.20.254 |
| LAB            | 30   | 10.10.30.0/24   | 10.10.30.1   | 10.10.30.10 – 10.10.30.254 |

**Regra fundamental adotada:** o IP sempre é atribuído à interface VLAN, nunca à interface física — evita o conflito de endereçamento já enfrentado e documentado na etapa 3.2.

---

## 🔄 Fluxo de Rede (VLAN 10 — único fluxo ativo hoje)

```
Dispositivo
   ↓
ATTALUS-LAN (porta física, PVID 10)
   ↓
BRIDGE-ATTALUS
   ↓
VLAN 10 (MGMT)
   ↓
Gateway 10.10.10.1
   ↓
NAT (masquerade)
   ↓
WAN → Internet
```

VLANs 20 e 30 ainda não têm fluxo de dados real — existem apenas como segmentos lógicos aguardando porta física / dispositivos.

---

## 🔜 Próximos passos de topologia (Etapa 3.3)

- Associar uma porta física (ou trunk tagged, via switch gerenciável) às VLANs 20 e 30
- Definir regras de firewall entre VLANs (políticas de acesso: MGMT → SERV permitido, LAB restrito)
- Testar isolamento entre VLANs

---

## 🔜 Diagramas Visuais

Os diagramas serão incluídos na pasta: `assets/diagramas/`
