#!/bin/bash

#bucle infinito para detectar cambios en directorio
#se debe crear previamente /var/log/monitoreo-lab2.log, convención en esa ubicación para logs
while true; do #con inotifywait se espera eventos, -e especifica cuáles eventos escucha
	inotifywait -e create,modify,delete -r ./ >> /var/log/monitoreo-lab2.log #monitorea dir actual
	echo "$(date) --> Cambio detectado" >> /var/log/monitoreo-lab2.log #logea timestamp de cambio
done
