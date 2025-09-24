FROM ubuntu:22.04

#variables de entorno
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

# Paquetes base
RUN apt-get update && apt-get install -y \
    curl wget ca-certificates gnupg lsb-release \
    git maven \
    openjdk-17-jdk \
    apache2 \
    postgresql postgresql-contrib \
    build-essential locales tzdata \
 && rm -rf /var/lib/apt/lists/*

# .NET SDK 8 (para compilar .NET / NetCore) 
# Repo oficial de Microsoft para Ubuntu 22.04
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O /tmp/msprod.deb \
 && dpkg -i /tmp/msprod.deb \
 && apt-get update && apt-get install -y dotnet-sdk-8.0 \
 && rm -rf /var/lib/apt/lists/* /tmp/msprod.deb

# VS Code (code-server)
# VS Code en el navegador (sin GUI).
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Apache "hola mundo"
RUN echo '<!doctype html><html><head><meta charset="utf-8"><title>Hola</title></head><body><h1>¡Hola mundo!</h1></body></html>' \
 > /var/www/html/index.html

# Puertos para apache, code-server y postgres
EXPOSE 80 8080 5432

# dir de trabajo
WORKDIR /workspace

# Comando por defecto: Apache en primer plano
CMD ["apache2ctl", "-D", "FOREGROUND"]
