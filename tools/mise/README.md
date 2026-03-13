# mise Tool Management

This directory contains configuration for [mise](https://mise.jdx.dev/), a unified runtime manager for multiple languages and tools.

## Global Configuration

The global mise configuration is managed through:
- `config.toml` - Global mise settings
- `mise.toml` - Global tool versions and defaults

## Local Project Usage

For local projects, create a `.mise.toml` file in your project directory. Example configurations are available in the `examples/` directory.

## Common Commands

```bash
# Install all configured tools
mise install

# Run a project with the configured environment
mise run <task>

# Activate mise in your current shell
eval "$(mise activate zsh)"  # or bash/fish

# List installed versions
mise ls

# Install a specific tool version
mise install nodejs@20

# Set a project-local version
mise use nodejs@20

# Create a new project environment
mise init
```

## Environment Management

mise supports both global and local (per-directory) runtime environments:

1. **Global environment**: Defined in `~/.config/mise/mise.toml`
2. **Local environment**: Defined in `.mise.toml` in each project directory

For automatically switching environments when changing directories, make sure you have shell integration:
```bash
eval "$(mise activate zsh)"
```

## Example Configuration

Here's a simple project-local configuration example:

```toml
[env]
NODE_ENV = "development"

[tools]
nodejs = "20"
python = "3.11"

[tasks]
dev = "npm run dev"
test = "npm run test"
```

Run `mise run dev` to execute the dev task in the configured environment.