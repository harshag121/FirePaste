# FirePaste 🔥

A "show-off" 1-click ephemeral pastebin that auto-deletes after N minutes.
Built with a **100% Free Software Stack**.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Go](https://img.shields.io/badge/go-1.22-cyan.svg)
![Docker](https://img.shields.io/badge/docker-compose-blue.svg)
![Build](https://github.com/harshag121/FirePaste/actions/workflows/ci.yml/badge.svg)
[![Go Report Card](https://goreportcard.com/badge/github.com/harshag121/FirePaste)](https://goreportcard.com/report/github.com/harshag121/FirePaste)

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

### 🎥 Demo

To record a demo GIF:
```bash
./scripts/record_demo.sh
```

Requires [asciinema](https://asciinema.org/). Convert to GIF with [agg](https://github.com/asciinema/agg).

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

## ☁️ Deploy to Cloud

### Azure Container Apps (Recommended)
```bash
./scripts/deploy_azure.sh
```

**Cost:** ~$21/month (includes Redis, Container Apps, Registry)  
**Setup Time:** ~10 minutes  
**Features:** Auto-scaling, HTTPS, monitoring

📚 **[Complete Azure Deployment Guide](docs/AZURE_DEPLOYMENT.md)**

### AWS (EC2 + Terraform)
```bash
cd deploy
terraform init
terraform apply
```

### Other Options
- **Fly.io** - $0-5/month for hobby projects
- **Railway** - Free tier available
- **DigitalOcean App Platform** - $5/month

## 📂 Structure

- `/cmd/server`: Main entrypoint.
- `/internal/api`: HTTP Handlers and static assets.
- `/internal/store`: Redis storage logic with burn-after-read support.
- `/deploy`: Infrastructure config (Prometheus, Grafana, Terraform).
- `/docs`: Design documents (ADR, C4 diagrams, threat model, capacity planning).
- `/tests/k6`: Load testing scripts.
- `/scripts`: Demo recording and automation scripts.

## 🔥 Features

- **Ephemeral Storage**: Pastes auto-delete after TTL (5m, 1h, 24h)
- **Burn After Reading**: Optional one-time view with permanent URL deletion
- **Rate Limiting**: 100 requests/minute via Caddy
- **Observability**: Prometheus metrics + Grafana dashboards
- **Load Testing**: k6 scripts with p95 latency SLOs
- **Infrastructure as Code**: Terraform for AWS deployment
- **100% Free Software**: MIT licensed, all dependencies are FOSS

## 📜 License

MIT

---

## 🎯 Portfolio Showcase

This project demonstrates:

✅ **System Design**: C4 diagrams, capacity planning, threat modeling  
✅ **Architecture Decisions**: ADRs for all major tech choices  
✅ **Production-Ready Code**: Go with metrics, error handling, testing  
✅ **Infrastructure**: Docker Compose, Terraform, GitOps  
✅ **Observability**: Prometheus + Grafana dashboards  
✅ **Performance**: k6 load testing with SLO thresholds  
✅ **DevOps**: CI/CD with GitHub Actions  
✅ **Documentation**: Self-documenting repo with diagrams  
✅ **100% Free Software**: MIT licensed, all dependencies FOSS

### One-Minute Elevator Pitch

> "I designed and shipped a zero-cost, auto-expiring pastebin with burn-after-reading whose entire lifecycle—diagrams, code, infrastructure, monitoring—lives in a public GitHub repo using only open-source tooling. You can run `make demo` and watch it handle load while Grafana tracks p99 latency."

### For Recruiters

- **GitHub**: https://github.com/harshag121/FirePaste
- **Tech Stack**: Go · Redis · Caddy · Prometheus · Grafana · Docker · Terraform
- **Key Features**: Burn-after-reading, rate limiting, observability, IaC
- **Load Tested**: 50+ concurrent users, <500ms p95 latency
- **Documentation**: 4 ADRs, threat model, capacity planning, sequence diagrams

---

Built with ❤️ and 100% Free Software
