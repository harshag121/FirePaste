# 4. Use Chi Router

Date: 2024-05-22

## Status

Accepted

## Context

We need an HTTP router for our Go application that:
1. Supports RESTful URL patterns and parameter extraction.
2. Provides middleware chaining capabilities.
3. Is lightweight and performant.
4. Has good compatibility with standard library patterns.
5. Is actively maintained and well-documented.

## Decision

We will use **go-chi/chi**.

## Consequences

**Positive:**
- Fully compatible with net/http - uses standard http.Handler interface.
- Clean middleware stack management.
- URL parameter extraction (chi.URLParam).
- Lightweight - minimal overhead over standard library.
- Excellent documentation and examples.
- MIT licensed - fully free software.
- ~100% code coverage and well-tested.

**Negative:**
- Less feature-rich than some alternatives (but we don't need complexity).
- Smaller ecosystem than Gin (but adequate for our needs).

## Alternatives Considered

- **Gorilla Mux**: Heavier, less active maintenance recently.
- **Gin**: More opinionated, includes validation/rendering we don't need, faster benchmarks but marginal for our scale.
- **Echo**: Similar to Gin, more features than we require.
- **Standard library only**: Would require manual URL parsing and middleware management.

## Notes

Chi strikes the perfect balance between simplicity and functionality for this project. It stays close to the standard library while providing the routing convenience we need.
