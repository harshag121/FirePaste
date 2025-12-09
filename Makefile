.PHONY: up down build psql

up:
	docker compose up -d --build

down:
	docker compose down

build:
	docker compose build

logs:
	docker compose logs -f app

bench:
	# Requires k6 installed locally or run via docker
	docker run --network host -i grafana/k6 run - < tests/k6/load.js

demo: up
	@echo "Waiting for services..."
	@sleep 5
	@make bench
