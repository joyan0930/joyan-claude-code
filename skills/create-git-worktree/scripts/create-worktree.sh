#!/bin/bash

# Git Worktree Setup Script
# Usage: ./create-worktree.sh <branch-name>
#
# Creates an isolated working directory for branch-based development
# - Creates worktree in .git-worktrees/ directory
# - Copies .env and .env.keys (dotenvx) files if present
# - Automatically builds Docker containers if compose file exists

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate input
if [ -z "$1" ]; then
    echo -e "${RED}Error: ブランチ名を指定してください${NC}"
    echo "Usage: $0 <branch-name>"
    echo "Example: $0 feature/new-feature"
    exit 1
fi

BRANCH_NAME="$1"

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$REPO_ROOT" ]; then
    echo -e "${RED}Error: Gitリポジトリ内で実行してください${NC}"
    exit 1
fi

cd "$REPO_ROOT"

# Get default branch name
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

# Convert slashes to hyphens for directory name
WORKTREE_DIR_NAME="${BRANCH_NAME//\//-}"
WORKTREE_PATH="${REPO_ROOT}/.git-worktrees/${WORKTREE_DIR_NAME}"

echo -e "${BLUE}=== Git Worktree Setup ===${NC}"
echo -e "Branch: ${GREEN}${BRANCH_NAME}${NC}"
echo -e "Worktree path: ${GREEN}${WORKTREE_PATH}${NC}"
echo ""

# Fetch latest from remote
echo -e "${YELLOW}Fetching latest from remote...${NC}"
git fetch origin

# Create .git-worktrees directory if it doesn't exist
mkdir -p "${REPO_ROOT}/.git-worktrees"

# Check if worktree already exists
if [ -d "$WORKTREE_PATH" ]; then
    echo -e "${YELLOW}Worktree already exists at ${WORKTREE_PATH}${NC}"
    echo -e "Reusing existing worktree..."
else
    # Check if branch exists remotely
    if git ls-remote --exit-code --heads origin "$BRANCH_NAME" > /dev/null 2>&1; then
        echo -e "${GREEN}Remote branch found. Creating worktree from remote...${NC}"
        git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME" "origin/$BRANCH_NAME" 2>/dev/null || \
        git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
    else
        # Create new branch from default branch
        echo -e "${YELLOW}Remote branch not found. Creating new branch from ${DEFAULT_BRANCH}...${NC}"
        git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME" "origin/${DEFAULT_BRANCH}"
    fi
fi

# Copy environment files
echo ""
echo -e "${YELLOW}Setting up environment files...${NC}"

# Copy .env file if exists
if [ -f "${REPO_ROOT}/.env" ]; then
    cp "${REPO_ROOT}/.env" "${WORKTREE_PATH}/.env"
    echo -e "${GREEN}  - Copied .env${NC}"
fi

# Copy .env.local file if exists
if [ -f "${REPO_ROOT}/.env.local" ]; then
    cp "${REPO_ROOT}/.env.local" "${WORKTREE_PATH}/.env.local"
    echo -e "${GREEN}  - Copied .env.local${NC}"
fi

# Copy .env.keys file (dotenvx) if exists
if [ -f "${REPO_ROOT}/.env.keys" ]; then
    cp "${REPO_ROOT}/.env.keys" "${WORKTREE_PATH}/.env.keys"
    echo -e "${GREEN}  - Copied .env.keys (dotenvx)${NC}"
fi

# Copy any other .env.* files (for dotenvx environments like .env.development, .env.production)
for env_file in "${REPO_ROOT}"/.env.*; do
    if [ -f "$env_file" ]; then
        filename=$(basename "$env_file")
        # Skip if already copied
        if [ "$filename" != ".env.local" ] && [ "$filename" != ".env.keys" ]; then
            cp "$env_file" "${WORKTREE_PATH}/${filename}"
            echo -e "${GREEN}  - Copied ${filename}${NC}"
        fi
    fi
done

# Check for Docker Compose and build if exists
COMPOSE_FILE=""
if [ -f "${WORKTREE_PATH}/docker-compose.yml" ]; then
    COMPOSE_FILE="${WORKTREE_PATH}/docker-compose.yml"
elif [ -f "${WORKTREE_PATH}/docker-compose.yaml" ]; then
    COMPOSE_FILE="${WORKTREE_PATH}/docker-compose.yaml"
elif [ -f "${WORKTREE_PATH}/compose.yml" ]; then
    COMPOSE_FILE="${WORKTREE_PATH}/compose.yml"
elif [ -f "${WORKTREE_PATH}/compose.yaml" ]; then
    COMPOSE_FILE="${WORKTREE_PATH}/compose.yaml"
fi

if [ -n "$COMPOSE_FILE" ]; then
    echo ""
    echo -e "${YELLOW}Docker Compose file found. Building containers...${NC}"
    cd "$WORKTREE_PATH"
    docker compose build
fi

# Success message
echo ""
echo -e "${GREEN}=== Worktree created successfully! ===${NC}"
echo ""
echo -e "Worktree location: ${BLUE}${WORKTREE_PATH}${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. cd ${WORKTREE_PATH}"
echo -e "  2. Start development!"
echo ""
echo -e "${YELLOW}To remove this worktree later:${NC}"
echo -e "  git worktree remove ${WORKTREE_PATH}"
if [ -n "$COMPOSE_FILE" ]; then
    echo -e "  docker compose -f ${COMPOSE_FILE} down -v  # Remove Docker resources"
fi
