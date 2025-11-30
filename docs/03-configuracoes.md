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


