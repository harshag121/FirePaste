# Contributing to FirePaste

Thank you for your interest in contributing to FirePaste! 🔥

## Getting Started

### Prerequisites

- Go 1.22+
- Docker & Docker Compose
- Make (optional, but recommended)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/harshag121/FirePaste.git
   cd FirePaste
   ```

2. **Start the development stack**
   ```bash
   make up
   ```

3. **Run tests**
   ```bash
   make test
   ```

4. **View available commands**
   ```bash
   make help
   ```

## Development Workflow

### Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write code following Go conventions
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes**
   ```bash
   make test
   make bench
   ```

4. **Format code**
   ```bash
   make format
   ```

5. **Commit with meaningful messages**
   ```bash
   git commit -m "feat: add syntax highlighting support"
   ```

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `test:` Adding or updating tests
- `refactor:` Code refactoring
- `perf:` Performance improvements
- `chore:` Maintenance tasks

### Pull Request Process

1. Update the README.md or documentation if needed
2. Ensure all tests pass
3. Update IMPLEMENTATION.md if adding major features
4. Create a Pull Request with:
   - Clear description of changes
   - Reference any related issues
   - Screenshots/demos if applicable

## Project Structure

```
FirePaste/
├── cmd/server/         # Main application entry point
├── internal/
│   ├── api/           # HTTP handlers and routes
│   └── store/         # Redis storage layer
├── docs/              # Documentation and diagrams
│   └── adr/          # Architecture Decision Records
├── deploy/            # Infrastructure configuration
├── tests/             # Test files and load tests
└── scripts/           # Automation scripts
```

## Adding New Features

### Example: Adding JSON API Support

1. **Update handlers** (`internal/api/handlers.go`)
2. **Add tests** (`internal/api/handlers_test.go`)
3. **Document the change** (ADR if significant)
4. **Update README** with new API endpoints
5. **Submit PR** with clear description

### Architecture Decisions

For significant changes, create an ADR:

```bash
# Create new ADR
cat > docs/adr/0005-your-decision.md << EOF
# 5. Your Decision Title

Date: $(date +%Y-%m-%d)

## Status
Proposed / Accepted / Deprecated

## Context
[What is the issue we're seeing...]

## Decision
[What we decided...]

## Consequences
[Positive and negative outcomes...]
EOF
```

## Testing Guidelines

### Unit Tests

- Test files live alongside source files
- Use table-driven tests for multiple cases
- Aim for >80% coverage on critical paths

### Load Tests

- k6 scripts in `tests/k6/`
- Test scenarios should be realistic
- Document expected performance thresholds

### Integration Tests

- Use Docker Compose for integration tests
- Clean up resources after tests
- Test burn-after-reading flows end-to-end

## Code Style

- Follow standard Go conventions
- Use `gofmt` for formatting
- Keep functions small and focused
- Add comments for exported functions
- Use meaningful variable names

## Documentation

- Update README.md for user-facing changes
- Add ADRs for architectural decisions
- Comment non-obvious code
- Update diagrams if architecture changes

## Questions?

- Open an issue for discussion
- Check existing issues and PRs first
- Be respectful and constructive

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for making FirePaste better! 🚀
