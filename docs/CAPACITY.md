# Capacity Planning & Sizing

## Requirements
- **Goal**: One-Click Ephemeral Pastebin.
- **Target Load**: 1000 QPS (Bursty).
- **Retention**: Max 24h.
- **Avg Paste Size**: 10 KB.

## Storage (Redis) calculation

**Formula**: `(Rate * AvgSize * TTL)`

- **Writes**: 100 pastes/sec (assumption).
- **Size**: 10 KB per paste.
- **TTL**: 24 Hours (86400 sec).

**Calculation**:
`100 * 10KB * 86400`
= `1000 KB * 86400`
= `1 MB * 86400`
= **86.4 GB** (Worst case if saturated for 24h)

**Constraint**: `t3.micro` has ~1GB RAM.
- **Adjustment**: We must aggressively limit `maxmemory` to ~512MB.
- **Max Pastes in RAM**: `512MB / 10KB` ≈ **51,200 pastes**.

**Conclusion**: For a free tier (`t3.micro`), we cannot support 100 continuous writes/sec with 24h retention.
**Operational Limit**: ~0.5 writes/sec for 24h retention OR reduced TTL to 1 hour for higher throughput.

## Bandwidth
- 1000 Reads/sec * 10 KB = 10 MB/sec = **80 Mbps**.
- AWS Free tier usually has generic burstable limits; 80 Mbps is sustained high load but possible in bursts.

## Compute
- Go binary: Extremely efficient.
- Redis: Single-threaded, CPU bound but simple O(1) ops.
- `t3.micro` (2 vCPU burstable) is sufficient for >1k QPS simple text fetch.
