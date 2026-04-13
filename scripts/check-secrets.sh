#!/bin/bash
# Script to detect hard-coded secrets in source code
# This runs as part of CI to prevent secrets from being committed
 
echo 'Checking for hard-coded secrets...'
 
# Check for common secret patterns
if grep -rn \
  -e 'API_KEY\s*=\s*["'\''`][A-Za-z0-9]' \
  -e 'SECRET\s*=\s*["'\''`][A-Za-z0-9]' \
  -e 'PASSWORD\s*=\s*["'\''`][A-Za-z0-9]' \
  --include='*.js' --include='*.ts' ./backend ./frontend 2>/dev/null; then
  echo ''
  echo 'ERROR: Found potential hard-coded secrets!'
  echo 'Please use environment variables instead.'
  exit 1   # Fail the build
fi
 
echo 'No hard-coded secrets found.'
