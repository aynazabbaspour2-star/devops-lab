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

