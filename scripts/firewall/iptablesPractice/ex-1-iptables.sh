#! /bin/bash

#. En un router con política por defecto DROP en la cadena FORWARD, introduce reglas que permitan a los equipos de la red 10.20.0.0/16 realizar consultas de DNS
#. El servidor de DNS autorizado será el 8.8.8.8. No se permitirá realizar consultas con IP de origen fals
#. Los puertos que utilizan los clientes pueden ir de 1024 a 65535. (Nota: piensa tanto en la ida como en la vuelta).i

iptables -F 

iptables -P FORWARD DROP

iptables -A FORWARD -s 192.168.100.248/6 -d 8.8.8.8 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -d 192.168.100.248/6 -s 8.8.8.8 -p udp --sport 53 --dport 1024:65535 -j ACCEPT


#¿Cómo prohibir todo el tráfico TCP que entra por la interfaz eth1 y que va a la red 10.20.0.0/16?
iptables -A FORWARD -i eth1 -d 10.20.0.0/16 -p tcp -j REJECT
#¿Cómo prohibir todo el tráfico TCP que se origine en mi máquina y vaya  a la máquina 10.20.30.40? �
iptables -A OUTPUT -p tcp -d 10.20.30.40 -j REJECT
#� ¿Cómo prohibir todo el tráfico hacia la máquina con dirección IP 2.3.4.5 excepto las conexiones ssh? 
iptables -A OUTPUT -d 2.3.4.5 -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -d 2.3.4.5 -j REJECT
