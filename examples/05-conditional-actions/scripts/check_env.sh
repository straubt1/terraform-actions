#!/usr/bin/env bash
ENV="${1:-unknown}"

echo "$(date): Checking environment: $ENV"

case "$ENV" in
  prod)
    echo "WARNING: You are deploying to PRODUCTION!"
    ;;
  staging)
    echo "Deploying to staging environment."
    ;;
  dev)
    echo "Deploying to dev environment."
    ;;
  *)
    echo "ERROR: Unknown environment '$ENV'"
    exit 1
    ;;
esac
