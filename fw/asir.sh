#ASI1

#Permitimos navegación
iptables -A FORWARD -p tcp -s 192.168.101.0/24 --sport 1024:65535 -m multiport --dports 80,443 -j ACCEPT
iptables -A FORWARD -p udp -s 192.168.101.0/24 --sport 1024:65535 --dport 53 -m state --state NEW -j ACCEPT
iptables -A FORWARD -d 192.168.101.0/24 -m state --state ESTABLISHED,RELATED -j ACCEPT

#Denegar acceso a Facebook e Instagram
iptables -I FORWARD 1 -p tcp -s 192.168.101.0/24 --dport 443 -m string --string 'facebook' --algo bm -j DROP
iptables -I FORWARD 1 -p tcp -s 192.168.101.0/24 --dport 443 -m string --string 'instagram' --algo bm -j DROP

#Impedir a pc02-asi1 (filtrando por su MAC) el acceso al servidor web de servus
#iptables -I FORWARD 1 -p tcp -m mac --mac-source 08:00:27:78:A8:67 -d 192.168.2.100 --dport 80 -j DROP

#ASI2

#Permitimos navegación
iptables -A FORWARD -p tcp -s 192.168.102.0/24 --sport 1024:65535 -m multiport --dports 80,443 -j ACCEPT
iptables -A FORWARD -p udp -s 192.168.102.0/24 --sport 1024:65535 --dport 53 -m state --state NEW -j ACCEPT
iptables -A FORWARD -d 192.168.102.0/24 -m state --state ESTABLISHED,RELATED -j ACCEPT
#Permitimos icmp desde asi2 a asi1
iptables -A FORWARD -s 192.168.102.0/24 -d 192.168.101.0/24 -p icmp -j ACCEPT
iptables -A FORWARD -d 192.168.102.0/24 -s 192.168.101.0/24 -m state --state RELATED,ESTABLISHED -p icmp -j ACCEPT

#DPTO

#Permitimos navegación
iptables -A FORWARD -p tcp -s 192.168.103.0/24 --sport 1024:65535 -m multiport --dports 80,443 -j ACCEPT
iptables -A FORWARD -p udp -s 192.168.103.0/24 --sport 1024:65535 --dport 53 -m state --state NEW -j ACCEPT
iptables -A FORWARD -d 192.168.103.0/24 -m state --state ESTABLISHED,RELATED -j ACCEPT

#Permitimos icmp de dpto a asi1
iptables -A FORWARD -s 192.168.103.0/24 -d 192.168.101.0/24 -p icmp -j ACCEPT
iptables -A FORWARD -d 192.168.103.0/24 -s 192.168.101.0/24 -m state --state RELATED,ESTABLISHED -p icmp -j ACCEPT

#Permitimos icmp de dpto a asi2
iptables -A FORWARD -s 192.168.103.0/24 -d 192.168.102.0/24 -p icmp -j ACCEPT
iptables -A FORWARD -d 192.168.103.0/24 -s 192.168.102.0/24 -m state --state RELATED,ESTABLISHED -p icmp -j ACCEPT

#Permitimos acceso ssh de dpto a asi1
iptables -A FORWARD -d 192.168.103.0/24 -s 192.168.101.0/24 -m state --state ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.168.103.0/24 -d 192.168.101.0/24 -p tcp --dport 22 -j ACCEPT

#Permitimos acceso ssh de dpto a asi2
iptables -A FORWARD -d 192.168.103.0/24 -s 192.168.102.0/24 -m state --state ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.168.103.0/24 -d 192.168.102.0/24 -p tcp --dport 22 -j ACCEPT
