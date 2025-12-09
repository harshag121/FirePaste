# Threat Model

## System Assets
- **Paste Content**: Ephemeral user data.
- **Service Availability**: Ability to create/read pastes.

## Threats (STRIDE)

### Spoofing
- **Risk**: Attacker impersonates the server.
- **Mitigation**: Caddy manages auto-HTTPS (TLS).

### Tampering
- **Risk**: Modifying paste content in transit.
- **Mitigation**: TLS (HTTPS) everywhere. Redis is internal-only (not exposed to internet).

### Repudiation
- **Risk**: User denies creating a paste.
- **Mitigation**: Basic request logging (IP, Timestamp) in Caddy/Go middleware. (Note: "Burn after reading" makes audit trails tricky as content is gone).

### Information Disclosure
- **Risk**: Unauthorized access to paste.
- **Mitigation**: Random 6-char ID space (56 billion combinations). Brute-force is noisy and rate-limited by Caddy.

### Denial of Service
- **Risk**: Flooding Redis with millions of pastes.
- **Mitigation**:
  - Caddy Rate Limiting.
  - Redis `maxmemory` eviction policy (volatile-lru).
  - Short TTLs enforced.

### Elevation of Privilege
- **Risk**: Code execution on server.
- **Mitigation**:
  - Containerized (Docker).
  - Non-root user in container (pending enhancement).
  - Minimal attack surface (Go binary + Redis).
