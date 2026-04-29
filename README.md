# Java + Next.js + GraphQL Skeleton

Minimal full-stack skeleton:
- `backend`: Java 21 Spring Boot app exposing GraphQL at `/graphql`
- `frontend`: Next.js app that queries the backend using Apollo Client
- `docker-compose.yml`: one-command local stack for both apps

## Project Structure

```text
.
├── backend
│   ├── build.gradle
│   └── src/main
│       ├── java/com/example/backend
│       └── resources/graphql/schema.graphqls
└── frontend
    ├── app
    └── lib
```

## Prerequisites

- Java 21
- Node.js 18+ (recommended: 20+)

## Run Backend

```bash
cd backend
gradle bootRun
```

Backend endpoints:
- GraphQL: `http://localhost:8080/graphql`
- GraphiQL: `http://localhost:8080/graphiql`

## Run Frontend

```bash
cd frontend
cp .env.example .env.local
npm install
npm run dev
```

Open `http://localhost:3000`.

## Docker Compose

Run both services together:

```bash
docker compose up --build
```

URLs:
- Frontend: `http://localhost:3000`
- Backend GraphQL: `http://localhost:8080/graphql`
- Backend GraphiQL: `http://localhost:8080/graphiql`

## CORS and Auth Scaffolding

The backend includes basic scaffolding for CORS and JWT auth.

Backend env vars:
- `APP_CORS_ALLOWED_ORIGINS` (default: `http://localhost:3000`)
- `APP_AUTH_ENABLED` (default: `false`)
- `APP_AUTH_JWT_SECRET` (default: `replace-this-with-a-long-jwt-secret-at-least-32-bytes`)

Frontend env vars:
- `NEXT_PUBLIC_GRAPHQL_URL` (default: `http://localhost:8080/graphql`)
- `NEXT_PUBLIC_API_TOKEN` (optional; sent as `Authorization: Bearer <jwt>`)

Behavior:
- GraphiQL is left open for local testing.
- When `APP_AUTH_ENABLED=true`, GraphQL requests to `/graphql` require a valid JWT bearer token.
- `me` query returns the authenticated user (`username`, `authenticated`, `roles`).

## Quick Query Tests

Use this GraphQL query in GraphiQL (`http://localhost:8080/graphiql`) or from `curl`:

```graphql
query Demo($name: String) {
  hello(name: $name)
  me {
    username
    authenticated
    roles
  }
}
```

GraphiQL variables:

```json
{
  "name": "GraphiQL"
}
```

With auth disabled (`APP_AUTH_ENABLED=false`, default):

```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"query Demo($name:String){ hello(name:$name) me { username authenticated roles } }","variables":{"name":"curl"}}'
```

With auth enabled (`APP_AUTH_ENABLED=true`) and valid JWT:

```bash
TOKEN="$(./scripts/mint-jwt.sh)"

curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"query":"query Demo($name:String){ hello(name:$name) me { username authenticated roles } }","variables":{"name":"curl"}}'
```

With auth enabled and missing/invalid token (expected to fail with 401/403):

```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ me { username authenticated roles } }"}'
```

Script helper:

```bash
chmod +x scripts/mint-jwt.sh
chmod +x scripts/test-graphql.sh

# APP_AUTH_ENABLED=false
./scripts/test-graphql.sh no-auth

# APP_AUTH_ENABLED=true (auto-mints JWT using JWT_SECRET)
./scripts/test-graphql.sh with-auth

# APP_AUTH_ENABLED=true (expected failure)
./scripts/test-graphql.sh bad-auth

# print a JWT directly (custom subject/roles/ttl)
SUBJECT=alice ROLES=API,ADMIN TTL_SECONDS=7200 ./scripts/mint-jwt.sh
```

Makefile shortcuts:

```bash
make up
make logs
make mint-jwt
make test-no-auth
make test-auth
make test-bad-auth
make down
```

## Next Steps

- Add entities/services/repositories in backend
- Replace sample `hello` query with domain schema
- Replace HS256 shared-secret JWT with external IdP (OIDC/JWKS)

## Future Note

- For production readiness, migrate JWT validation from local HS256 shared secret to JWKS/OIDC (for example Auth0, Okta, or Keycloak).