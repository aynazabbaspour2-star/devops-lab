# Docker Swarm Project

## Overview

This project demonstrates deploying a Flask application using Docker Swarm.

## Technologies

- Docker
- Docker Swarm
- Flask
- Python
- Docker Service
- Replica Scaling

## Architecture

Client
|
Docker Swarm Ingress Network
|
3 Flask replicas


## Features

- Custom Docker Image
- Docker Swarm Manager initialization
- Replicated Service
- Built-in Load Balancing
- Service discovery


## Commands

Initialize Swarm:

docker swarm init


Create Service:

docker service create \
--name swarm-web \
--publish 8085:5000 \
--replicas 3 \
swarm-demo:v1


Check services:

docker service ls


Check replicas:

docker service ps swarm-web


Test:

curl localhost:8085


## Result

Multiple requests are distributed between different containers.
