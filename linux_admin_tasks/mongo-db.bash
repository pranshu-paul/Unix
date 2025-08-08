cat << EOF > /etc/yum.repos.d/mongodb.repo
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/6.0/x86_64/
gpgcheck=0
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
EOF

yum clean metadata

yum -y install mongodb-org

systemctl daemon-reload
systemctl start mongod.service
systemctl enable mongod.service
systemctl status mongod.service

mongosh
help
show databases