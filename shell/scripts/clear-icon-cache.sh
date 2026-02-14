#!/usr/bin/env bash

# Clear the macOS Icon Services cache when it bloats
# See: https://discussions.apple.com/thread/8441124

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script only runs on macOS."
  exit 1
fi

SYSTEM_CACHE="/Library/Caches/com.apple.iconservices.store"

echo "Checking icon services cache size..."
echo ""

if [[ -e "$SYSTEM_CACHE" ]]; then
  cache_size=$(sudo du -sh "$SYSTEM_CACHE" 2>/dev/null | cut -f1)
  echo "  System cache: $cache_size ($SYSTEM_CACHE)"
else
  echo "  System cache: not found"
fi

user_size=$(sudo find /private/var/folders -name "com.apple.iconservices*" -exec du -sh {} + 2>/dev/null | tail -1 | cut -f1)
if [[ -n "$user_size" ]]; then
  echo "  User caches:  $user_size (in /private/var/folders)"
else
  echo "  User caches:  not found"
fi

echo ""
read -rp "Clear the icon services cache? This requires a restart afterward. [y/N] " confirm

if [[ "$confirm" != [yY] ]]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "Clearing system icon cache..."
sudo rm -rf "$SYSTEM_CACHE"

echo "Clearing user icon caches..."
sudo find /private/var/folders -name "com.apple.iconservices*" -exec rm -rf {} + 2>/dev/null || true

echo ""
echo "Done. Restart your Mac to rebuild the icon cache."
