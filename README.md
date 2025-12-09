# FirePaste 🔥

A "show-off" 1-click ephemeral pastebin that auto-deletes after N minutes.
Built with a **100% Free Software Stack**.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Go](https://img.shields.io/badge/go-1.22-cyan.svg)
![Docker](https://img.shields.io/badge/docker-compose-blue.svg)

## 🚀 Quick Start

You need **Docker** and **Docker Compose**.

```bash
# Clone the repo
git clone https://github.com/harshag121/FirePaste.git
cd FirePaste

# Start the stack
make up
# OR (if no make)
docker compose up -d --build
```

Visit:
- **App**: http://localhost:80
- **Grafana**: http://localhost:3000 (user: `admin`, pass: `admin`)
- **Prometheus**: http://localhost:9090

## ARCHITECTURE

### C4 Context
![C4Context](docs/c4-context.mmd)

### Stack
- **Edge**: Caddy (Reverse Proxy, HTTPS)
- **App**: Go (Chi router, Embed assets)
- **Data**: Redis (TTL for expiry)
- **Observability**: Prometheus + Grafana

## 🧪 Testing

Run the k6 load test:
```bash
make bench
# OR
docker run --network host -i grafana/k6 run - < tests/k6/load.js
```

## 📂 Structure

- `/cmd/server`: Main entrypoint.
- `/internal/api`: HTTP Handlers.
- `/internal/store`: Redis logic.
- `/deploy`: Infrastructure config (Prometheus, Grafana).
- `/docs`: Design documents (ADR, Diagrams).

## 📜 License

MIT
