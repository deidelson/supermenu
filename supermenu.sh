#!/bin/bash
#------------------------------------------------------
# PALETA DE COLORES
#------------------------------------------------------
#setaf para color de letras/setab: color de fondo
	red=`tput setaf 1`;
	green=`tput setaf 2`;
	blue=`tput setaf 4`;
	bg_blue=`tput setab 4`;
	reset=`tput sgr0`;
	bold=`tput setaf bold`;
#------------------------------------------------------
# VARIABLES GLOBALES
#------------------------------------------------------
#Cuando lo cambien dejen comentado 
#proyectoActual="/home/maxphoenix/Documents/GitHub/TPSOR/supermenu"
#proyectoActual="/home/hall/proyectos/supermenu"
directorio=$(eval "pwd");
proyectoActual=$directorio;
proyectos=$(eval "pwd")'/repos.txt';

#------------------------------------------------------
# DISPLAY MENU
#------------------------------------------------------
imprimir_menu () {
       imprimir_encabezado "\t  S  U  P  E  R  -  M  E  N U ";
	
    echo -e "\t\t El proyecto actual es:";
    echo -e "\t\t $proyectoActual";
    
    echo -e "\t\t";
    echo -e "\t\t Opciones:";
    echo "";
    echo -e "\t\t\t a.  Ver estado del proyecto";
    echo -e "\t\t\t b.  Guardar cambios";
    echo -e "\t\t\t c.  Actualizar repo";
    echo -e "\t\t\t d.  Cambiar proyecto";        
    echo -e "\t\t\t e.  Agregar proyecto nuevo";        
    echo -e "\t\t\t q.  Salir";
    echo "";
    echo -e "Escriba la opción y presione ENTER";
}

#------------------------------------------------------
# FUNCTIONES AUXILIARES
#------------------------------------------------------





imprimir_encabezado () {
    clear;
    #Se le agrega formato a la fecha que muestra
    #Se agrega variable $USER para ver que usuario está ejecutando
    echo -e "`date +"%d-%m-%Y %T" `\t\t\t\t\t USERNAME:$USER";
    echo "";
    #Se agregan colores a encabezado
    echo -e "\t\t ${bg_blue} ${red} ${bold}--------------------------------------\t${reset}";
    echo -e "\t\t ${bold}${bg_blue}${red}$1\t\t${reset}";
    echo -e "\t\t ${bg_blue}${red} ${bold} --------------------------------------\t${reset}";
    echo "";
}

esperar () {
    echo "";
    echo -e "Presione enter para continuar";
    read ENTER ;
}

malaEleccion () {
    echo -e "Selección Inválida ..." ;
}

decidir () {
	echo $1;
	while true; do
		echo "desea ejecutar? (s/n)";
    		read respuesta;
    		case $respuesta in
        		[Nn]* ) break;;
       			[Ss]* ) eval $1
				break;;
        		* ) echo "Por favor tipear S/s ó N/n.";;
    		esac
	done
}

imprimirRepos(){
	cat $proyectos
}

limpiarPantalla(){
	eval "clear"
}

cambiarActual(){
	num=$1" -"
	valor="cat $proyectos | grep -w $num"
	if eval $valor; then
		#guardo el resultado en una variable
		intermedio=$(eval $valor)
		#le quito el numero y el guion
		proyectoActual=${intermedio##* - }
		espacio
		echo "El proyecto seleccionado es: $proyectoActual"
	else
		echo Ese directorio no existe
		echo "El proyecto seleccionado es: $proyectoActual"
	fi
}

espacio(){
	echo 
	echo 
}
agregar_Repo(){
	actuales=$(cantLineas)
        ultimaLinea=$(($actuales + 1))
	linea="$ultimaLinea - $1"
	echo "$linea" >> $proyectos
	}


cantLineas () {
	cat "$proyectos" | wc -l
}

damePath(){
        sed -n "${1}{p;q;}" $proyectos
      
}

getPWD(){
  pwd;
}

#------------------------------------------------------
# FUNCTIONES del MENU
#------------------------------------------------------
a_funcion () {
    	imprimir_encabezado "\tOpción a.  Ver estado del proyecto";
    	decidir "cd $proyectoActual; git status";}

b_funcion () {
      	imprimir_encabezado "\tOpción b.  Guardar cambios";
	decidir "cd $proyectoActual; git add -A"
	echo "Ingrese un mensaje para el commit: "
	read mensaje
	git commit -m "$mensaje"
	decidir "echo ¿Desea pushear al repositorio?; git push origin master"
	
}


c_funcion () {
      	imprimir_encabezado "\tOpción c.  Actualizar repo";
      	decidir "echo ¿Desea actualizar el repositorio local?; git pull origin master"   	  
}

d_funcion () {
	imprimir_encabezado "\tOpción d.  Cambiar proyecto";
	imprimirRepos
	espacio
	echo "El proyecto seleccionado es: $proyectoActual"
	espacio
	echo "Ingrese el numero del proyecto que desea utilizar: "
	read utilizar
	cambiarActual $utilizar
}


e_funcion () {
	imprimir_encabezado "\tOpción e.  Agregar proyecto nuevo"; 
	echo "Ingrese la direccion del proyecto a agregar:  "
	read direccion

        decidir "echo ¿Desea Agregar Repositorio?; agregar_Repo $direccion";
		ultimaLinea=$(cantLineas)
        nombre=$(damePath $ultimaLinea)
	echo "Repositorio Agregado: "
	echo $nombre
	    
	
	 	
	
	
	#completar
}





#------------------------------------------------------
# LOGICA PRINCIPAL
#------------------------------------------------------
while  true
do
    # 1. mostrar el menu
    imprimir_menu;
    # 2. leer la opcion del usuario
    read opcion;
    
    case $opcion in
        a|A) a_funcion;;
        b|B) b_funcion;;
        c|C) c_funcion;;
        d|D) d_funcion;;
        e|E) e_funcion;;
        q|Q) break;;
        *) malaEleccion;;
    esac
    esperar;
done
 
