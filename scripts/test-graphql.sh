#!/usr/bin/env bash

set -euo pipefail

MODE="${1:-no-auth}"
GRAPHQL_URL="${GRAPHQL_URL:-http://localhost:8080/graphql}"
NAME="${NAME:-script}"
TOKEN="${TOKEN:-}"

if [[ -z "$TOKEN" && "$MODE" == "with-auth" ]]; then
  TOKEN="$(JWT_SECRET="${JWT_SECRET:-replace-this-with-a-long-jwt-secret-at-least-32-bytes}" ./scripts/mint-jwt.sh)"
fi

QUERY='query Demo($name:String){ hello(name:$name) me { username authenticated roles } }'
BODY='{"query":"'"$QUERY"'","variables":{"name":"'"$NAME"'"}}'

echo "Mode: $MODE"
echo "GraphQL URL: $GRAPHQL_URL"

case "$MODE" in
  no-auth)
    curl -sS -X POST "$GRAPHQL_URL" \
      -H "Content-Type: application/json" \
      -d "$BODY"
    ;;
  with-auth)
    curl -sS -X POST "$GRAPHQL_URL" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -d "$BODY"
    ;;
  bad-auth)
    curl -sS -i -X POST "$GRAPHQL_URL" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer invalid-token" \
      -d "$BODY"
    ;;
  *)
    echo "Usage: $0 [no-auth|with-auth|bad-auth]"
    echo
    echo "Optional env vars:"
    echo "  GRAPHQL_URL (default: http://localhost:8080/graphql)"
    echo "  NAME        (default: script)"
    echo "  TOKEN       (default: auto-generated JWT for with-auth mode)"
    echo "  JWT_SECRET  (default: replace-this-with-a-long-jwt-secret-at-least-32-bytes)"
    exit 1
    ;;
esac

echo
