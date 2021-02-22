======================================================================================================

 _____         _      _                                 _          ___  ______  _____      
|  __ \       | |    (_)                               | |        / _ \ | ___ \|_   _|     
| |  \/  ___  | |__   _   ___  _ __  _ __    ___     __| |  ___  / /_\ \| |_/ /  | |   ___ 
| | __  / _ \ | '_ \ | | / _ \| '__|| '_ \  / _ \   / _` | / _ \ |  _  ||  __/   | |  / __|
| |_\ \| (_) || |_) || ||  __/| |   | | | || (_) | | (_| ||  __/ | | | || |     _| |_ \__ \
 \____/ \___/ |_.__/ |_| \___||_|   |_| |_| \___/   \__,_| \___| \_| |_/\_|     \___/ |___/
                                                                                           
                                                                                           
== Prerequisitos ==
	
1. Instalacion de nodejs https://nodejs.org/es/

2. Configurar .npmrc para salir mediante un proxy al ejecutar instrucciones npm

Nota: Omite este paso si tu salida a internet no esta limitada mediante un proxy
	
	Ruta: E:\Users\usuario\.npmrc
	Si no existe el archivo se debe crear

	npm config set strict-ssl=false
	npm config set proxy=http://bxxxx:password@10.50.8.21
	npm config set https-proxy=http://bxxxxx:password@10.50.8.21
	npm config set noproxy=127.0.0.1 

== Instrucciones para la ejecucion de nuestro proyecto. ==

1. A nivel de esta carpeta debe de ejecutar el siguiente comando para iniciar la instalacion de las diferentes herramientas para crear pruebas de API´s:

Nota: Si "No" es la primera vez que usas este template continua con el paso 2
    
    > npm run start-api


2. Dentro de la carpeta "tests" ejecutamos el siguiente comando para correr nuestras pruebas:

    > gulp correrPruebas

	Pasos de la ejecución:

	- Inicia el servidor de apimocker con la información proporcionada en el archivo node/config-generated.json
   	En caso que el puerto proporcionado este ocupado cambiar por otro que este libre. 
   	Este cambio se debe de hacer en node/config-generated.json "port": "9000", así como tambien en el archivo tests/features/support/init.js

	- Realiza la limpieza de la carpeta donde se generan los reporte de las pruebas /tests/features/report

	- Se envian peticiones al servidor http de apimocker http://localhost:9000 con base a la definicion de los archivos Features
	ubicados en la carpeta tests/features

	- Genera reporte de pruebas en formato html (/tests/features/report), en el cual se muestra los escenarios que se ejecutaron de manera correcta, así como los que fallaron 

3. Para detener la ejecucion presiona "CTRL + C"

4. Para repetir las pruebas regresa al paso 2

======================================================================================================