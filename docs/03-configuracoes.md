# 03 — Configurações da Infraestrutura Attalus

Este documento reúne as configurações **planejadas e implementadas** da infraestrutura do ambiente **ATTALUS Tecnologia**, cobrindo desde o roteador MikroTik até o futuro servidor e automações do homelab.

---

##  Configuração do MikroTik — Planejamento Inicial

### Ações previstas

* Reset seguro
* Configuração de WAN
* Criação da LAN
* Firewall básico
* Criar VLANs
* Criar DHCP Server
* Criar Address Lists
* Permitir gerenciamento apenas via rede Management
* Aplicar hardening

### Backups

Um backup `.rsc` será mantido na pasta:

* `infra/mikrotik/backups/`

Padrão sugerido de nomenclatura:

```
mikrotik-attalus-YYYY-MM-DD.rsc
```

---

##  Configuração do Servidor (Planejamento)

A depender do sistema escolhido (Windows Server ou Linux), estão previstos os seguintes serviços:

### Possíveis serviços

* Active Directory / Samba AD
* DNS interno
* DHCP alternativo
* File Server
* Web Server para testes
* NTP

---

##  Configurações do Homelab (Planejamento)

Serão documentadas nesta seção em etapas futuras:

* Nome dos hosts
* Recursos alocados para cada VM
* Padrões de snapshot
* Rede interna do VirtualBox

---

##  Scripts e Automação

Scripts serão armazenados em:

* `projetos/automacoes/`
* `infra/mikrotik/scripts/`

---

# 3.1 — Configuração Base do MikroTik

**Data:** 19/01/2026
**Equipamento:** MikroTik RB750Gr3

**Contexto do cenário:**
O roteador do provedor controla a rede doméstica, enquanto o MikroTik gerencia exclusivamente a rede isolada do Projeto Attalus.

---

##  Objetivo desta etapa

Estabelecer a base de conectividade do Projeto **ATTALUS**, criando uma rede isolada para laboratório de redes e infraestrutura, mantendo a rede doméstica intacta e funcional.

---

##  Topologia Física

* **Roteador do provedor (rede doméstica)**

  * Faixa: `192.168.0.0/24`

* **MikroTik RB750Gr3**

  * `ether1 (WAN)` → conectado à LAN do roteador do provedor
  * `ether2 (ATTALUS-LAN)` → rede do laboratório Attalus

* **Dispositivos do laboratório**

  * Conectados à interface `ATTALUS-LAN`

---

##  Topologia Lógica

| Rede          | Faixa          | Gateway               |
| ------------- | -------------- | --------------------- |
| Doméstica     | 192.168.0.0/24 | Roteador do provedor  |
| Attalus (Lab) | 10.10.10.0/24  | 10.10.10.1 (MikroTik) |

---

##  Configurações realizadas no MikroTik

### 1) Reset inicial do equipamento

* Reset de fábrica sem configuração padrão (`No Default Configuration`)

---

### 2) Padronização de nomes das interfaces

| Interface original | Novo nome   | Função                       |
| ------------------ | ----------- | ---------------------------- |
| ether1             | WAN         | Conexão com a rede doméstica |
| ether2             | ATTALUS-LAN | Rede interna do laboratório  |

---

### 3) Conexão com a internet (DHCP Client)

* Caminho: **IP → DHCP Client**
* Interface: **WAN**

## ✅ Resultados obtidos:

* IP obtido automaticamente (ex: `192.168.0.101`)
* Status: **bound**

---

### 4) Criação da rede do laboratório Attalus

* Caminho: **IP → Addresses → +**

  Address: 10.10.10.1/24
  Interface: ATTALUS-LAN

## ✅ Resultados obtidos:

* Rede: `10.10.10.0/24`
* Gateway: `10.10.10.1`

---

### 5) Configuração do DHCP Server

* Caminho: **IP → DHCP Server → DHCP Setup**
* Interface: **ATTALUS-LAN**

## ✅ Resultados obtidos:

* Distribuição automática de IPs na faixa `10.10.10.x`

---

### 6) Regra de NAT

* Caminho: **IP → Firewall → NAT**

  **Chain:** srcnat
  
  **Out Interface:** WAN
  
  **Action:** masquerade

---

## ✅ Resultados obtidos

* Notebook recebeu IP `10.10.10.x`
* Gateway funcional (`10.10.10.1`)
* Internet funcionando
* Rede isolada da rede doméstica

---

##  Observações de Segurança

* Nenhum IP público ou credencial exposta
* Uso exclusivo de redes privadas

---

##  Próxima etapa planejada

**Etapa 2 — Segmentação por VLANs**

* VLAN 10 — Administração
* VLAN 20 — Servidores
* VLAN 30 — Laboratório

---

#  3.2 — Segmentação por VLANs no MikroTik

**Data:** 17/03/2026
**Equipamento:** MikroTik RB750Gr3

---

##  Configurações realizadas

### 1) Criação da Bridge

```
BRIDGE-ATTALUS
```

Função:

* Switch virtual
* Centralização do tráfego

---

### 2) Associação da porta à Bridge

* Interface: ATTALUS-LAN
* Bridge: BRIDGE-ATTALUS

---

### 3) Implementação de VLANs

| VLAN | Nome        | Função        |
| ---- | ----------- | ------------- |
| 10   | VLAN10-MGMT | Administração |
| 20   | VLAN20-SERV | Servidores    |
| 30   | VLAN30-LAB  | Testes/Lab    |

---

### 4) Interface VLAN

* VLAN10-MGMT criada sobre a BRIDGE-ATTALUS

---

### 5) Endereçamento IP

```
10.10.10.1/24 → VLAN10-MGMT
```

Boas práticas:

* IP não fica na interface física
* IP vinculado à VLAN

---

### 6) Porta de acesso

Interface: ATTALUS-LAN

```
PVID = 10
```

Função:

* Tráfego sem tag entra na VLAN 10

---

### 7) Tabela de VLANs

**VLAN 10**

* Tagged: BRIDGE-ATTALUS
* Untagged: ATTALUS-LAN

**VLAN 20 e 30**

* Tagged: BRIDGE-ATTALUS
* Sem portas associadas (preparação futura)

---

### 8) DHCP Server

* Interface: VLAN10-MGMT
* Faixa: 10.10.10.x

---

### 9) NAT

```
Chain: srcnat  
Out Interface: WAN  
Action: masquerade  
```

---

## 🔄 Fluxo de Rede

```
Notebook
   ↓
ATTALUS-LAN
   ↓
BRIDGE-ATTALUS
   ↓
VLAN 10
   ↓
VLAN10-MGMT
   ↓
NAT
   ↓
WAN
   ↓
Internet
```

---

## 🚨 Problema encontrado

**Sintoma:**

* IP funcionando
* Sem internet com VLAN Filtering ativo

**Causa:**

* IP duplicado entre:

  * ATTALUS-LAN
  * VLAN10-MGMT

**Correção:**

* Remoção do IP da interface física
* IP mantido apenas na VLAN

---

##  Conceitos consolidados

**Bridge**

* Switch virtual

**VLAN**

* Segmentação lógica

**PVID**

* VLAN padrão da porta

**Tagged vs Untagged**

| Tipo     | Uso                |
| -------- | ------------------ |
| Tagged   | Transporte interno |
| Untagged | Dispositivo final  |

---

## ⚠️ Regra fundamental

```
IP deve estar na VLAN, nunca na interface física
```

---

##  Próxima etapa

**3.3 — Segmentação avançada**

Planejamento:

* Testar isolamento entre VLANs
* Criar regras de firewall
* Inserir dispositivos nas VLANs 20 e 30
