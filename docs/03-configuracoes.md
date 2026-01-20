# 03 — Configurações da Infraestrutura

Este documento reúne as configurações básicas e avançadas do ambiente ATTALUS Tecnologia.

---

## 🔧 Configuração do Mikrotik (Inicial)

### Ações previstas:

- Reset seguro
- Configuração de WAN
- Criação da LAN
- Firewall básico
- Criar VLANs
- Criar DHCP Server
- Criar Address Lists
- Permitir gerenciamento apenas via rede Management
- Aplicar hardening

Um backup `.rsc` será mantido na pasta: infra/mikrotik/backups/


---

## 🔧 Configuração do Servidor

A depender do sistema escolhido (Windows Server ou Linux):

### Possíveis serviços:

- Active Directory / Samba AD
- DNS interno
- DHCP alternativo
- File Server
- Web Server para testes
- NTP

---

## 🔧 Configurações do Homelab

Serão documentadas aqui:

- Nome dos hosts
- Recursos alocados para cada VM
- Padrões de snapshot
- Rede interna do VirtualBox

---

## 🔧 Scripts e Automação

Scripts serão armazenados em:

projetos/automacoes/
infra/mikrotik/scripts/

---

## 3.1 --- Configuração Base do Mikrotik (Etapa 1 --- Cenário A)

**Data:** *\[19/01/2026\]*\
**Equipamento:** MikroTik RB750Gr3\
**Contexto do cenário:** Cenário A --- o roteador do provedor controla a
rede doméstica, enquanto o MikroTik gerencia exclusivamente a rede
isolada do Projeto Attalus.

------------------------------------------------------------------------

###  Objetivo desta etapa

Estabelecer a base de conectividade do Projeto **ATTALUS**, criando uma
rede isolada para laboratório de redes e infraestrutura, mantendo a rede
doméstica intacta e funcional.

------------------------------------------------------------------------

##  Topologia Física

-   **Roteador do provedor (rede doméstica)**
    -   Faixa: `192.168.0.0/24`
-   **MikroTik RB750Gr3**
    -   `ether1 (WAN)` → conectado à LAN do roteador do provedor\
    -   `ether2 (ATTALUS-LAN)` → rede do laboratório Attalus
-   **Dispositivos do laboratório (PC, futuros servidores, testes)**
    -   Conectados à interface `ATTALUS-LAN` do MikroTik.

------------------------------------------------------------------------

##  Topologia Lógica

  Rede            Faixa              Gateway
  --------------- ------------------ -------------------------
  Doméstica       `192.168.0.0/24`   Roteador do provedor
  Attalus (Lab)   `10.10.10.0/24`    `10.10.10.1` (MikroTik)

------------------------------------------------------------------------

## ⚙️ Configurações realizadas no MikroTik

### 1) Reset inicial do equipamento

-   Realizado **Reset de fábrica sem configuração padrão**
    (`No Default Configuration`).

------------------------------------------------------------------------

### 2) Padronização de nomes das interfaces

  Interface original   Novo nome         Função
  -------------------- ----------------- ------------------------------
  `ether1`             **WAN**           Conexão com a rede doméstica
  `ether2`             **ATTALUS-LAN**   Rede interna do laboratório

------------------------------------------------------------------------

### 3) Conexão com a internet (DHCP Client)

-   Caminho: **IP → DHCP Client**
-   Interface configurada: **WAN**
-   Resultado:
    -   O MikroTik recebeu IP automaticamente do roteador doméstico:\
    -   Exemplo obtido: `192.168.0.101`\
    -   Status: **bound**

------------------------------------------------------------------------

### 4) Criação da rede do laboratório Attalus

-   Caminho: **IP → Addresses → +**

```{=html}
<!-- -->
```
    Address:   10.10.10.1/24  
    Interface: ATTALUS-LAN

Isso definiu: - Rede Attalus: `10.10.10.0/24` - Gateway do laboratório:
`10.10.10.1`

------------------------------------------------------------------------

### 5) Configuração do servidor DHCP para Attalus

-   Caminho: **IP → DHCP Server → DHCP Setup**
-   Interface escolhida: **ATTALUS-LAN**
-   Resultado:
    -   Dispositivos conectados ao MikroTik passaram a receber IPs
        automaticamente na faixa `10.10.10.x`.

------------------------------------------------------------------------

### 6) Regra de NAT para acesso à internet

-   Caminho: **IP → Firewall → aba NAT → +**

**General**

    Chain: srcnat  
    Out. Interface: WAN

**Action**

    Action: masquerade

------------------------------------------------------------------------

## ✅ Resultados obtidos

Após as configurações:

-   Notebook conectado à `ATTALUS-LAN` recebeu IP:
    -   Exemplo: `10.10.10.254`
-   Gateway identificado corretamente como `10.10.10.1`
-   Acesso à internet funcionando através do MikroTik.
-   Rede do laboratório isolada logicamente da rede doméstica.

------------------------------------------------------------------------

## 🛡️ Observações de Segurança (boas práticas)

-   Nenhum IP público ou credencial foi registrado.
-   Apenas endereços privados e genéricos foram documentados
    (`10.0.0.0/8` e `192.168.0.0/16`).
-   Essa documentação é segura para publicação em repositório público e
    para uso em portfólio profissional.

------------------------------------------------------------------------

## 📌 Próxima etapa planejada

**Etapa 2 --- Segmentação por VLANs no MikroTik**

Planejamento preliminar: - VLAN 10 --- Administração\
- VLAN 20 --- Servidores\
- VLAN 30 --- Laboratório/Testes
