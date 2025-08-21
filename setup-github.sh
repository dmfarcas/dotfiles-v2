#!/bin/bash

# Quick setup script to push your dotfiles to GitHub

echo "🚀 Setting up your dotfiles repository on GitHub..."

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found. Please install it first:"
    echo "brew install gh"
    exit 1
fi

# Check if user is logged in to GitHub
if ! gh auth status &> /dev/null; then
    echo "🔐 Please log in to GitHub first:"
    gh auth login
fi

# Install GitHub Copilot extension
echo "🤖 Installing GitHub Copilot CLI extension..."
gh extension install github/gh-copilot

# Get repository name
read -p "📝 Enter repository name (default: dotfiles): " repo_name
repo_name=${repo_name:-dotfiles}

# Get repository visibility
echo "🔒 Repository visibility:"
echo "1. Public (recommended for dotfiles)"
echo "2. Private"
read -p "Choose (1 or 2): " visibility_choice

if [ "$visibility_choice" = "2" ]; then
    visibility="--private"
else
    visibility="--public"
fi

# Create repository on GitHub
echo "📦 Creating repository '$repo_name' on GitHub..."
gh repo create "$repo_name" $visibility --description "My personal dotfiles and development environment configuration"

# Add remote origin
git remote add origin "https://github.com/$(gh api user --jq .login)/$repo_name.git"

# Push to GitHub
echo "⬆️ Pushing to GitHub..."
git push -u origin main

echo ""
echo "🎉 Success! Your dotfiles are now on GitHub!"
echo "📂 Repository: https://github.com/$(gh api user --jq .login)/$repo_name"
echo ""
echo "🤖 GitHub Copilot CLI is now installed! Try:"
echo "   gh copilot suggest 'install node.js'"
echo "   gh copilot explain 'rm -rf'"
echo ""
echo "To clone on a new machine:"
echo "git clone https://github.com/$(gh api user --jq .login)/$repo_name.git ~/dotfiles"
echo "cd ~/dotfiles && ./install.sh"