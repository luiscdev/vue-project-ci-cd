# Se crea una imagen de node con la version lts-alpine
FROM node:lts-alpine as build

# Instala http-server para ejecutar el servidor web
# RUN npm install -g http-server

# Crea un directorio en el contenedor
RUN mkdir /app

# is the same as cd /app - significa que trabajara en ese directorio
WORKDIR /app

# Copia los archivos package.json y package-lock.json al directorio /app (El * es para copiar todos los archivos que empiecen con package)
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia todos los archivos del proyecto al directorio /app, el primer punto es el directorio actual y el segundo punto es el directorio del contenedor
COPY . .

# Compila el proyecto
RUN npm run build

FROM nginx:1.18.0-alpine

# Copia los archivos de tu sitio web a la ubicación predeterminada de Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Copia tu archivo de configuración personalizado de Nginx
# (opcional, si deseas usar una configuración personalizada)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expone el puerto 8080
EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]

CMD ["docker", "run", "-p", "5001:80",]

# EXPOSE 80
# ENV HOST=0.0.0.0

# CMD es para ejecutar un comando
# Ejecutar el servidor web, el directorio dist es donde se compila el proyecto
# CMD [ "http-server", "dist" ]