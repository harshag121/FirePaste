FROM golang:1.22-alpine AS builder

WORKDIR /app

# Install git for fetch
RUN apk add --no-cache git

# Copy source
COPY . .

# Initialize module and fetch deps inside container since local env might lack Go
# If go.mod exists but is empty/partial, this fixes it.
RUN [ ! -f go.mod ] && go mod init github.com/harshag121/FirePaste || true
RUN go mod tidy

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o firepaste cmd/server/main.go

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/firepaste .
# We need the static files embedded? Wait, I used embed package, so they are in the binary. Good.

EXPOSE 8080

CMD ["./firepaste"]
