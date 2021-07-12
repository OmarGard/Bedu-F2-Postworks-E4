# ##########################################################################
#                         Sesion_7 postwork
# ##########################################################################

# Alojar un fichero a un local host de MongoDB

# OBJETIVO
# Realizar el alojamiento de un fichero .csv a una base de datos (BDD), en un local host de Mongodb a través de R
# REQUISITOS
# Mongodb Compass
# librerías mongolite
# Nociones básicas de manejo de BDD
# DESARROLLO
# Utilizando el manejador de BDD Mongodb Compass (previamente instalado), deberás de realizar las siguientes acciones:
#   
# 1. Alojar el fichero match.data.csv en una base de datos llamada match_games, nombrando al collection como match
# 
# 2. Una vez hecho esto, realizar un count para conocer el número de registros que se tiene en la base
# 
# 3. Realiza una consulta utilizando la sintaxis de Mongodb en la base de datos, para conocer el número de goles que metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió ó fue goleada?
#   
# 4. Por último, no olvides cerrar la conexión con la BDD
library(mongolite)

# Realizamos la conexión a nuestro cluster a la bd match_games y match una vez importados los datos
mongo_conn <- mongo(collection = "match", db="match_games", url="mongodb+srv://mongouser0:o0V7HJaBhYtKgM7N@cluster0.t5c60.mongodb.net/test")
# Obtenemos el número de registros con count 
mongo_conn$count()
# [1] 3800

# Obtenemos la query del partido del Real Madrid el 20 de diciembre de 2015
query <- mongo_conn$find(
  query='{
  "date":"2015-12-20", 
  "$or":[{"home.team":"Real Madrid"},{"away.team":"Real Madrid"}]
  }'
)

# Nos regresa un data.frame que podemos manipular
class(query)
#[1] "data.frame"

# Podemos ver que el real madrid metió 10 goles contra el Rayo Vallecano
query
#         date   home.team home.score away.team away.score
# 1 2015-12-20 Real Madrid         10 Vallecano          2


# Por último cerramos la conexión
mongo_conn$disconnect()
