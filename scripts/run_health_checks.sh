#!/usr/bin/env bash
set -e

COLOR=$1
echo "Running health checks for $COLOR environment..."

# Replace with actual IPs or URLs for the inactive pool.
for i in {1..5}; do
  echo "Attempt $i..."
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://example-${COLOR}.domain/health || true)
  if [ "$STATUS" == "200" ]; then
    echo "Health check passed ✅"
    exit 0
  fi
  sleep 5
done

echo "Health checks failed ❌"
exit 1
