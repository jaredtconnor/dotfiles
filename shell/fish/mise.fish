# mise shell integration
if command -v mise &>/dev/null
    # For fish completion and auto-activation of environment
    mise activate fish | source
    # Hook direnv through mise if available
    mise hook-env -s fish | source
end