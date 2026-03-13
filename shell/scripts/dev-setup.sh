#!/bin/bash

# Development Directory Structure Setup Script
# This script creates an organized directory structure for software development

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to create directory with description
create_dir() {
    local dir_path="$1"
    local description="$2"
    
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
        print_success "Created: $dir_path"
        if [ -n "$description" ]; then
            echo "# $description" > "$dir_path/.directory-purpose"
            echo "# Created on: $(date)" >> "$dir_path/.directory-purpose"
        fi
    else
        print_warning "Already exists: $dir_path"
    fi
}

# Function to create README file in directory
create_readme() {
    local dir_path="$1"
    local content="$2"
    
    if [ ! -f "$dir_path/README.md" ]; then
        echo "$content" > "$dir_path/README.md"
        print_success "Created README: $dir_path/README.md"
    fi
}

echo "=================================================="
echo "   Development Directory Structure Setup"
echo "=================================================="
echo ""

# Check if we're in the home directory
if [ "$PWD" != "$HOME" ]; then
    print_warning "You're not in your home directory ($HOME)"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Setup cancelled. Please run from your home directory."
        exit 1
    fi
fi

print_status "Creating development directory structure..."
echo ""

# Main project directories
print_status "Setting up main project directories..."
create_dir "projects" "Main development projects organized by category"
create_dir "projects/personal" "Personal side projects and hobby code"
create_dir "projects/work" "Work-related projects and repositories"
create_dir "projects/client" "Client projects (if applicable)"
create_dir "projects/archived" "Completed or paused projects for reference"

# Sandbox directories for experimentation
print_status "Setting up sandbox directories..."
create_dir "sandbox" "Testing and experimental projects - safe to delete contents"
create_dir "sandbox/forks" "Forked repositories for testing and contributing"
create_dir "sandbox/tutorials" "Code from tutorials and learning exercises"
create_dir "sandbox/proof-of-concept" "Quick proof-of-concept implementations"
create_dir "sandbox/temp" "Temporary downloads and quick tests"

# Documentation directories
print_status "Setting up documentation directories..."
create_dir "docs" "Development documentation and references"
create_dir "docs/cheatsheets" "Quick reference materials and cheat sheets"
create_dir "docs/project-docs" "Project-specific documentation and notes"
create_dir "docs/learning" "Learning materials, courses, and study notes"

# Tools and utilities
print_status "Setting up tools directories..."
create_dir "tools" "Development tools and utilities"
create_dir "tools/scripts" "Custom automation scripts and utilities"
create_dir "tools/configs" "Tool configurations not managed by dotfiles"
create_dir "tools/local-installs" "Locally installed development tools and binaries"

# Data directories
print_status "Setting up data directories..."
create_dir "data" "Development data and assets"
create_dir "data/databases" "Local database files and dumps"
create_dir "data/datasets" "Test data and datasets for development"
create_dir "data/media" "Images, videos, and other media for projects"

# Create helpful README files
print_status "Creating README files..."

create_readme "projects" "# Projects Directory

This directory contains your main development projects, organized by category:

- **personal/**: Personal side projects and hobby code
- **work/**: Work-related projects and repositories  
- **client/**: Client projects (if applicable)
- **archived/**: Completed or paused projects for reference

## Best Practices
- Use descriptive, kebab-case folder names
- Include a README.md in each project
- Use git for version control
- Move completed projects to archived/
"

create_readme "sandbox" "# Sandbox Directory

This directory is for testing, experimentation, and temporary projects.
Feel free to create and delete folders here as needed.

- **forks/**: Forked repositories for testing and contributing
- **tutorials/**: Code from tutorials and learning exercises
- **proof-of-concept/**: Quick proof-of-concept implementations  
- **temp/**: Temporary downloads and quick tests

## Guidelines
- Don't commit important work here
- Regular cleanup is encouraged
- Use descriptive folder names with dates
- Document experiments with simple README files
"

# Check for existing bin directory and inform user
if [ -d "bin" ]; then
    print_warning "bin/ directory already exists - keeping your existing setup"
else
    create_dir "bin" "Personal scripts and executables"
    print_status "Add ~/bin to your PATH if not already done"
    print_status "Add this to your shell config: export PATH=\"\$HOME/bin:\$PATH\""
fi

# Create a simple gitignore for the sandbox
if [ ! -f "sandbox/.gitignore" ]; then
    cat > sandbox/.gitignore << EOF
# Ignore everything in sandbox by default
*

# But allow specific files
!.gitignore
!README.md
!*/README.md

# Add specific folders/files you want to track
# !important-experiment/
EOF
    print_success "Created sandbox/.gitignore"
fi

# Create a development environment setup script
cat > tools/scripts/dev-env-check.sh << 'EOF'
#!/bin/bash
# Quick script to check your development environment

echo "Development Environment Check"
echo "=============================="

# Check for common development tools
tools=("git" "node" "npm" "python3" "pip3" "code" "vim" "tmux")

for tool in "${tools[@]}"; do
    if command -v $tool &> /dev/null; then
        echo "✓ $tool is installed"
    else
        echo "✗ $tool is not installed"
    fi
done

echo ""
echo "Directory Structure:"
for dir in projects sandbox docs tools data bin; do
    if [ -d "$HOME/$dir" ]; then
        echo "✓ ~/$dir exists"
    else
        echo "✗ ~/$dir missing"
    fi
done
EOF

chmod +x tools/scripts/dev-env-check.sh
print_success "Created development environment check script"

echo ""
print_success "Development directory structure setup complete!"
echo ""
print_status "Next steps:"
echo "  1. Review the created README files for usage guidelines"
echo "  2. Move existing projects into the appropriate directories"
echo "  3. Add ~/bin to your PATH if needed"
echo "  4. Run ~/tools/scripts/dev-env-check.sh to verify your setup"
echo "  5. Consider version controlling ~/tools/scripts/ directory"
echo ""
print_status "Happy coding!"