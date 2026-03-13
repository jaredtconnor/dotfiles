#!/bin/bash
# GitHub SSH Key Setup Script
# Generates or refreshes SSH key for GitHub authentication

set -e

KEY_NAME="${1:-id_ed25519}"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== GitHub SSH Key Setup ===${NC}\n"

# Check if .ssh directory exists
if [ ! -d "$HOME/.ssh" ]; then
    echo -e "${YELLOW}Creating ~/.ssh directory...${NC}"
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Check if key already exists
if [ -f "$KEY_PATH" ]; then
    echo -e "${GREEN}✓ SSH key already exists at $KEY_PATH${NC}"
    read -p "Do you want to generate a new key? (y/n): " generate_new
    if [ "$generate_new" = "y" ]; then
        read -p "Enter new key name (or press enter for ${KEY_NAME}_new): " new_name
        KEY_NAME="${new_name:-${KEY_NAME}_new}"
        KEY_PATH="$HOME/.ssh/$KEY_NAME"
    fi
fi

# Generate key if it doesn't exist
if [ ! -f "$KEY_PATH" ]; then
    echo -e "${YELLOW}Generating new SSH key...${NC}"
    
    # Get email from git config or prompt
    email=$(git config user.email 2>/dev/null || echo "")
    if [ -z "$email" ]; then
        read -p "Enter email for key comment: " email
    else
        echo -e "${BLUE}Using git email: $email${NC}"
        read -p "Press enter to use this email, or type a different one: " custom_email
        email="${custom_email:-$email}"
    fi
    
    ssh-keygen -t ed25519 -C "$email" -f "$KEY_PATH"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ SSH key generated successfully${NC}"
    else
        echo -e "${RED}✗ Failed to generate SSH key${NC}"
        exit 1
    fi
fi

# Add to ssh-agent
echo -e "\n${YELLOW}Adding key to ssh-agent...${NC}"
eval "$(ssh-agent -s)" > /dev/null 2>&1

# macOS specific: add to keychain
if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null || ssh-add -K "$KEY_PATH" 2>/dev/null || ssh-add "$KEY_PATH"
else
    ssh-add "$KEY_PATH"
fi

echo -e "${GREEN}✓ Key added to ssh-agent${NC}\n"

# Display public key
echo -e "${GREEN}=== Your Public Key ===${NC}"
echo -e "${YELLOW}Copy this key and add it to GitHub:${NC}"
echo -e "${BLUE}https://github.com/settings/keys${NC}\n"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
cat "${KEY_PATH}.pub"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Try to copy to clipboard on macOS
if [[ "$OSTYPE" == "darwin"* ]] && command -v pbcopy > /dev/null; then
    cat "${KEY_PATH}.pub" | pbcopy
    echo -e "${GREEN}✓ Public key copied to clipboard!${NC}\n"
fi

# Test connection
echo -e "${YELLOW}Testing GitHub connection...${NC}"
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${GREEN}✓ Successfully authenticated with GitHub!${NC}\n"
else
    echo -e "${YELLOW}⚠ Connection test completed. If you see an error, make sure you've added the key to GitHub.${NC}\n"
fi

echo -e "${GREEN}=== Setup Complete ===${NC}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Go to: ${BLUE}https://github.com/settings/keys${NC}"
echo -e "2. Click 'New SSH key'"
echo -e "3. Paste your public key (already copied to clipboard if on macOS)"
echo -e "4. Give it a title and click 'Add SSH key'"
echo -e "\n${YELLOW}Test your connection:${NC}"
echo -e "  ssh -T git@github.com\n"

