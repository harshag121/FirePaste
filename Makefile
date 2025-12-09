.PHONY: up down build logs bench demo test clean deploy help

help: ## Show this help message
	@echo "FirePaste - Available Commands:"
	@echo "================================"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

up: ## Start the stack (app, redis, caddy, prometheus, grafana)
	docker compose up -d --build

down: ## Stop the stack
	docker compose down

build: ## Build Docker images
	docker compose build

logs: ## Follow application logs
	docker compose logs -f app

bench: ## Run k6 load test
	docker run --network host -i grafana/k6 run - < tests/k6/load.js

demo: up ## Start stack and run load test
	@echo "Waiting for services..."
	@sleep 5
	@make bench

test: ## Run Go unit tests
	go test -v ./...

test-coverage: ## Run tests with coverage report
	go test -v -coverprofile=coverage.txt ./...
	go tool cover -html=coverage.txt -o coverage.html
	@echo "Coverage report: coverage.html"

clean: ## Clean up build artifacts
	rm -f firepaste coverage.txt coverage.html
	docker compose down -v

deploy: ## Deploy to AWS (requires terraform)
	cd deploy && terraform init && terraform apply

format: ## Format Go code
	go fmt ./...

lint: ## Run Go linter (requires golangci-lint)
	golangci-lint run

record-demo: ## Record asciinema demo
	./scripts/record_demo.sh

deploy-azure: ## Deploy to Azure Container Apps
	./scripts/deploy_azure.sh

azure-logs: ## View Azure Container App logs
	az containerapp logs show --name firepaste-app --resource-group rg-firepaste --follow

azure-destroy: ## Destroy Azure resources
	cd deploy && terraform destroy -auto-approve
