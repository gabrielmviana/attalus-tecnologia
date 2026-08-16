# 2026-08-15 20:14:27 by RouterOS 7.18.2
# software id = TTEQ-F6PV
#
# model = RB750Gr3
# serial number = HJQ0APWRH0X
/interface bridge
add name=BRIDGE-ATTALUS vlan-filtering=yes
/interface ethernet
set [ find default-name=ether2 ] name=ATTALUS-LAN
set [ find default-name=ether1 ] name=WAN
/interface vlan
add interface=BRIDGE-ATTALUS name=VLAN10-MGMT vlan-id=10
add interface=BRIDGE-ATTALUS name=VLAN20-SERV vlan-id=20
add interface=BRIDGE-ATTALUS name=VLAN30-LAB vlan-id=30
/ip pool
add name=dhcp_pool1 ranges=10.10.10.2-10.10.10.254
add name=dhcp_pool2 ranges=10.10.10.10-10.10.10.254
add name=dhcp_pool3 ranges=10.10.20.10-10.10.20.254
add name=dhcp_pool4 ranges=10.10.30.10-10.10.30.254
/ip dhcp-server
add address-pool=dhcp_pool2 interface=VLAN10-MGMT name=dhcp2
add address-pool=dhcp_pool3 interface=VLAN20-SERV name=dhcp3
add address-pool=dhcp_pool4 interface=VLAN30-LAB name=dhcp4
/interface bridge port
add bridge=BRIDGE-ATTALUS interface=ATTALUS-LAN pvid=10
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/interface bridge vlan
add bridge=BRIDGE-ATTALUS tagged=BRIDGE-ATTALUS untagged=ATTALUS-LAN \
    vlan-ids=10
add bridge=BRIDGE-ATTALUS tagged=BRIDGE-ATTALUS vlan-ids=20
add bridge=BRIDGE-ATTALUS tagged=BRIDGE-ATTALUS vlan-ids=30
/ip address
add address=10.10.10.1/24 interface=VLAN10-MGMT network=10.10.10.0
add address=10.10.20.1/24 interface=VLAN20-SERV network=10.10.20.0
add address=10.10.30.1/24 interface=VLAN30-LAB network=10.10.30.0
/ip dhcp-client
add interface=WAN
/ip dhcp-server network
add address=10.10.10.0/24 gateway=10.10.10.1
add address=10.10.20.0/24 gateway=10.10.20.1
add address=10.10.30.0/24 gateway=10.10.30.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=WAN
/system clock
set time-zone-name=America/Sao_Paulo
/system note
set show-at-login=no
