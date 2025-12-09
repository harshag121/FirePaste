# 2. Use Redis for Ephemeral Storage

Date: 2024-05-22

## Status

Accepted

## Context

We need a storage solution for a pastebin service that requires:
1. Automatic expiration of data (TTL).
2. Low latency access.
3. Simple key-value access patterns.
4. "Burn after reading" capability (requires atomic read-and-delete or close to it).

## Decision

We will use **Redis**.

## Consequences

**Positive:**
- Built-in TTL support (`SET key value EX seconds`) handles expiration automatically.
- High performance (in-memory).
- Simple Go client libraries.
- Standard "free tier" software available everywhere.

**Negative:**
- Data must fit in RAM (acceptable for ephemeral text pastes).
- Persistence (RDB/AOF) is optional but if we lose the instance, pastes are gone (Accepted trade-off for "ephemeral" nature).
