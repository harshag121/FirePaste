# FirePaste Blog Post Outline

## Title: "Building a Portfolio-Perfect Pastebin: System Design from Requirements to Production"

### Introduction
- The challenge: Build a "show-off" project with free tools
- Why "ephemeral pastebin with burn-after-reading"?
- What makes this portfolio-worthy

### Part 1: Requirements & Architecture
- C4 Context diagram walkthrough
- Capacity planning (QPS, memory, bandwidth calculations)
- Threat modeling (STRIDE analysis)
- Key architectural decisions (ADRs)

### Part 2: Technology Choices (100% FOSS)
- Why Go? Performance + single binary deployment
- Why Redis? TTL support + atomic operations
- Why Caddy? Automatic HTTPS + simple config
- Prometheus + Grafana for observability

### Part 3: Implementation Highlights
- Burn-after-reading: Redis metadata pattern
- Rate limiting at the edge
- Prometheus metrics instrumentation
- k6 load testing with thresholds

### Part 4: Infrastructure & DevOps
- Docker Compose for local dev
- GitHub Actions CI/CD pipeline
- Terraform for AWS deployment (free tier)
- One-command deployment: `make demo`

### Part 5: Results & Lessons
- Performance numbers (from k6 tests)
- Cost analysis ($0 for demo, ~$5/mo production)
- What recruiters care about
- What I learned about system design

### Conclusion
- GitHub repo link
- Live Grafana snapshot
- Invitation to fork/contribute

---

## Publish on:
- dev.to (primary)
- Medium (cross-post)
- Personal blog
- LinkedIn article

## Assets to include:
- C4 diagram screenshot
- Grafana dashboard screenshot
- k6 test results
- Architecture decision tree
- Demo GIF/asciinema

## Keywords for SEO:
- system design
- pastebin
- go programming
- redis
- prometheus
- grafana
- portfolio project
- software architecture
- free software
- devops
