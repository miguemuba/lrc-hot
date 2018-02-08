#!/bin/bash
function clone-repo()
{
  git clone https://github.com/miguemuba/lrc-hot
}
function os-auth()
{
  read -p "Ingrese nombre de SSH-Key: " key
  read -p "Ingrese el nombre de usuario: " nom
  if [ -s ~/.ssh/$key ] && [ ! -f $nom ]; then
    read -p "Ingrese contraseña: " pass
    read -p "Ingrese direccion IPv4 de Servidor" controller
    echo "export OS_PROJECT_DOMAIN_NAME=default" >> $nom
    echo "export OS_USER_DOMAIN_NAME=default" >> $nom
    echo "export OS_PROJECT_NAME=admin" >> $nom
    echo "export OS_USERNAME="$nom >> $nom
    echo "export OS_PASSWORD="$pass >> $nom
    echo "export OS_AUTH_URL=http://"$controller":35357/v3" >> $nom
    echo "export OS_IDENTITY_API_VERSION=3" >> $nom
    echo "export OS_IMAGE_API_VERSION=2" >> $nom
    echo "Usted ha creado el archivo de autenticacion exitosamente."
    echo "Agregando servidor "$controller" en ubicacion /etc/hosts"
    sleep 3
    echo  $controller " controller" >> /etc/hosts
  else echo "Usted no ha creado aun su clave SSH";
  fi
}
function os-client-install()
{
  echo "Instalando Openstack-Cliente..."
  sudo apt-get -y update
  sudo apt-get -y install gcc libffi-dev libssl-dev python python-dev python-virtualenv virtualenvwrapper
  
}
function os-stack-create()
{
  read -p "Ingrese nombre de usuario: " nom
  read -p "Ingrese el nombre de key: " key
  if [ -f ~/.ssh/$key ]; then
    echo "A continuacion se va a desplegar un TP.";
    echo "Ingresar nombre de TP deseado usando nomenclatura tpN.";
    echo "Por ej, para TP N°1 ingresar 'tp1'";
    read -p "Ingrese nombre del TP a desplegar" tp;
    sed -i '6i \    \default: '$key $tp.yaml;
    sudo openstack stack create -t $tp.yaml $tp-$nom;
  else echo "Usted no ha creado aun su clave SSH.";
  fi
}
function os-stack-delete()
{
  #read -p "Ingrese nombre de usuario: " nom
  #read -p "Ingrese nombre de TP a eliminar: " tpd
  sudo openstack stack delete $tpd-$nom
}
function os-stack-show()
{
  read -p "Ingrese nombre de usuario: " nom
  read -p "Ingrese nombre de TP a mostrar: " tpi
  sudo openstack server list
}
function sshkey-create()
{
  read -p "Ingrese el nombre de SSH-Key: " key
  ssh-keygen -t rsa -f ~/.ssh/$key
}
function os-keypair()
{
  read -p "Ingrese nombre de SSH-Key: " key
  sudo openstack keypair create --public-key ~/.ssh/$key.pub $key
}
function os-cli()
{
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
  sudo mkvirtualenv os_cli
}
function os-auth-load()
{
  read -p "Ingrese nombre de usuario: " nom
  source $nom
  echo "Usted se ha autenticado exitosamente!"
}
function os-user-show()
{
  read -p "Ingrese nombre de usuario: " nom
  sudo openstack user show $nom
}
function menu()
{
  echo "###########################################################################"
  echo "#-----------LABORATORIO REDES DE COMPUTADORAS 2018------------------------"
  echo "#"
  echo "#    Instalando el entorno"
  echo "#       1.- Clonar Repositorio de Trabajos Practicos"
  echo "#       2.- Crear Key SSH"
  echo "#       3.- Crear autenticacion Openstack"
  echo "#       4.- Instalar entorno Openstack Cliente"
  echo "#"
  echo "#    Trabajando en el entorno"
  echo "#       5.- Desplegar Openstack Cliente"
  echo "#       6.- Cargar Autenticacion Openstack"
  echo "#       7.- Crear Keypair para instancias"                 
  echo "#       8.- Desplegar Trabajo Practico"
  echo "#       9.- Consulta Trabajo Practico"
  echo "#       10.- Eliminar Trabajo Practico"
  echo "#       11.- Consulta Usuario"
  echo "# "      
  echo "###########################################################################"
   
   read -p "Elegir opcion: " op
   
   case $op in
        1)
          clone-repo
        ;;
        2)
          sshkey-create
        ;;
        3)
          os-auth
        ;;
        4)
          os-client-install
        ;;
        5)
          os-cli
        ;; 
        6)
          os-auth-load
        ;;
        7)
          os-keypair
        ;;
	8)
	  os-stack-create
	;;
  9)
    os-stack-show
  ;;
  10)
     os-stack-delete
  ;;
  11)
     os-user-show
  ;;
	
         *)
           echo "Opcion Incorrecta! Por favor ingrese nuevamente la opcion de menú."    
    esac
}
menu
