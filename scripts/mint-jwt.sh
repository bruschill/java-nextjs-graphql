#!/usr/bin/env bash

set -euo pipefail

JWT_SECRET="${JWT_SECRET:-replace-this-with-a-long-jwt-secret-at-least-32-bytes}"
SUBJECT="${SUBJECT:-api-user}"
ROLES="${ROLES:-API}"
TTL_SECONDS="${TTL_SECONDS:-3600}"

now="$(date +%s)"
exp="$((now + TTL_SECONDS))"

b64url() {
  openssl base64 -A | tr '+/' '-_' | tr -d '='
}

header='{"alg":"HS256","typ":"JWT"}'
payload='{"sub":"'"$SUBJECT"'","iat":'"$now"',"exp":'"$exp"',"roles":["'"${ROLES//,/\",\"}"'"]}'

header_b64="$(printf '%s' "$header" | b64url)"
payload_b64="$(printf '%s' "$payload" | b64url)"
signature="$(printf '%s' "${header_b64}.${payload_b64}" | openssl dgst -sha256 -hmac "$JWT_SECRET" -binary | b64url)"

printf '%s.%s.%s\n' "$header_b64" "$payload_b64" "$signature"
