# Installing docker on RHEL 8.

# Instal the dnf config-manager.
dnf install -y dnf-plugins-core

# Add the docker repo.
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Download the reqquired packages for docker.
dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker.
systemctl enable --now docker

# Prints the docker version
docker --version

# Directory of docker.
/var/lib/docker

# Create a seperate user and add the user in the "docker" group.
usermod -aG docker paul

# Pull the MySQL image from the repositary of Docker.
docker pull mysql

# Create a container for mysql.
docker run -d --name <any_container_name> -e MYSQL_ROOT_PASSWORD=<any_password> -p <host_port>:3306 mysql
docker run -d --name mysql_container -e MYSQL_ROOT_PASSWORD=Mysql#459 -p 3306:3306 mysql

# List the running machines.
docker ps

# Enter into the container's shell.
docker exec -it <contianer_name> bash
docker exec -it mysql_container bash

# Inside the container.
# First connect MySQL from outside the container, than we will be able to connect from inside the container.
mysql -u root -p

# From outside the docker.
# Run the below command.
mysql -h 0.0.0.0 -P 3306 -u root -p

# To create a docker network.
docker network create mysql_network

# To connect the docker network to the already running image.
docker network connect mysql_network mysql_container
docker network connect mysql_network mysql_container_1




#############################
# List docker images.
docker images

# Search for the official images only.
docker search --filter is-official=true <image_name>

# Pull an image of a specific version.
docker pull <image_name>:<version_name>

# Create an image.
docker create <image_name>

# List all the running containers
docker ps -as

# Start a container.
docker run <image_name>

# Run a command in the container.
docker run <image_name> <command>

# Bootstrap a container
docker run -it <image_name> <command>

docker run -it --name <new_container_name> <image_name> <command>

# Execute a command in a container.
docker exec -it <image_name> <command>

docker attach
docker detach


docker inspect jq

# Remove a docker container.
docker rm <contianer_name>

docker rm $(docker ps -a -q -l -f status=exited)

docker ps -a -q -l -f status = running

docker ps -a -f name=python1

# Binding a local directory to a container.
# Persistance volume creation
docker run -it -v <local_directory>:<container_path> <image> <command>

# -w container working directory.
docker run -it -v <local_directory>:<container_path> -w <container_path> <image> <command>
docker run -it -v <local_directory>:<container_path> -w <container_path> <image> <script.sh>

curl $(docker inspect $(docker ps -q) | jq -r .[0].NetworkSettings.IPAdress):5000

curl $(docker inspect $(docker ps -q -l) | jq -r .[0].NetworkSettings.IPAdress)


docker run -d --publish 5000 -v <local_directory>:<container_path> -w <container_path> <command> <argument>

# Docker file syntax.
<< EOF
FROM <image_name>

COPY <local_directory> <container_path>

WORKDIR <container_path>

RUN <container_command>

EXPOSE <local_port>

ENTRYPOINT [ "<name>" ]

CMD [ "<name>" ]

# Healthcheck docker file.
FROM <image_name>

COPY <local_directory> <container_path>

WORKDIR <container_path>

RUN <container_command>

EXPOSE <local_port>

ENTRYPOINT [ "<name>" ]

HEALTHCHECK --interval=5s --timeout=3s CMD curl -f http://localhost:5000 || nc -zv localhost 5000 || exit 1

CMD [ "<name>" ]
EOF


# To pause a container.
docker pause $(docker ps -l -q)
docker kill $(docker ps -l -q)

# Archive a container
docker save -o <backup_name>.tar <contianer_name>

# Load a container from the archive.
docker load -i dev.tar

docker export --output="test.tar" $(docker ps -l -q)

docker import <compress_name>.tar <image_name>:<container_name>

docker run -dp <local_port>:<container_port> <image_name>:<container_name>

docker volume rm infrastructure_postgres-vol


FROM postgres

# Add the postgre schema sql in the below directory.
COPY /docker-entrypoint-initdb.d/

docker-compose up --build -d

docker exec -it postgres psql -d <db_name> -U <username>

# To execute a command in the container.
docker exec -it postgres psql -d <db_name> -U <username> -c "\dt"


# Postgrest environment variables.
PGRST_DB_URI=postgres://<schema>:<username>@postgres:5432/<db_name>
PGRST_DB_ANON_ROLE=<username>
PGRST_DB_SCHEMA=<schema name>

