#!/bin/bash
IPTABLES="/sbin/iptables"
# интерфейс, смотрящий в локальную сеть
LAN=enp0s8
# интерфейс, смотрящий "наружу"
WAN=enp0s3

# очищаем правила
${IPTABLES} -F
${IPTABLES} -X
${IPTABLES} -F -t nat
${IPTABLES} -F -t mangle
${IPTABLES} -t nat -X
${IPTABLES} -t mangle -X

# запрещено все, что не разрешено
${IPTABLES} -P INPUT DROP
${IPTABLES} -P OUTPUT DROP
${IPTABLES} -P FORWARD DROP

# разрешаем подключение на loopback
${IPTABLES} -A INPUT -i lo -j ACCEPT
${IPTABLES} -A OUTPUT -o lo -j ACCEPT

# разрешаем доступ в (из) локальную сеть
${IPTABLES} -A INPUT -i ${LAN} -j ACCEPT
${IPTABLES} -A OUTPUT -o ${LAN} -j ACCEPT

# разрешаем входящие и исходящие подключения сервера
${IPTABLES} -A INPUT -i ${WAN} -j ACCEPT
${IPTABLES} -A OUTPUT -o ${WAN} -j ACCEPT

# открываем порты
${IPTABLES} -A INPUT -p tcp --dport 21 -j ACCEPT # FTP
${IPTABLES} -A INPUT -p tcp --dport 22 -j ACCEPT # SSH
${IPTABLES} -A INPUT -p tcp --dport 80 -j ACCEPT # HTTP
${IPTABLES} -A INPUT -p tcp --dport 443 -j ACCEPT # HTTPS
