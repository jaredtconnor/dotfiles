# mise shell integration
if command -v mise &>/dev/null; then
  # For zsh completion and auto-activation of environment
  eval "$(mise activate zsh)"
  # Hook direnv through mise if available
  eval "$(mise hook-env -s zsh)"
fi