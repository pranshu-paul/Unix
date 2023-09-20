# Installing docker on RHEL 8.

# Instal the dnf config-manager.
dnf install -y dnf-plugins-core

# Add the docker repo.
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Download the reqquired packages for docker.
dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker.
systemctl enable --now docker

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
