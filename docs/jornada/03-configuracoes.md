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

### 3.1.1) Reset inicial do equipamento

* Reset de fábrica sem configuração padrão (`No Default Configuration`)

---

### 3.1.2) Padronização de nomes das interfaces

| Interface original | Novo nome   | Função                       |
| ------------------ | ----------- | ---------------------------- |
| ether1             | WAN         | Conexão com a rede doméstica |
| ether2             | ATTALUS-LAN | Rede interna do laboratório  |

---

### 3.1.3) Conexão com a internet (DHCP Client)

* Caminho: **IP → DHCP Client**
* Interface: **WAN**

## ✅ Resultados obtidos:

* IP obtido automaticamente (ex: `192.168.0.101`)
* Status: **bound**

---

### 3.1.4) Criação da rede do laboratório Attalus

* Caminho: **IP → Addresses → +**

  Address: 10.10.10.1/24
  Interface: ATTALUS-LAN

## ✅ Resultados obtidos:

* Rede: `10.10.10.0/24`
* Gateway: `10.10.10.1`

---

### 3.1.5) Configuração do DHCP Server

* Caminho: **IP → DHCP Server → DHCP Setup**
* Interface: **ATTALUS-LAN**

## ✅ Resultados obtidos:

* Distribuição automática de IPs na faixa `10.10.10.x`

---

### 3.1.6) Regra de NAT

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

##  Objetivo desta etapa

Implementar segmentação lógica da rede através de VLANs, permitindo isolamento entre ambientes (Administração, Servidores e Laboratório).

---

##  Configurações realizadas

### 3.2.1) Criação da Bridge

* Caminho: **Bridge → Bridge → +**

```
NOME: BRIDGE-ATTALUS
```

Função:

* Switch virtual
* Centralização do tráfego

---

## ✅ Resultados obtidos:

* Bridge criada com sucesso
* Estrutura preparada para segmentação por VLANs
* Base para implementação de VLAN Filtering

---
  
### 3.2.2) Associação da porta à Bridge

* Caminho: **Bridge → Ports → +**

* Interface: ATTALUS-LAN
* Bridge: BRIDGE-ATTALUS

---

## ✅ Resultados obtidos:

* Interface física integrada à bridge
* Tráfego passando pelo switch virtual
* Porta pronta para receber VLANs

---

### 3.2.3) Implementação de VLANs

* Caminho: **Interfaces → VLAN → +**

| VLAN | Nome        | Função        |
| ---- | ----------- | ------------- |
| 10   | VLAN10-MGMT | Administração |
| 20   | VLAN20-SERV | Servidores    |
| 30   | VLAN30-LAB  | Testes/Lab    |

---

## ✅ Resultados obtidos:

* VLANs criadas com sucesso
* Interfaces lógicas disponiveis para segmentação
* Separação inicial de dominíos de broadcast

---

### 3.2.4) Interface VLAN

* VLANs criadas sobre a interface BRIDGE-ATTALUS

---

### 3.2.5) Endereçamento IP

* Caminho: **IP → Address → +**

```
10.10.10.1/24 → VLAN10-MGMT
10.10.20.1/24 → VLAN20-SERV
10.10.30.1/24 → VLAN30-LAB
```

Boas práticas:

* IP não fica na interface física
* IP vinculado à VLAN

---

## ✅ Resultados obtidos:

* Gateways definidos para cada VLAN
* Segmentação lógica funcional
* Preparação para roteamento entre VLANs

---

### 3.2.6) Porta de acesso

Interface: ATTALUS-LAN

```
PVID = 10
```

Função:

* Tráfego sem tag entra na VLAN 10

---

## ✅ Resultados obtidos:

* Dispositivos conectados recebem VLAN padrão (MGMT)
* Comunicação funcional sem necessidade de VLAN tagging no cliente

---

### 3.2.7) Tabela de VLANs

**VLAN 10(MGMT)**

* Tagged: BRIDGE-ATTALUS
* Untagged: ATTALUS-LAN

**VLAN 20 e 30**

* Tagged: BRIDGE-ATTALUS
* Sem portas associadas (preparação futura)

---

## ✅ Resultados obtidos:

* VLAN 10 operacional para dispositivos finais
* VLANs 20 e 30 preparadas para expansão

---

### 3.2.8) DHCP Server

* Caminho: **DHCP Server → DHCP Setup**

```
Interface: VLAN10-MGMT
Faixa: 10.10.10.10 - 10.10.10.254 (Primeiras faixas reservadas para uso futuro)
```

```
Interface: VLAN20-SERV
Faixa: 10.10.20.10 - 10.10.20.254 (Primeiras faixas reservadas para uso futuro)
```

```
Interface: VLAN30-LAB
Faixa: 10.10.30.10 - 10.10.30.254 (Primeiras faixas reservadas para uso futuro)
```

---

## ✅ Resultados obtidos:

* VLAN10: IP distribuído corretamente
* VLAN20: DHCP ativo (aguardando uso)
* VLAN30: DHCP ativo (aguardando uso)

---

## 3.2.9) AJUSTE NAT

* Regra já existente mantida
* Nenhuma alteração necessária

---

## ✅ Resultados obtidos:

* Comunicação com internet preservada
* Tradução de endereços funcionando corretamente
* VCompatibilidade com múltiplas VLANs

---

## 🔄 Fluxo de Rede

```
Dispositivo
   ↓
ATTALUS-LAN
   ↓
BRIDGE-ATTALUS
   ↓
VLAN 10
   ↓
GATEWAY (10.10.10.1)
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

* Dispositivo recebia ip corretamente
* Sem internet ao ativar VLAN Filtering

**Causa:**

* IP duplicado entre as interfaces:

  * ATTALUS-LAN
  * VLAN10-MGMT
 
**Contexto do problema:**
 
 * Na primeira etapa de configuração (3.1), a rede ATTALUS-LAN operava como uma rede única, utilizando a faixa de IP 10.10.10.0/24.
   Durante a evolução da infraestrutura na etapa 3.2, esse mesma faixa de IP foi atribuida à interface VLAN10-MGMT,
   as duas interfaces estavam operando na mesma faixa de IP, o que levou ao problema em questão.

**Impacto:**

* Duas interfaces operando na mesma sub-rede
* Conflito de roteamento e inconsistencia no encaminhamento de pacotes
* Interrupção da conectividade com a internet ao ativar a VLAN Filtering

**Correção:**

* Remoção do IP da interface física ATTALUS-LAN
* IP mantido apenas na VLAN10-MGMT

---

## ✅ Resultados obtidos:

* Conflito de endereçamento eliminado
* Acesso à internet restabelecido
* VLAN Filtering operando corretamente
* Arquitetura alinhada com boas práticas de redes

---

##  Conceitos consolidados

**VLAN**

* Segmentação lógica da rede

**VLAN Filtering**

* Funciona verificando o ID da VLAN (VID) nos pacotes.
  Se a VLAN não estiver na "lista permitida"(allowed list) de uma porta trunk ou access o tráfego é bloqueado.

**Bridge**

* Switch virtual responsável pela comutação interna

**PVID**

* VLAN padrão atribuida a tráfego sem tag

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
* Criar regras de firewall entre as VLANs
* Inserir dispositivos nas VLANs 20 e 30
* Cria políticas de acesso (ex: MGMT → SERV permitido, LAB restrito)


---


# 3.3 — Segmentação Avançada: Portas Físicas para VLANs

**Data:** 16/08/2026
**Equipamento:** MikroTik RB750Gr3

---

## Objetivo desta etapa

Dar conectividade física real às VLANs 20 e 30, que
desde a 3.2 existiam só logicamente.

---

## Configurações realizadas

### 3.3.1) Escolha das portas físicas

* Sem switch gerenciável disponível no momento, optou-se por usar
  portas access dedicadas do próprio MikroTik
* ether3 → VLAN20-SERV
* ether4 → VLAN30-LAB

---

### 3.3.2) Associação das portas à Bridge

* Comando utilizado:

```routeros
/interface bridge port add bridge=BRIDGE-ATTALUS interface=ether3
/interface bridge port add bridge=BRIDGE-ATTALUS interface=ether4
```
---

## ✅ Resultados obtidos:
* Interfaces ether3 e ether4 integradas à bridge BRIDGE-ATTALUS
* Portas prontas para receber configuração de VLAN (PVID e Tabela)
* Nenhuma segmentação aplicada ainda nesta etapa

---

### 3.3.3) Definição de PVID por porta

* Comando utilizado:

```routeros
/interface bridge port set [find interface=ether3] pvid=20
/interface bridge port set [find interface=ether4] pvid=30
```

* Função:

    * Tráfego sem tag entrando em ether3 é tratado como VLAN20
    * Tráfego sem tag entrando em ether4 é tratado como VLAN30

---

## ✅ Resultados obtidos:
* ether3 configurada com PVID 20
* ether4 configurada com PVID 30
* Portas prontas para receber dispositivos finais sem necessidade
  de configuração de VLAN no cliente

---

### 3.3.4) Registro na Tabela de VLANs

**VLAN20**

* Untagged=ether3

**VLAN30**

* Untagged=ether4

---

## ✅ Resultados obtidos:
* Todo tráfego que entrar sem tag na interface ether3 será direcionada a VLAN20
* Todo tráfego que entrar sem tag na interface ether4 será direcionado a VLAN30

---

## 🚨 Problema encontrado

**Sintoma:**
* Comando `/interface bridge vlan add ... vlan-ids=20/30` retornou
  erro "vlan already added"

**Causa:**
* a entrada da VLAN já existia desde a 3.2, só sem porta
  untagged associada.

**Correção:**
* Uso de `/interface bridge vlan set [find vlan-ids=X] untagged=etherY`
  em vez de `add`

---

## ✅ Resultados obtidos (testes físicos):

* VLAN20 (ether3): dispositivo recebeu IP 10.10.20.254 via DHCP
* VLAN30 (ether4): dispositivo recebeu IP 10.10.30.253 via DHCP

---

## Conceitos consolidados

**Access port**
* Conecta dispositivos finais,como PCs e transmite dados de uma única VLAN, sem etiquetas de identificação.

**Trunk port**
* Conecta equipamentos de rede, como switches, carregando dados de multiplas VLANS usando etiquetas para organizar.

---

## Próxima etapa

**3.4 — Firewall entre VLANs**

Planejamento:
* Testar isolamento entre VLANs (hoje, sem firewall, tráfego passa livre)
* Criar regras de firewall entre as VLANs
* Criar políticas de acesso (ex: MGMT → SERV permitido, LAB restrito)
