# Packages required. TOMCAT
glibc - i668 - x86_64
libstdc++ - i686 - x86_64

# Add a group for tomcat user.
groupadd tomcat

# Add a user for tomcat.
useradd -g tomcat -s /bin/bash tomcat

# Download OpenJDK.
curl -L https://download.java.net/openjdk/jdk8u43/ri/openjdk-8u43-linux-x64.tar.gz --output openjdk-8u43-linux-x64.tar.gz

# Download apache tomcat.
curl -L https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz --output apache-tomcat-9.0.80.tar.gz

# Set capabilities for the java executables to use the privilege ports as a standard user.
setcap cap_net_bind_service+ep /home/tomcat/tomcat9/java-se-8u43-ri/bin/java

# Check the capabilities assigned.
getcap /home/tomcat/tomcat9/java-se-8u43-ri/bin/java

# Add the custom java library path in the below file.
echo '/home/tomcat/java-se-8u43-ri/lib/amd64/jli' > /etc/ld.so.conf.d/custom-java.conf

# Verify the custom library.
ldconfig -v 2> /dev/null | grep -w libjli.so

# Export the required variables in ~/.bashrc.
export JAVA_HOME=/home/tomcat/tomcat9/java-se-8u43-ri
export JAVA_HOME=/home/tomcat/java-se-8u43-ri
export CATALINA_HOME=/home/tomcat/apache-tomcat-9.0.80
export PATH=$JAVA_HOME/bin:$CATALINA_HOME/bin:$PATH

PATH=$PATH:<conda-env>/lib/jvm/lib
export LIBRARY_PATH=/home/tomcat/tomcat9/jdk-11.0.19/lib/jli
export LD_LIBRARY_PATH=/home/tomcat/tomcat9/jdk-11.0.19/lib/jli
export JAVA_LD_LIBRARY_PATH=/home/tomcat/tomcat9/jdk-11.0.19/lib/jli

java -Djava.library.path=/home/tomcat/tomcat9/jdk-11.0.19/lib/jli