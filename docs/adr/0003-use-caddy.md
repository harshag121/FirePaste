# 3. Use Caddy as Reverse Proxy

Date: 2024-05-22

## Status

Accepted

## Context

We need a reverse proxy/edge layer to:
1. Handle TLS/HTTPS termination automatically.
2. Provide rate limiting and basic DDoS protection.
3. Serve as a single entry point for the application.
4. Be simple to configure and maintain.
5. Be 100% free and open-source.

## Decision

We will use **Caddy Server**.

## Consequences

**Positive:**
- Automatic HTTPS with Let's Encrypt (zero-config TLS).
- Simple Caddyfile configuration format.
- Built-in rate limiting support.
- HTTP/2 and HTTP/3 support out of the box.
- Excellent performance and low resource usage.
- Apache 2.0 licensed - fully free software.
- Active community and plugin ecosystem.

**Negative:**
- Less widely deployed than Nginx (but simpler for our use case).
- Some advanced features require plugins.
- Slightly less documentation than Nginx for edge cases.

## Alternatives Considered

- **Nginx**: More complex configuration, requires certbot for HTTPS, manual rate limiting setup.
- **Traefik**: Great for container orchestration but overkill for simple deployment.
- **HAProxy**: Excellent for load balancing but more complex TLS setup.
