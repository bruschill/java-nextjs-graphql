SHELL := /bin/bash

.PHONY: help up down logs rebuild mint-jwt test-no-auth test-auth test-bad-auth

help:
	@echo "Available targets:"
	@echo "  make up            - start docker compose stack"
	@echo "  make down          - stop docker compose stack"
	@echo "  make logs          - follow compose logs"
	@echo "  make rebuild       - rebuild and restart compose stack"
	@echo "  make mint-jwt      - print a local HS256 JWT"
	@echo "  make test-no-auth  - run GraphQL test without auth header"
	@echo "  make test-auth     - run GraphQL test with JWT bearer token"
	@echo "  make test-bad-auth - run GraphQL test with invalid token"

up:
	docker compose up --build -d

down:
	docker compose down

logs:
	docker compose logs -f

rebuild:
	docker compose down
	docker compose up --build -d

mint-jwt:
	./scripts/mint-jwt.sh

test-no-auth:
	./scripts/test-graphql.sh no-auth

test-auth:
	./scripts/test-graphql.sh with-auth

test-bad-auth:
	./scripts/test-graphql.sh bad-auth
