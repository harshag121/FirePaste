# 1. Use Go for the Backend

Date: 2024-05-22

## Status

Accepted

## Context

We need a backend language/runtime for our ephemeral pastebin that:
1. Produces small, statically-linked binaries for easy deployment.
2. Has excellent HTTP server performance and concurrency primitives.
3. Is memory-efficient and fast.
4. Has mature Redis and Prometheus client libraries.
5. Is 100% free/open-source (no runtime licensing issues).

## Decision

We will use **Go (Golang)**.

## Consequences

**Positive:**
- Single static binary (~10 MB) - no runtime dependencies.
- Built-in HTTP server and context management.
- Goroutines make concurrent request handling trivial.
- Strong standard library and ecosystem (Redis, Prometheus clients).
- Fast compilation and excellent cross-platform support.
- Memory-safe without garbage collection pauses that impact latency significantly.
- Apache 2.0 license - fully free software.

**Negative:**
- Verbose error handling (if err != nil pattern).
- No generics until Go 1.18+ (acceptable for this simple use case).
- Slightly larger binaries than C/Rust, but negligible for containers.

## Alternatives Considered

- **Node.js**: Requires runtime, larger container image, single-threaded (needs clustering).
- **Python**: Requires runtime, slower, heavier memory footprint.
- **Rust**: More complex development, longer compile times (overkill for this use case).
