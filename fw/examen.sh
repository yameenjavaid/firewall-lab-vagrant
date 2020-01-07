if [ -z $1 ]; then
    echo "Es necesario el primer argumento"
    exit
elif [ $1 != "start" ] && [ $1 != "stop" ]; then
    echo "El primer argumento debe contener la cadena \"start\" (comienza el examen) o la cadena \"stop\" (termina el examen)"
    exit
elif [ $1 = "start" ]; then
    iptables -C FORWARD -s 192.168.101.0/24 -d 192.168.102.100 -p tcp --dport 80 -j DROP > /dev/null 2>&1 
    start=$?
    if [ $start -eq 0 ]; then
        echo "Empieza el examen. Ahora no se permite ni navegar ni el acceso a Servus"
    else
        iptables -I FORWARD 1 -s 192.168.101.0/24 -d 192.168.102.100 -p tcp --dport 80 -j DROP
        iptables -I FORWARD 1 -s 192.168.102.0/24 -d 192.168.102.100 -p tcp --dport 80 -j DROP
        iptables -I FORWARD 1 -p tcp -s 192.168.101.0/24 --sport 1024:65535 -m multiport --dports 80,443 -j DROP
        iptables -I FORWARD 1 -p tcp -s 192.168.102.0/24 --sport 1024:65535 -m multiport --dports 80,443 -j DROP
        echo "Empieza el examen. Ahora no se permite ni navegar ni el acceso a Servus"
    fi
elif [ $1 = "stop" ]; then
    iptables -C FORWARD -s 192.168.101.0/24 -d 192.168.102.100 -p tcp --dport 80 -j DROP > /dev/null 2>&1 
    stop=$?
    if [ $stop -eq 0 ]; then            
        iptables -D FORWARD -s 192.168.101.0/24 -d 192.168.102.100 -p tcp --dport 80 -j DROP
        iptables -D FORWARD -s 192.168.102.0/24 -d 192.168.102.100 -p tcp --dport 80 -j DROP
        iptables -D FORWARD -p tcp -s 192.168.101.0/24 --sport 1024:65535 -m multiport --dports 80,443 -j DROP
        iptables -D FORWARD -p tcp -s 192.168.102.0/24 --sport 1024:65535 -m multiport --dports 80,443 -j DROP
        echo "Finaliza el examen. Ahora se permite navegar y el acceso a Servus"
    else
        echo "Finaliza el examen. Ahora se permite navegar y el acceso a Servus"
    fi
fi
