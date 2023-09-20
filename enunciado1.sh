#!/bin/bash

if [ $# -ne 1 ]; then #verifica que se pase 1 argumento
	echo "Uso: $0 <PID>"
	exit 1 
fi

pid=$1

if ! ps -p $pid &>/dev/null; then #verifica que el PID pasado exista
	echo "Error: El PID $pid no existe."
	exit 1
fi

#si el proceso existe, se extrae la información y se impime en pantalla
echo "****  INFORMACIÓN DEL PROCESO:  ****"
nombre=$(ps -o comm= -p $pid) #para obtener el nombre del proceso con ps se usa comm= con -o
echo "Nombre del proceso: $nombre"
echo "ID del proceso: $pid"
parent_process_id=$(ps -o ppid= -p $pid) #opción -o ppid extrae el parent process ID
echo "Parent process ID: $parent_process_id"
propietario=$(ps -o user= -p $pid)
echo "Usuario priopetario: $propietario"
uso_cpu=$(ps -o %cpu= -p $pid)
echo "Uso del CPU: $uso_cpu%"
consumo_memoria=$(ps -o %mem= -p $pid)
echo "Consumo de memoria: $consumo_memoria%"
estado=$(ps -o stat= -p $pid)
echo "Estado (status): $estado"
path_ejecutable=$(readlink -f /proc/$pid/exe) #extrae el path de /proc, /exe da enlace simbólico al ejecutable
echo "Path del ejecutable: $path_ejecutable"

