#!/bin/bash

doctl compute droplet-action power-on 366586120
doctl compute droplet-action power-off 366586120


doctl compute image create freebsd --region nyc3 --image-url http://150.230.237.232:8443/FreeBSD-14.0-RELEASE-amd64-zfs.qcow2