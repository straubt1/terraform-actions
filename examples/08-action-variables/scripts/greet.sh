#!/usr/bin/env bash
MESSAGE="${1:-no message}"
LOG_LEVEL="${2:-info}"

echo "$(date): [$LOG_LEVEL] Action invoked"
echo "Message (from argument): $MESSAGE"

# Also read from stdin (demonstrates the stdin config option)
if [ -t 0 ]; then
  echo "Stdin: (none — interactive terminal)"
else
  STDIN_VALUE=$(cat)
  echo "Stdin (from stdin config): $STDIN_VALUE"
fi
