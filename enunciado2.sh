#!/bin/bash

if [ $# -ne 2 ]; then #verifica que se pasen 2 parámetros
	echo "Uso: $0 <nobre del proceso> <comando para ejecutarlo>" #mensaje de error sobre uso del script
	exit 1 #salida con código de error estándar
fi

nombre="$1"
comando="$2"

while true; do #se evalúa indefinidamente hasta que sea interrumpido externamente
	if pgrep -x "$nombre" >/dev/null; then #pgrep busca procesos en ejecución, -x con nombre exacto
		echo "El proceso $nombre se está ejecutando..."
	else #si la salida del pgrep es false entonces el proceso no está en ejecución
		echo "El proceso $nombre se ha cerrado, se procederá a levantarlo de nuevo..."
		$comando & #levanta proceso en el background, asume que comando es correcto
		echo "El proceso $nombre se está ejecutando, levantado nuevamente con: $comando..."
	fi
	sleep 10 #tiempo de espera para reevaluar, se varía para pruebas usando sleep de entrada
done
