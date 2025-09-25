# mise shell integration
if command -v mise &>/dev/null; then
  # For bash completion and auto-activation of environment
  eval "$(mise activate bash)"
  # Hook direnv through mise if available
  eval "$(mise hook-env -s bash)"
fi