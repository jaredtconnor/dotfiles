# Warn on shell startup if the macOS icon services cache is bloated
if [[ "$OSTYPE" == "darwin"* ]]; then
  _cache="/Library/Caches/com.apple.iconservices.store"
  if [[ -e "$_cache" ]]; then
    _size_kb=$(du -sk "$_cache" 2>/dev/null | cut -f1)
    if [[ -n "$_size_kb" && "$_size_kb" -gt 1000000 ]]; then
      _size_human=$(du -sh "$_cache" 2>/dev/null | cut -f1)
      echo "[warning] Icon services cache is ${_size_human} -- run 'clear-icon-cache' to fix"
    fi
  fi
  unset _cache _size_kb _size_human
fi
