apt update

vi /boot/firmware/cmdline.txt
group_memory=1 cgroup_enable=memory

curl -sfL https://get.k3s.io | sh -

kubectl get nodes

kubectl create namespace mysql-lab

kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
  namespace: mysql-lab
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
EOF

kubectl get pvc -n mysql-lab

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql1
  namespace: mysql-lab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql1
  template:
    metadata:
      labels:
        app: mysql1
    spec:
      containers:
      - name: mariadb
        image: mariadb:11.1
        env:
        - name: MARIADB_ROOT_PASSWORD
          value: "rootpass"
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pvc
EOF


kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-replica
  namespace: mysql-lab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql-replica
  template:
    metadata:
      labels:
        app: mysql-replica
    spec:
      containers:
      - name: mariadb
        image: mariadb:11.1
        env:
        - name: MARIADB_ROOT_PASSWORD
          value: "rootpass"
        - name: MARIADB_REPLICATION_MODE
          value: "slave"
        - name: MARIADB_REPLICATION_USER
          value: "repl"
        - name: MARIADB_REPLICATION_PASSWORD
          value: "replpass"
        - name: MARIADB_MASTER_HOST
          value: "mysql1.mysql-lab.svc.cluster.local"
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: mysql-replica-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-replica-storage
        persistentVolumeClaim:
          claimName: mysql-replica-pvc
EOF

kubectl edit deployment mysql1 -n mysql-lab

<<EOF
    spec:
      containers:
      - args:
        - --server-id=1
        - --log-bin=mysql-bin
        - --binlog-format=ROW
EOF

kubectl edit deployment mysql-replica -n mysql-lab

<<EOF
      - args:
        - --server-id=2
        - --log-bin=mysql-bin
        - --binlog-format=ROW
EOF

kubectl get pods -n mysql-lab

kubectl rollout restart deployment mysql1 -n mysql-lab

# On the master node
CREATE USER 'repl'@'%' IDENTIFIED BY 'replpass';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
SHOW MASTER STATUS;


# On the slave node
STOP SLAVE;
CHANGE MASTER TO
  MASTER_HOST='mysql1.mysql-lab.svc.cluster.local',
  MASTER_USER='repl',
  MASTER_PASSWORD='replpass',
  MASTER_LOG_FILE='mysql-bin.000001',
  MASTER_LOG_POS=766;
START SLAVE;
SHOW SLAVE STATUS\G

kubectl exec -i -n mysql-lab mysql1-798f4b8669-6x4f9 -- mariadb -u root -prootpass < hr.sql

kubectl exec -it -n mysql-lab mysql1-798f4b8669-6x4f9 -- mariadb -u root -prootpass

kubectl exec -it -n mysql-lab mysql-replica-5b86994f5b-h87c9 -- mariadb -u root -prootpass

kubectl scale deployment mysql1 -n mysql-lab --replicas=0

kubectl scale deployment mysql1 -n mysql-lab --replicas=1