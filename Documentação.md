# Documentação Atividade AWS 
Para está atividade forá criada uma instancia com os seguintes requisitos: 
* Uma instancia EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD);
* Uma chave nomeada de mykey-compasso;
* Um Elastic-ip alocando ip público;
* Um Security-Group liberando acesso para as portas (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP);
* Uma infraestrutura de rede contendo, uma VPC, uma Sub-Net, uma Route Table e um Internet Gateway. 
# Documentação Atividade de Linux
Nesta atividade forá utilizada a máquina criada na atividade de AWS para fazer a inslação e configuração dos seguintes requisitos: 
* Servidor NFS(Network File System);
* Servidor Apache;
* Shell Script verificando o estado do servidor;
* Cron job para executar o escript a cada 5 minuto;
## NFS (Network Fiel System)
### Servidor NFS 
Após concectarse a instancia por meio do SSH foram executados os seguintes comando para a instalação do serviço NFS.

```bash
sudo yum install nfs-utils
```
Em seguida é nescessário criar o repositorio que será compartilhado em rede:
```bash
sudo mkdir /eliton
```
Após criar o repositorio é nescessário adicionalo ao /etc/exports onde será permitido exportar o repositorio:
```bash
sudo nano /etc/exports
```
Ao acessar digitamos o nome da pasta(/eliton) IP_com_quem_vamos_compartilhar(rw(para permitir a escrita),sync(para sincronizar as alteraçãoes feitas),no_root_squash(para negar o acesso de administrado dentro da pasta))
```bash
/eliton 0.0.0.0(rw,sync,no_root_squash)
```
### Cliente NFS
Para o cliente foi criada outra instancia EC2 com os mesmos requisitos, reaproveitando a infra de rede e alocando outro elastic IP.
No cliente também é preciso instalar o serviço de NFS
```bash
sudo yum install nfs-utils
```
Para acessar a pasta compartilhada com o cliente é necessario usar o seguinte comando:
```bash
sudo mount -t nfs SERVER_IP:/eliton /eliton
```
Os parametros passados foram o ip do servidor para poder conectar se a ele, a pasta que foi compartilhada no servidor no caso /eliton e a pasta do cliente que vai receber os arquivos da pasta compartilhada pelo servidor que foi /eliton também para padronizar.
No meu caso estava tendo erro ao reiniciar a instancia, pois tive que executar o comando acima toda vez que a iniciava, então encontrei a seguinte solução. 
Acessei o arquivo /etc/rc.local que é responsavel por executar comandos na inicialização do sistema 
```bash
sudo nano /etc/rc.local
```
Escrevi meu comando neste arquivo logo antes de exit 0, em seguida reiniciei a instancia resolvendo meu problema:
```bash
#!/bin/bash
sudo mount -t nfs SERVER_IP:/eliton /eliton
exit 0
```
## Servidor Apache
Para instalar, executar e verificar o apache é preciso executar os seguintes comanados 

```bash
#Intalação
sudo yum install httpd
```
```bash
#Inicialização 
sudo systemctl start httpd.service
```
```bash
#Verificação
sudo systemctl status httpd.service
```
## Shell Script
Nesta etapa da atividade foi preciso cirar um script que verifica se o serviço apacahe está online ou offline e retornalo em um arquivo `.txt`

```bash
#!/bin/bash
#Para ajustar a time zone de Virgina para a time zone de Fortaleza
export TZ=America/Fortaleza
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

```
## Cron job
Antes de cirar o cron job é necessario dar permição de execução para o arquivo `.sh`.
```bash
sudo chmod +x /eliton/verify.sh
```
Em seguida é preciso adicionar o cron job na cron tab:
```bash
sudo crontab -e
```
Na crontab adicionamos
```bash
*/5 * * * * /bin/bash /eliton/verify.sh

```
No comando acima estamos executando o script de verificação a cada 5 minutos(0, 5, 10, 15... 55).





