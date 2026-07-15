# 04 - Multi Container Application

A production-style multi-container application using Docker Compose.

## Architecture
Client
|
v
Nginx Reverse Proxy
|
v
Flask Backend API
|
v
MariaDB Database

## Stack

- Docker
- Docker Compose
- Nginx
- Flask
- MariaDB

## Features

- Multi-container deployment
- Custom backend Docker image
- Internal Docker networking
- Environment variables
- Database persistence
- Healthcheck based startup

## Run

```bash
docker compose up -d --build
