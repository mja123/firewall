#! /bin/bash

#2- Limpiar las tablas NAT y FILTER
iptables -F
iptables -t nat -F
#3- Definir las políticas por defecto del Firewall
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
#4- Resolver DNS en el Firewall
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
#5- Crear una regla de NAT para los usuarios de la red LAN GERENCIAL para salir a Internet  por eth0
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -j MASQUERADE
#6- Crear una regla de NAT para los usuarios de la red LAN EMPLEADOS para salir a Internet por eth1
iptables -t nat -A POSTROUTING -s 10.10.1.0/24 -j SNAT --to-source 200.13.186.155
#7- Filtrar el tráfico permitido y no permitido de los usuarios de la redes LAN GERENCIAL y LAN EMPLEADOS
#LAN Gerencial: HTTP, HTTPS, SSH y FTP habilitados, resto de los servicios deshabilitados
iptables -A FORWARD -m multiport -i eth3 -p tcp --dports 80,443,22,21 -j ACCEPT
iptables -A FORWARD -m multiport -d 172.16.1.1 -p tcp --dports 80,443,22,21 -j ACCEPT
iptables -A FORWARD -i eth3 -j DROP
#LAN Empleados: HTTP y HTTPS habilitados, resto de los servicios deshabilitados
iptables -A FORWARD -m multiport -s 10.10.1.0/24 -p tcp --dports 80,443 -j ACCEPT
iptables -A FORWARD -m multiport -o eth4 -p tcp --dports 80,443 -j ACCEPT
iptables -A FORWARD -i eth4 -j DROP
#8- Crear las reglas de NAT (DNAT) para la Zona Desmilitarizada (DMZ). Tener en cuenta tráfico entrante por eth0 y eth1 destinado al puerto 80 (HTTP Web Server).
iptables -t nat -A PREROUTING -p tcp --dport 80 -i eth0 -j DNAT --to-destination 192.168.2.1
iptables -t nat -A PREROUTING -p tcp --dport 80 -i eth1 -j DNAT --to-destination 192.168.2.1
#9- Crear reglas de filtrado que permitan el tráfico entre las subredes 172.16.1.0/24 y la 10.10.1.0/24
iptables -A FORWARD -s 10.10.1.0/24 -d 172.16.1.0/24 -j ACCEPT
iptables -A FORWARD -d 10.10.1.0/24 -s 172.16.1.0/24 -j ACCEPT
#10- Como haría para evitar que las subredes internas no hagan ping al Firewall?
iptables -A INPUT -p icmp -s 10.10.1.0/24 -j DROP
iptables -A INPUT -p icmp -s 172.16.1.0/24 -j DROP
#11- Como haría para que los usuarios de las distintas subredes puedan hacer ping entre si, pero no entre las dos subredes?
iptables -A FORWARD -p icmp -s 172.16.1.0/24 -d 10.10.1.0/24 -j DROP
iptables -A FORWARD -p icmp -d 172.16.1.0/24 -s 10.10.1.0/24 -j DROP
iptables -A FORWARD -i eth3 -o eth3 -p icmp -j ACCEPT
iptables -A FORWARD -i eth4 -o eth4 -p icmp -j ACCEPT
