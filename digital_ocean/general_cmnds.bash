doctl compute droplet-action power-on 366586120
doctl compute droplet-action power-off 366586120


doctl compute image create freebsd --region nyc3 --image-url http://150.230.237.232:8443/FreeBSD-14.0-RELEASE-amd64-zfs.qcow2


doctl compute ssh-key list

doctl compute droplet create --image centos-stream-8-x64 --size s-1vcpu-1gb --ssh-keys 37403754 --region blr1 --vpc-uuid 6251114d-711a-4b4d-82fa-833382b84166 centos

doctl compute droplet list

doctl compute droplet delete 417973754

