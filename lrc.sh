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
        echo "---------------------------------------------------------"
        echo "Usted ha creado el archivo de autenticacion exitosamente."
        echo "---------------------------------------------------------"
        sleep 3  
        echo "Agregando servidor " $controller " en ubicacion /etc/hosts"
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
  sudo pip install python-heatclient
  echo "-------------------------------"
  echo "Finalizando Instalacion."
  echo "-------------------------------"
  sleep 3 
}
function os-stack-create()
{
  read -p "Ingrese nombre de usuario: " nom
  read -p "Ingrese el nombre de key: " key
  if [ -f ~/.ssh/$key ]; then {
    echo "A continuacion se va a desplegar un TP.";
    echo "Ingresar nombre de TP deseado usando nomenclatura tpN.";
    echo "Por ej, para TP N°1 ingresar 'tp1' ";
    read -p "Ingrese nombre del TP a desplegar : " tp;
    EXISTE=$(grep -ic "$key" tp1.yaml)
    if [ "$EXISTE" == 0 ]; then {
    sed -i '6i \    \default: '$key $tp.yaml;
    openstack stack create -t $tp.yaml $tp-$nom;
    }
    else openstack stack create -t $tp.yaml $tp-$nom;
    fi
  }
  else echo "Usted no ha creado aun su clave SSH.";
  fi
}
function os-stack-delete()
{
  read -p "Ingrese nombre de usuario: " nom
  read -p "Ingrese nombre de TP a eliminar: " tpd
  openstack stack delete $tpd-$nom
  sleep 3
}
function os-stack-show()
{
  read -p "Ingrese nombre de usuario: " nom
  read -p "Ingrese nombre de TP a mostrar: " tpi
  openstack server list |grep -o 192.168.0.* |awk '{print $1}' |sort
  sleep 3
}
function sshkey-create()
{
  read -p "Ingrese el nombre de SSH-Key: " key
  ssh-keygen -t rsa -f ~/.ssh/$key
  echo "-------------------------------"
  echo "Se ha creado la clave SSH."
  echo "-------------------------------"
  sleep 2
}
function os-keypair()
{
  read -p "Ingrese nombre de SSH-Key: " key
  openstack keypair create --public-key ~/.ssh/$key.pub $key
  echo "----------------------------------------"
  echo "Se ha creado el par de claves Openstack."
  echo "----------------------------------------"
}
function os-auth-load()
{
  read -p "Ingrese nombre de usuario: " nom
  source $nom
  echo "Usted se ha autenticado exitosamente!"
  sleep 4
}
function os-user-show()
{
  read -p "Ingrese nombre de usuario: " nom
  openstack user show $nom
  sleep 2
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
  echo "#       5.- Autenticacion Openstack" 
  echo "#       6.- Crear Keypair para instancias"                 
  echo "#       7.- Desplegar Trabajo Practico"
  echo "#       8.- Consulta Trabajo Practico"
  echo "#       9.- Eliminar Trabajo Practico"
  echo "#       10.- Consulta Usuario"
  echo "#       11.- Salir"     
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
          os-auth-load
        ;;
        6)
          os-keypair
        ;;
	7)
	  os-stack-create
	;;
  8)
    os-stack-show
  ;;
  9)
     os-stack-delete
  ;;
  10)
     os-user-show
  ;;
  11)
     echo "Salir del script"
     break
  ;;
	
         *)
           echo "Opcion Incorrecta! Por favor ingrese nuevamente la opcion de menú."    
   esac
  done  
}
menu
