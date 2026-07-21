# 09 - Traefik Reverse Proxy with Docker

A production-style reverse proxy setup using Traefik v3, Docker Compose, TLS, and automatic service discovery.

## Architecture
            Client
              |
              | HTTPS :443
              |
          Traefik v3.6
              |
    +---------+---------+
    |                   |
whoami service Flask App
Host Routing Path Routing
/app

## Stack

- Traefik v3.6
- Docker Compose
- Flask
- Gunicorn
- TLS certificates
- Docker provider
- File provider

## Features

- Reverse proxy with Traefik
- HTTPS routing
- Docker container auto discovery
- Host based routing
- Path based routing
- Middleware usage with StripPrefix
- Traefik dashboard

## Project Structure
09-traefik/
├── docker-compose.yml
├── traefik.yml
├── dynamic/
│ └── tls.yml
├── ssl/
│ ├── server.crt
│ └── server.key
└── flask-app/
├── Dockerfile
├── app.py
└── requirements.txt

## Run Project

Build and start services:

```bash
docker compose up -d --build
docker ps
Access
Traefik Dashboard
http://SERVER-IP:8090/dashboard/
Flask Application
https://localhost/app
Whoami Service
https://whoami.localhost
Test Routing

Flask
curl -k https://localhost/app
Whoami
curl -k https://localhost \
-H "Host: whoami.localhost"
TLS

This project uses a local TLS certificate.

For production environments, replace it with:

Let's Encrypt ACME
Automatic certificate renewal
Real domain certificates
Next Steps
Connect Traefik to Docker Swarm
Add Let's Encrypt automation
Add authentication middleware
Deploy production services behind Traefik
---

# Docker Swarm Deployment

This project was extended to run Traefik in Docker Swarm mode with dynamic service discovery and load balancing.

## Swarm Architecture
                Client
                  |
                HTTPS
                  |
            Traefik v3.6
                  |
         traefik-public overlay
                  |
      +-----------+-----------+
      |           |           |
  swarm-web   swarm-web   swarm-web
   replica1    replica2    replica3

## Create Traefik Overlay Network

Create a shared overlay network for Traefik and application services:

```bash
docker network create \
--driver=overlay \
--attachable \
traefik-public
docker network ls

---

### 3) Deploy Traefik روی Swarm:

```md
## Deploy Traefik Stack

Deploy Traefik as a Docker Swarm service:

```bash
docker stack deploy \
-c traefik-stack.yml \
proxy
docker service ls
proxy_traefik   replicated   1/1

---

### 4) بخش Application Service:

```md
## Swarm Application Deployment

The Flask application runs as a Docker Swarm service with multiple replicas.

Example:

```bash
docker service ls
swarm-web   replicated   5/5

---

### 5) بخش اتصال به Traefik:

```md
## Connect Service to Traefik

Attach application service to Traefik network:

```bash
docker service update \
--network-add traefik-public \
swarm-web
docker service inspect swarm-web \
--format '{{json .Spec.TaskTemplate.Networks}}'

---

### 6) بخش Labels:

```md
## Traefik Dynamic Routing

Routing is configured using Docker Swarm labels:

```text
traefik.enable=true

traefik.http.routers.swarm-web.rule=PathPrefix(`/`)

traefik.http.routers.swarm-web.entrypoints=websecure

traefik.http.routers.swarm-web.tls=true

traefik.http.services.swarm-web.loadbalancer.server.port=5000

traefik.swarm.lbswarm=true

---

### 7) بخش تست Load Balancing (مهم برای رزومه):

```md
## Load Balancing Test

Send multiple HTTPS requests:

```bash
for i in {1..10}; do curl -sk https://localhost/; echo; done
{"hostname":"dbd59159cf72","message":"Production Swarm CI/CD Pipeline Updated","version":"2.0"}

{"hostname":"16f5baa3f8ca","message":"Production Swarm CI/CD Pipeline Updated","version":"2.0"}

---

### 8) آخر README این رو اضافه کن:

```md
## Skills Demonstrated

- Docker Compose
- Docker Swarm orchestration
- Traefik reverse proxy
- HTTPS/TLS configuration
- Overlay networking
- Service discovery
- Dynamic routing with labels
- Production-style load balancing
- Zero downtime service updates

