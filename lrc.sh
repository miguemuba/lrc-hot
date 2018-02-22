#!/bin/bash
function clone-repo()
{
  git clone https://github.com/miguemuba/lrc-hot
}
function os-auth()
{
  read -p "Ingrese nombre de SSH-Key: " key
  if [ -s ~/.ssh/$key ]; then {
    read -p "Ingrese el nombre de usuario: " nom
      if [ ! -f $nom ]; then { 
        read -p "Ingrese contraseña: " pass
        read -p "Ingrese nombre de proyecto: " proj
        read -p "Ingrese la direccion IPv4 del servidor: " controller
        echo "export OS_PROJECT_DOMAIN_NAME=default" >> $nom
        echo "export OS_USER_DOMAIN_NAME=default" >> $nom
        echo "export OS_PROJECT_NAME="$proj >> $nom
        echo "export OS_USERNAME="$nom >> $nom
        echo "export OS_PASSWORD="$pass >> $nom
        echo "export OS_AUTH_URL=http://"$controller":35357/v3" >> $nom
        echo "export OS_IDENTITY_API_VERSION=3" >> $nom
        echo "export OS_IMAGE_API_VERSION=2" >> $nom
        echo "Usted ha creado el archivo de autenticacion exitosamente."
        echo "Agregando servidor "$controller" en ubicacion /etc/hosts"
        sleep 3
        echo  $controller " controller" >> /etc/hosts
        }
      else echo "Usted ya ha creado su autenticación Openstack."
      fi
      }
  else echo "Usted no ha creado aun su clave SSH.";
  fi
}
function os-client-install()
{
  echo "Instalando Openstack-Cliente..."
  sudo apt-get -y update
  sudo apt-get install python-dev python-pip
  sudo pip install --upgrade pip
  sudo pip install --upgrade setuptools
  sudo pip install python-openstackclient  
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
  while true; do
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
  12)
     echo "Salir del script"
     break
  ;;
	
         *)
           echo "Opcion Incorrecta! Por favor ingrese nuevamente la opcion de menú."    
   esac
  done  
}
menu
