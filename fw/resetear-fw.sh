#Flush  reglas
iptables -F INPUT
iptables -F FORWARD
iptables -F OUTPUT

#Flush cadenas
iptables -X

#Flush contador de paquetes y bytes
iptables -Z

#Flush de la tabla NAT
iptables -t nat -F

#Salida de las subredes a Internet
iptables -t nat -A POSTROUTING -s 192.168.101.0/24 -d 0/0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.102.0/24 -d 0/0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.103.0/24 -d 0/0 -j MASQUERADE

#Política por defecto ACCEPT (por si antes estaba a DROP)
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

#Preguntar política por defecto deseada
echo -e "¿Política por defecto?"
read p
iptables -P INPUT $p
iptables -P FORWARD $p
iptables -P OUTPUT $p
netfilter-persistent save > /dev/null 2>&1
echo -e "Politica por defecto definida: "$p

if [ -z $1 ]; then
    echo "Es necesario el primer argumento"
    exit
elif [ $1 != "i" ] && [ $1 != "o" ]; then
    echo "El primer argumento debe contener el caracter \"i\" (input) o el caracter \"o\" (output)"
    exit
elif [ $1 = "i" ]; then
    iptables -C INPUT -p tcp --dport 22 -j ACCEPT > /dev/null 2>&1
    drop=$?
    if [ -z $2 ]; then
        echo "Es necesario el segundo argumento"
        exit
    elif [ $2 != "a" ] && [ $2 != "d" ]; then
        echo "El segundo argumento debe contener el caracter \"a\" (accept) o el caracter \"d\" (drop)"
        exit
    elif [ $2 = "d" ]; then
        if [ $drop -eq 0 ]; then
            iptables -D INPUT -p tcp --dport 22 -j ACCEPT
            iptables -D OUTPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
            echo "Ahora no se permite input (desde donde sea) y output (para conexiones establecidas) ssh"
        else
            echo "Ahora no se permite input (desde donde sea) y output (para conexiones establecidas) ssh"
        fi
    elif [ $2 = "a" ]; then
        if [ $drop -eq 0 ]; then
            echo "Ahora se permite input (desde donde sea) y output (para conexiones establecidas) ssh"
        else
            iptables -A INPUT -p tcp --dport 22 -j ACCEPT
            iptables -A OUTPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
            echo "Ahora se permite input (desde donde sea) y output (para conexiones establecidas) ssh"
        fi
    fi
elif [ $1 = "o" ]; then
    iptables -C INPUT -m state --state ESTABLISHED -j ACCEPT > /dev/null 2>&1 
    drop=$?

    if [ -z $2 ]; then
        echo "Es necesario el segundo argumento"
        exit
    elif [ $2 != "a" ] && [ $2 != "d" ]; then
        echo "El segundo argumento debe contener el caracter \"a\" (accept) o el caracter \"d\" (drop)"
        exit
    elif [ $2 = "d" ]; then
        if [ $drop -eq 0 ]; then
            iptables -D INPUT -m state --state ESTABLISHED -j ACCEPT
            iptables -D OUTPUT -p tcp --dport 22 -j ACCEPT
            echo "Ahora no se permite output (a donde sea) e input (para conexiones establecidad) ssh"
        else
            echo "Ahora no se permite output (a donde sea) e input (para conexiones establecidad) ssh"
        fi
    elif [ $2 = "a" ]; then
        if [ $drop -eq 0 ]; then
            echo "Ahora se permite output (a donde sea) e input (para conexiones establecidad) ssh"
        else
            iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
            iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
            echo "Ahora se permite output (a donde sea) e input (para conexiones establecidad) ssh"
        fi
    fi
fi

netfilter-persistent save > /dev/null 2>&1
echo -e "Configuración de iptables guardada."
