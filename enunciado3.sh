#!/bin/bash

if [ $# -ne 1 ]; then #solo permite 1 parámetro pero podría hacerse con más
	echo "Uso: $0 <path a un ejecutable>" #se prueba con script de sleep
	exit 1
fi

ejecutable=$1 #path del ejecutable pasado
logfile="uso_cpu_mem.log" #archivo de log de uso de cpu y memoria
periodicidad=1 #intervalo de muestreo para el log, menor para mejor gráfica
$ejecutable & #ejecutar el ejecutable en el background mediante &, se debe matar sleep de prueba luego
pid=$! #obtener PID del proceso recién ejecutado usando variable $!
echo "HH:MM:SS %CPU %MEM" > "$logfile" #encabezado para el log, uso de recursos y hora exacta

while ps -p $pid > /dev/null; do #mientras el proceso exista se ejecuta ciclo infinito
	tiempo=$(date +"%H:%M:%S") #date sugerido en enunciado da hora exacta
	uso_cpu=$(ps -o %cpu= -p $pid) 
	uso_mem=$(ps -o %mem= -p $pid)
	echo "$tiempo $uso_cpu $uso_mem" >> "$logfile"
	sleep $periodicidad
done

gnuplot <<- EOF
	set terminal png
	set output "uso_recursos.png"
	set title "Histórico de consumo de CPU y de memoria"
	set xlabel "Hora"
	set ylabel "%"
	plot "$logfile" using 1:2 with lines title "CPU", "$logfile" using 1:3 with lines title "MEM"
EOF

