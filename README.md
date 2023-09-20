# Laboratorio #2
Informe del Laboratorio #2 de Programación bajo plataformas abiertas.
Tema: Procesos y servicios
## Enunciado 1: información de un proceso
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
