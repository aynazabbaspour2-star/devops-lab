# Monitoring Stack

This project provides a monitoring stack using Docker Compose.

## Components

- Prometheus
- Grafana
- Node Exporter
- cAdvisor

## Services

Prometheus collects metrics.

Grafana visualizes metrics.

Node Exporter exports Linux host metrics.

cAdvisor exports Docker container metrics.

## Run

```bash
docker compose up -d
Ports
Grafana : 3000
Prometheus : 9090
Node Exporter : 9100
cAdvisor : 8088

بعد از آن Commit و Push می‌کنیم و وارد بخش Alerting می‌شویم. این روند باعث می‌شود ریپازیتوری‌ات هم برای استخدام‌کننده‌ها مرتب و حرفه‌ای باشد.
