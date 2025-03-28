# Variables
COMPOSE_FILE := docker-compose.yaml

# Targets
.PHONY: help up down build logs duckdb

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  up     Start the project containers"
	@echo "  down   Stop and remove the project containers"
	@echo "  build  Build the project images"
	@echo "  logs   View the logs of a specific service"
	@echo "  help   Show this help message"
	@echo "  duckdb Connect to DuckDB CLI container"

up:
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

build:
	docker compose -f $(COMPOSE_FILE) build

logs:
	@echo "Enter the service name to view logs:"
	@read -r service; \
	docker compose -f $(COMPOSE_FILE) logs $$service -f

duckdb:
	docker exec -it duckdb-cli bash -c "/usr/app/duckdb -init init.sql duck.db"