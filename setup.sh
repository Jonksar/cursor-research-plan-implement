#!/bin/bash

# Cursor Research-Plan-Implement Framework Setup Script
# This script helps you adopt the framework in your repository (Cursor-first)

set -e

# Get the directory where this script is located (Source Directory)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Cursor Framework Setup"
echo "================================"
echo ""

# Get target directory
if [ -z "$1" ]; then
    read -p "Enter the path to your repository: " TARGET_DIR
else
    TARGET_DIR="$1"
fi

# Validate target directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Directory '$TARGET_DIR' does not exist"
    exit 1
fi

# Convert Target Dir to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo ""
if [ -z "$INSTALL_METHOD" ]; then
    echo "Select Installation Method:"
    echo "1) Copy (Standard) - Copies files to your repo. You can modify them freely."
    echo "2) Symlink (Dev/Sync) - Links files to this repo. Updates here are reflected immediately."
    read -p "Choose option (1/2): " INSTALL_METHOD
fi

SYMLINK_MODE="false"
if [ "$INSTALL_METHOD" = "2" ]; then
    SYMLINK_MODE="true"
    echo "🔗 Symlink mode selected."
else
    echo "📋 Copy mode selected."
fi

# Check if .cursor already exists
UPDATE_MODE="false"
if [ -d "$TARGET_DIR/.cursor" ]; then
    echo ""
    echo "ℹ️  .cursor directory already exists in $TARGET_DIR"

    # Check for existing commands and rules
    if [ -d "$TARGET_DIR/.cursor/commands" ] || [ -d "$TARGET_DIR/.cursor/rules" ]; then
        if [ -z "$INSTALL_OPTION" ]; then
            echo "📦 Found existing framework installation"
            echo ""
            echo "What would you like to do?"
            echo "1) Update/Overwrite (replaces files with new copies/links)"
            echo "2) Skip existing files (only add new ones)"
            echo "3) Cancel"
            read -p "Choose option (1/2/3): " INSTALL_OPTION
        fi

        case $INSTALL_OPTION in
            1)
                echo "📥 Updating framework..."
                UPDATE_MODE="true"
                ;;
            2)
                echo "🔀 Adding new files only..."
                UPDATE_MODE="false"
                ;;
            *)
                echo "Setup cancelled"
                exit 0
                ;;
        esac
    fi
else
    # Create .cursor if it doesn't exist
    mkdir -p "$TARGET_DIR/.cursor"
    UPDATE_MODE="false" # Default to creating
fi

# Check if thoughts already exists
if [ -d "$TARGET_DIR/thoughts" ]; then
    if [ -z "$MERGE" ]; then
        echo ""
        echo "⚠️  Warning: thoughts directory already exists in $TARGET_DIR"
        read -p "Do you want to merge with existing thoughts? (y/N): " MERGE
    fi
    if [ "$MERGE" != "y" ] && [ "$MERGE" != "Y" ]; then
        echo "Setup cancelled"
        exit 0
    fi
fi

echo ""
echo "📁 Creating directory structure..."

# Create directories if they don't exist
mkdir -p "$TARGET_DIR/.cursor/commands"
mkdir -p "$TARGET_DIR/.cursor/rules"
mkdir -p "$TARGET_DIR/thoughts/shared/research"
mkdir -p "$TARGET_DIR/thoughts/shared/plans"
mkdir -p "$TARGET_DIR/thoughts/shared/sessions"
mkdir -p "$TARGET_DIR/thoughts/shared/cloud"

echo "📝 Installing framework files..."

install_file() {
    local source="$1"
    local target="$2"
    local type="$3" # "copy" or "symlink"

    local filename=$(basename "$source")
    local dest="$target/$filename"

    if [ -f "$dest" ] || [ -L "$dest" ]; then
        if [ "$UPDATE_MODE" = "true" ]; then
             rm -f "$dest"
             if [ "$type" = "symlink" ]; then
                ln -s "$source" "$dest"
                echo "    🔗 Linked $filename"
             else
                cp "$source" "$dest"
                echo "    🔄 Updated $filename"
             fi
        else
            echo "    ⚠️  $filename already exists, skipping..."
        fi
    else
        if [ "$type" = "symlink" ]; then
            ln -s "$source" "$dest"
            echo "    🔗 Linked $filename"
        else
            cp "$source" "$dest"
            echo "    ✅ Installed $filename"
        fi
    fi
}

# Copy/Link Cursor commands
echo "  Installing Cursor commands..."
for cmd_file in "$SCRIPT_DIR/.cursor/commands"/*.md; do
    if [ "$SYMLINK_MODE" = "true" ]; then
        install_file "$cmd_file" "$TARGET_DIR/.cursor/commands" "symlink"
    else
        install_file "$cmd_file" "$TARGET_DIR/.cursor/commands" "copy"
    fi
done

# Copy/Link Cursor rules
echo "  Installing Cursor rules..."
for rule_file in "$SCRIPT_DIR/.cursor/rules"/*.mdc; do
    if [ "$SYMLINK_MODE" = "true" ]; then
        install_file "$rule_file" "$TARGET_DIR/.cursor/rules" "symlink"
    else
        install_file "$rule_file" "$TARGET_DIR/.cursor/rules" "copy"
    fi
done

# Copy/Link PLAYBOOK.md
echo "  Installing PLAYBOOK.md..."
if [ "$SYMLINK_MODE" = "true" ]; then
    install_file "$SCRIPT_DIR/PLAYBOOK.md" "$TARGET_DIR" "symlink"
else
    install_file "$SCRIPT_DIR/PLAYBOOK.md" "$TARGET_DIR" "copy"
fi

# Create a sample research template (Always copy templates)
echo "📚 Creating sample templates..."

if [ ! -f "$TARGET_DIR/thoughts/shared/research/TEMPLATE.md" ]; then
    cat > "$TARGET_DIR/thoughts/shared/research/TEMPLATE.md" << 'EOF'
---
date: YYYY-MM-DD HH:MM:SS
researcher: Claude
topic: "Research Topic"
tags: [research, codebase]
status: complete
---

# Research: [Topic]

## Research Question
[What we're investigating]

## Summary
[High-level findings]

## Detailed Findings
[Specific discoveries with code references]

## Architecture Insights
[Patterns and design decisions]

## Open Questions
[Areas needing further investigation]
EOF
fi

if [ ! -f "$TARGET_DIR/thoughts/shared/plans/TEMPLATE.md" ]; then
    cat > "$TARGET_DIR/thoughts/shared/plans/TEMPLATE.md" << 'EOF'
# Implementation Plan Template

## Overview
[What we're building and why]

## Current State Analysis
[What exists now]

## Desired End State
[What success looks like]

## Phase 1: [Name]

### Changes Required:
- [File]: [Changes needed]

### Success Criteria:
#### Automated:
- [ ] Tests pass
- [ ] Linting passes

#### Manual:
- [ ] Feature works as expected

## Testing Strategy
[How we'll verify this works]
EOF
fi

# MCP Setup
echo ""
echo "🔌 MCP Server Setup"
if [ -f "$SCRIPT_DIR/mcp_setup.py" ]; then
    # Check if python3 is available
    if command -v python3 &> /dev/null; then
        if [ -z "$SETUP_MCP" ]; then
             read -p "Do you want to configure required MCP servers (Sub-agents, Perplexity, etc.)? (y/N): " SETUP_MCP
        fi
        
        if [ "$SETUP_MCP" = "y" ] || [ "$SETUP_MCP" = "Y" ]; then
            echo "Configuring MCP servers..."
            python3 "$SCRIPT_DIR/mcp_setup.py" --repo-root "$TARGET_DIR"
            echo "✅ MCP servers configured."
        else
            echo "Skipping MCP setup."
        fi
    else
         echo "⚠️  python3 not found. Skipping MCP setup."
    fi
fi

echo ""
if [ "$UPDATE_MODE" = "true" ]; then
    echo "🎉 Framework Updated Successfully!"
    echo "===================================="
else
    echo "🎉 Setup Complete!"
    echo "=================="
fi
echo ""
echo "Framework installed in: $TARGET_DIR"
if [ "$SYMLINK_MODE" = "true" ]; then
    echo "Mode: Symlink (files are linked to source)"
else
    echo "Mode: Copy (files are independent copies)"
fi
echo ""
echo "📖 Next Steps:"
echo "1. Review $TARGET_DIR/PLAYBOOK.md for usage instructions"
echo "2. Restart Cursor to load new MCP settings (if applied)"
echo "3. Try the workflow!"
echo ""
echo "Happy coding! 🚀"
