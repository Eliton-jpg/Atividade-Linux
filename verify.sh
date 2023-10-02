#!/bin/bash
#verifica se o serviço HTTP naquele tempo estava online
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
service_name="HTTPD"
#Caso esteja Online retorna a seguinte message
status="Online"
message="O serviço está ONLINE"
#Caso esteja offline
if ! systemctl is-active --quiet httpd; then
    status="Offline"
    message="O serviço está OFFLINE."
fi
# retorna em o arquivo .txt o tempo pego, o nome do serviço no caso HTTP
#O status ONLINE ou OFFLINE e a message
echo "$timestamp $service_name $status $message" /eliton/verify.txt
