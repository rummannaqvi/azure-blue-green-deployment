#!/usr/bin/env bash
set -e

echo "Verifying post-swap environment..."

STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://example.domain/health || true)
if [ "$STATUS" == "200" ]; then
  echo "Post-swap verification passed ✅"
else
  echo "Post-swap verification failed ❌"
  exit 1
fi
