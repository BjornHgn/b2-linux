# I. Init

## 3. sudo c pa bo

🌞 **Ajouter votre utilisateur au groupe `docker`**

```shell
[bjorn@vbox ~]$ sudo usermod -aG docker bjorn

[bjorn@vbox ~]$ docker info
Client: Docker Engine - Community
 Version:    27.4.0
 Context:    default
 Debug Mode: false
```

## 4. Un premier conteneur en vif

🌞 **Lancer un conteneur NGINX**

```docker
[bjorn@vbox ~]$ docker run -d -p 9999:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
```

🌞 **Visitons**

```docker
[bjorn@vbox ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                     NAMES
74a31519664a   nginx     "/docker-entrypoint.…"   57 seconds ago   Up 55 seconds   0.0.0.0:9999->80/tcp, [::]:9999->80/tcp   sweet_northcutt
```

```docker
[bjorn@vbox ~]$ docker logs 74a31519664a
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
```

```docker
[bjorn@vbox ~]$ docker inspect 74a31519664a
[
    {
        "Id": "74a31519664a3c5e2c73751ec6e288ac42f05e7d7fa545666d15779ad2dfc132",
        "Created": "2024-12-11T09:08:33.69300843Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
```

```linux
[bjorn@vbox ~]$ sudo ss -lnpt
[sudo] password for bjorn:
State           Recv-Q          Send-Q                   Local Address:Port                   Peer Address:Port          Process
LISTEN          0               128                            0.0.0.0:22                          0.0.0.0:*              users:(("sshd",pid=723,fd=3))
LISTEN          0               4096                           0.0.0.0:9999                        0.0.0.0:*              users:(("docker-proxy",pid=6917,fd=4))
```

```linux
[bjorn@vbox ~]$ sudo firewall-cmd --add-port=9999/tcp
success
```

```linux
[bjorn@vbox ~]$ curl http://10.1.1.11:9999/
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

🌞 **On va ajouter un site Web au conteneur NGINX**

```linux
[bjorn@vbox ~]$ mkdir /home/bjorn/nginx
[bjorn@vbox ~]$ cd /home/bjorn/nginx
[bjorn@vbox nginx]$ sudo nano index.html
[sudo] password for bjorn:
Sorry, try again.
[sudo] password for bjorn:
[bjorn@vbox nginx]$ sudo nano site_nul.conf
```

🌞 **Visitons**

```shell
[bjorn@vbox nginx]$ docker run -d -p 9999:8080 -v /home/bjorn/nginx/index.html:/var/www/html/index.html -v /home/bjorn/nginx/site_nul.conf:/etc/nginx/conf.d/site_nul.conf
 nginx
7d3a0256b4eff516862f25fff4818aea9c5ab7deca8dae8a6008212f3545314d
docker: Error response from daemon: driver failed programming external connectivity on endpoint thirsty_blackwell (0ece786bd2074b240dace89b2d342417719ca124d97cbb611ef088328b517a82): Bind for 0.0.0.0:9999 failed: port is already allocated.
```

```linux
[bjorn@vbox nginx]$ curl http://10.1.1.11:9999/
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

## 5. Un deuxième conteneur en vif

🌞 **Lance un conteneur Python, avec un shell**

```docker
[bjorn@vbox ~]$ docker run -it python bash
```

🌞 **Installe des libs Python**

```docker
root@85aa390cb891:/# pip install aiohttp
root@85aa390cb891:/# pip install aioconsole
Collecting aioconsole
```

```python
root@85aa390cb891:/# python
Python 3.13.1 (main, Dec  4 2024, 20:40:27) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import aiohttp
```

# II. Images


## 1. Images publiques

🌞 **Récupérez des images**

```bash
[bjorn@TP1LINUX ~]$ docker pull python:3.13
[bjorn@TP1LINUX ~]$ docker pull mysql:5.7
[bjorn@TP1LINUX ~]$ docker pull wordpress
Using default tag: latest
[bjorn@TP1LINUX ~]$ docker pull linuxserver/wikijs
Using default tag: latest
[bjorn@TP1LINUX ~]$ docker images
REPOSITORY           TAG       IMAGE ID       CREATED         SIZE
linuxserver/wikijs   latest    863e49d2e56c   6 days ago      465MB
python               3.13      3ca4060004b1   9 days ago      1.02GB
python               latest    3ca4060004b1   9 days ago      1.02GB
nginx                latest    66f8bdd3810c   2 weeks ago     192MB
wordpress            latest    c89b40a25cd1   3 weeks ago     700MB
mysql                5.7       5107333e08a8   12 months ago   501MB
```

🌞 **Lancez un conteneur à partir de l'image Python**

```docker
[bjorn@TP1LINUX ~]$ docker run -it python bash
root@1789a1a11850:/# python --version
Python 3.13.1
```

## 2. Construire une image

🌞 **Ecrire un Dockerfile pour une image qui héberge une application Python**

```bash
[bjorn@TP1LINUX python_app_build]$ sudo cat Dockerfile
FROM debian
RUN apt update
RUN apt install -y python3
RUN apt install -y python3-emoji

COPY app.py /app/app.py

ENTRYPOINT ["python3", "app.py"]

[bjorn@TP1LINUX python_app_build]$ cat main.py
import emoji

print(emoji.emojize("Cet exemple d'application est vraiment naze :thumbs_down:"))
```

🌞 **Build l'image**

```bash
[bjorn@TP1LINUX python_app_build]$ docker build . -t python_app:version_de_ouf
[bjorn@TP1LINUX python_app_build]$ docker images
REPOSITORY           TAG              IMAGE ID       CREATED              SIZE
python_app           version_de_ouf   7d49314948be   About a minute ago   31
```

🌞 **Lancer l'image**

- lance l'image avec `docker run` :

```bash
docker run python_app:version_de_ouf

[bjorn@TP1LINUX python_app_build]$ docker run python_app:version_de_ouf
Cet exemple d'application est vraiment naze 👎
```

# III. Docker compose

🌞 **Créez un fichier `docker-compose.yml`**

```bash
[bjorn@TP1LINUX ~]$ mkdir compose_test
[bjorn@TP1LINUX ~]$ cd compose_test/
[bjorn@TP1LINUX compose_test]$ sudo nano docker-compose.yml
```

```yml
version: "3"

services:
  conteneur_nul:
    image: debian
    entrypoint: sleep 9999
  conteneur_flopesque:
    image: debian
    entrypoint: sleep 9999
```

🌞 **Lancez les deux conteneurs** avec `docker compose`

```bash
[bjorn@TP1LINUX compose_test]$ docker compose up -d
WARN[0000] /home/bjorn/compose_test/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion
[+] Running 3/3
 ✔ conteneur_nul Pulled                                                4.4s
 ✔ conteneur_flopesque Pulled                                          4.0s
   ✔ fdf894e782a2 Already exists                                       0.0s
[+] Running 3/3
 ✔ Network compose_test_default                  Created               2.8s
 ✔ Container compose_test-conteneur_nul-1        Started               4.6s
 ✔ Container compose_test-conteneur_flopesque-1  Started               4.3s
```

🌞 **Vérifier que les deux conteneurs tournent**

```docker
[bjorn@TP1LINUX compose_test]$ docker compose ps
WARN[0000] /home/bjorn/compose_test/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion
NAME                                 IMAGE     COMMAND        SERVICE               CREATED              STATUS              PORTS
compose_test-conteneur_flopesque-1   debian    "sleep 9999"   conteneur_flopesque   About a minute ago   Up About a minute
compose_test-conteneur_nul-1         debian    "sleep 9999"   conteneur_nul         About a minute ago   Up About a minute
```

🌞 **Pop un shell dans le conteneur `conteneur_nul`**

```bash
[bjorn@TP1LINUX compose_test]$ docker exec -it compose_test-conteneur_nul-1
bash
root@de24b74891d6:/# apt-get install -y iputils-ping
root@de24b74891d6:/# ping conteneur_flopesque
PING conteneur_flopesque (172.18.0.2) 56(84) bytes of data.
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.2): icmp_seq=1 ttl=64 time=4.18 ms
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.2): icmp_seq=2 ttl=64 time=0.114 ms
```