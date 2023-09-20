# Laboratorio #2
Informe del Laboratorio #2 de Programación bajo plataformas abiertas.
Tema: Procesos y servicios
## Enunciado 1: Información de un proceso
En términos generales para este primer script se hace uso del comando ps.
Luego de verificar que se pase únicamente 1 argumento en la línea de comando a la hora de ejecutar el script, lo primero que se hace es verificar que el process ID dado en el argumento exista, por medio de: ps -p PID
Si el proceso sí existe, se procede a extraer la información solicitada haciendo uso siempre del comando ps, pero esta vez además de -p (que sirve para indicar el número de proceso) se utiliza la opción '-o', que permite especificar opciones para extraer un dato en particular. Así, la información solicitada se obtiene de la siguiente forma:
1. la opción '-o comm=' da el únicamente el nombre del proceso, omitiendo los encabezados,
2. el PID es pasado en línea de comando y se guarda en una variable,
3. '-o ppid=' el PID del proceso padre,
4. '-o user=' el nombre del usuario propietario del proceso,
5. '-o %cpu=' el porcentaje de uso de CPU del proceso, '%mem=' el porcentaje de uso de la memoria del proceso y 'stat=' da el status del proceso. En todos los casos se debe especificar de seguido el PID con la opción -p.
6. Por otro lado, para obtener el path del archivo ejecutable del proceso de interés, se hace uso del comando readlink sugerido. De acuerdo con el help de este comando, éste imprime el valor de un enlace simbólico o nombre de archivo canónico. La opción -f permite "canonicalizar" mediante seguimiento de cada symlink en cada componente del nombre dado de manera recursiva. Según la investigación efectuada, se utliza para seguir todos los enlaces simbólicos y obtener la ruta completa del archivo ejecutable. De esta forma, se hace uso del pseudosistema /proc que contiene la información de los procesos mediante la convención en Linux dada por /proc/<PID>/exe, que proporciona el acceso al enlace simbólico que apunta al archivo ejecutable del proceso con el ID dado por <PID>. Así, para obtener el path del ejecutable se utiliza el comando 'readlink -f /proc/<PID>/exe'.
Los resultados de los comandos señalados se guardan en variables que se imprimen en pantalla con la indicación de a qué corresponden en cada caso, por medio del comando echo.
- El script se ejecuta con: './enunciado1.sh <PID>', donde los PID de prueba se pueden obtener con el comando 'ps'.
- Se debe recordar dar permisos de ejecución al script por medio de 'chmod +x enunciado1.sh'.
![Resultados script enunciado 1](https://raw.githubusercontent.com/mareyes1/Labo2/main/resultados_enunciado1.png)
## Enunciado 2: Monitoreo de un proceso
La solución implementada para automatizar el monitoreo de un proceso, recibiendo el nombre de éste y el comando para ejecutarlo, de forma que se revise periódicamente el estado del proceso y si se cierra volver a levantarlo, consistió en lo siguiente:
- Se utiliza el comando pgrep, el cual busca procesos en ejecución, para esto se usa la opción -x que busca por nombre exacto, de la forma: 'pgrep -x <NOMBRE>'. Con el nombre pasado por línea de comando, esta condición se evalúa y si es verdadera mediante un if se reporta en pantalla que el proceso está en ejecución.
- Si la salida del comando pgrep es falsa, se reporta que el proceso no se encuentra en ejecución y de seguido se procede a ejecutar el comando especificado para volver a levantar el proceso. Este comando se corre en el background haciendo uso de '&'.
- Nótese que el script asume que el comando pasado es correcto para el proceso indicado, esto no se revisa y podría ser una mejora al script.
- Para revisar periódicamente, se utiliza el comando sleep para esperar un determinado tiempo y volver a efectuar el monitoreo. Para probar la funcionalidad del script se utilizaron diferentes tiempos como 10 s, 30 s, 60 s y 100 s; entre otros. Como se indicará más adelante, para las pruebas también se utilizó el comando sleep, por lo que se puede jugar con los tiempos del script y del argumento, para que el pasado sea mayor o menor y así verificar la funcionalidad.
- Todas las verificaciones y levantamiento ante cierre del proceso se incluyen dentro de un ciclo infinito con el comando 'whiel true; do'. Para detener el monitoreo se debe ejecutar un Cntrl+C. Debido a esto se adicinó una función para detener el script de forma más controlada, haciendo un manejo por medio de las señales SIGINT y SIGTERM según las recomendaciones en la materia. Al salir de forma controlada se muestra un mensaje indicando que se detiene el monitoreo del proceso.
- La funcionalidad del script se verifica con el comando sleep, usando tiempos menores y mayores que el tiempo de espera interno del script, que se fijó en 10 s. Entonces se utilizan tiempos de 5 s y de 100 s. El script se ejecuta, entonces, de la siguiente forma: './enunciado2.sh sleep "sleep 100"' y se detiene con Cntrl+C.
![Resultados script enunciado 2](https://raw.githubusercontent.com/mareyes1/Labo2/main/resultados_enunciado2.png)
## Enunciado 3: Monitoreo del consumo de CPU y memoria
Se resuelve el monitoreo de consumo de CPU y memoria de la siguiente forma:
- Se almacena en una variable el path del ejecutable proporcionado, se asume que es correcto.
- Se crea un logfile para ir agregando los datos del histórico de consumo de recursos, se define una periodicidad de muestreo que para graficar de mejor forma se asume relativamente corta, por lo que se fija en 1 s. En el logfile se coloca un encabezad con los títulos de las columnas.
- Por medio de un ciclo while que se ejecuta mientras el proceso exista, se evalua dicha condición mediante el comando 'ps -p <PID>'.
- Mientras el proceso exista se extrae la información: primero con el comando date sugerido se obtiene el "timestamp" con la hora exacta de la muestra, y posteriormente el consumo de CPU y memoria de la misma forma que en el enunciado 1, con el comando 'ps -o' y con -p indicando el PID; estos valores se almacenan en variables que luego son vertidas en el logfile creado, por debajo del encabezado incialmente puesto, esto por medio del operador '>>' que agrega al final de un archivo.
- Se utiliza el comando sleep para esperar para la siguiente muestra por medio de una variable de $periodicidad definida afuera para no "hardcodear" el valor de muestre dentro del while.
- Para lo correspondiente a la gráfica con gnuplot se investigó acerca del código necesario, pero se presetaron errores a la hora de generar el archivo PNG pretendido. Se agrega el código que no está generando errores al correr. Se continuará revisando el código para adquirir el conocimiento.
- El código se prueba con el script prueba_enunciado_3.sh que consiste en un sleep 1. Este proceso se debe matar para salir.
- La información se registra correctamente en el logfile.
## Enunciado 4: Scripting y servicios
- Se monitorean los cambios en el directorio actual, i.e. './'
- Se crea un script en bash (enunciado4.sh) el cual por medio del comando inotifywait espera eventos, con la opción -e se le especifica cuáles eventos "escuche" en particular. En el script se ejecuta el comando inotififywait -e create,modify,delete -r ./ en un bucle infinito mediante un 'while true; do' y la salida se redirecciona al logfile previamente creado en el path /var/log que convencionalmente se usa para este fin. Cada vez que se detecta un cambio se agrega la fecha con 'date'.
- Se crea un servicio en /etc/systemd/system/monitoreo-lab2.service con base en el ejemplo dado.
- El servicio se debe habilitar con: sudo systemctl enable monitoreo-lab2.service
![Resultados script enunciado 2](https://raw.githubusercontent.com/mareyes1/Labo2/main/monitoreo-lab2.service.png)
- Luego se debe iniciar con: sudo systemctl start monitoreo-lab2.service
- Finalmente, se verifica el estado del servicio siempre con 'systemctl': sudo systemctl status monitoreo-lab2.service
![Resultados script enunciado 2](https://raw.githubusercontent.com/mareyes1/Labo2/main/service_status.png)
- La funcionalidad del comando inotifywait utilizado en el script de bash se verifica antes y después de implementar el servicio, por medio del logfile. Se elige el directorio actual para monitorear los cambios normales que ocurren mientras se trabaja, y también se crean archivos "dummy" para verificar la ejecución.
![Resultados script enunciado 2](https://raw.githubusercontent.com/mareyes1/Labo2/main/log_detectar_cambios.png)
