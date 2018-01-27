# What is Sabresume
Sabresume is a shell script that restarts paused sabnzbd downloads. Sabnzbd may pause downloads due to a lack of disk space. It does not resume once disk space is available. Sabresume addresses that issue.

## How to use this image
# Usage
Sabresume requires the environmental variable ```SABKEY``` be defined. This is the api key for the sabnzbd. Additional variables can be define but have already have defaults.
```
SABHOST: sabnzbd #dnsname of sabnzbd host.
SABPORT: 8080 #port that sabnzbd is listening on.
PROT: http #protocol used to access sabnzbd. This will be either http or https
SPACELIMIT: 20 #Number of GB required to be free before resuming
SLEEP: 300 #Duration between checking free space available.
```

Complete docker run command example with all environmental variables defined:
```bash
docker run -e SABKEY=111111111111111111111 -e SABHOST=sabnzbd.mydomain.com -e SABPORT=443 -e PROT=https -e SPACELIMIT=40 -e SLEEP=300 --name sabresume mjmayer/sabresume
```

Complete docker run command example using default variables:
```bash
docker run -e SABKEY=111111111111111111111 --name sabresume mjmayer/sabresume
```
