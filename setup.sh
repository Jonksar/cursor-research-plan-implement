#!/bin/bash

# Cursor Research-Plan-Implement Framework Setup Script
# This script helps you adopt the framework in your repository (Cursor-first)

set -e

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

# Check if .cursor already exists
if [ -d "$TARGET_DIR/.cursor" ]; then
    echo "ℹ️  .cursor directory already exists in $TARGET_DIR"

    # Check for existing commands and rules
    if [ -d "$TARGET_DIR/.cursor/commands" ] || [ -d "$TARGET_DIR/.cursor/rules" ]; then
        echo "📦 Found existing framework installation"
        echo ""
        echo "What would you like to do?"
        echo "1) Update framework (overwrite with latest versions)"
        echo "2) Skip existing files (only add new ones)"
        echo "3) Cancel"
        read -p "Choose option (1/2/3): " INSTALL_OPTION

        case $INSTALL_OPTION in
            1)
                echo "📥 Updating framework to latest version..."
                UPDATE_MODE="true"
                ;;
            2)
                echo "🔀 Adding new files only, keeping existing ones..."
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
    UPDATE_MODE="false"
fi

# Check if thoughts already exists
if [ -d "$TARGET_DIR/thoughts" ]; then
    echo "⚠️  Warning: thoughts directory already exists in $TARGET_DIR"
    read -p "Do you want to merge with existing thoughts? (y/N): " MERGE
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

echo "📝 Copying framework files..."

# Copy Cursor commands - handle update vs skip mode
echo "  Installing Cursor commands..."
for cmd_file in .cursor/commands/*.md; do
    filename=$(basename "$cmd_file")
    if [ -f "$TARGET_DIR/.cursor/commands/$filename" ]; then
        if [ "$UPDATE_MODE" = "true" ]; then
            # In update mode, overwrite existing files
            cp "$cmd_file" "$TARGET_DIR/.cursor/commands/"
            echo "    🔄 Updated $filename"
        else
            echo "    ⚠️  $filename already exists, skipping..."
        fi
    else
        cp "$cmd_file" "$TARGET_DIR/.cursor/commands/"
        echo "    ✅ Installed $filename"
    fi
done

# Copy Cursor rules - handle update vs skip mode
echo "  Installing Cursor rules..."
for rule_file in .cursor/rules/*.mdc; do
    filename=$(basename "$rule_file")
    if [ -f "$TARGET_DIR/.cursor/rules/$filename" ]; then
        if [ "$UPDATE_MODE" = "true" ]; then
            # In update mode, overwrite existing files
            cp "$rule_file" "$TARGET_DIR/.cursor/rules/"
            echo "    🔄 Updated $filename"
        else
            echo "    ⚠️  $filename already exists, skipping..."
        fi
    else
        cp "$rule_file" "$TARGET_DIR/.cursor/rules/"
        echo "    ✅ Installed $filename"
    fi
done

# Copy playbook if it doesn't exist or ask to update
if [ -f "$TARGET_DIR/PLAYBOOK.md" ]; then
    echo ""
    read -p "PLAYBOOK.md already exists. Update it? (y/N): " UPDATE_PLAYBOOK
    if [ "$UPDATE_PLAYBOOK" = "y" ] || [ "$UPDATE_PLAYBOOK" = "Y" ]; then
        cp PLAYBOOK.md "$TARGET_DIR/"
        echo "✅ Updated PLAYBOOK.md"
    else
        echo "ℹ️  Kept existing PLAYBOOK.md"
    fi
else
    cp PLAYBOOK.md "$TARGET_DIR/"
    echo "✅ Installed PLAYBOOK.md"
fi

# Create a sample research template
echo "📚 Creating sample templates..."

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

echo ""
if [ "$UPDATE_MODE" = "true" ]; then
    echo "🎉 Framework Updated Successfully!"
    echo "===================================="
    echo ""
    echo "Framework updated in: $TARGET_DIR"
    echo ""
    echo "📋 Update Summary:"
    echo "- Cursor commands and rules updated to latest versions"
    echo "- Your research documents and plans are preserved"
    echo ""
    echo "💡 To revert changes:"
    echo "- Use git: 'git checkout -- .cursor/'"
    echo ""
    echo "📖 To update framework in the future:"
    echo "- Run: ./setup.sh $TARGET_DIR"
    echo "- Choose option 1 (Update framework)"
else
    echo "🎉 Setup Complete!"
    echo "=================="
    echo ""
    echo "Framework installed in: $TARGET_DIR"
    echo ""
    echo "📖 Next Steps:"
    echo "1. Review $TARGET_DIR/PLAYBOOK.md for usage instructions"
    echo "2. Try the workflow with a simple task:"
    echo "   - /1_research_codebase"
    echo "   - /2_create_plan"
    echo "   - /4_implement_plan"
    echo ""
    echo "💡 Tips:"
    echo "- Commands are numbered to show the typical flow"
    echo "- Research documents accumulate in thoughts/shared/research/"
    echo "- Plans serve as technical specifications"
    echo "- Use parallel agents for faster research"
    echo "- Use git to track and manage framework changes"
    echo ""
    echo "🔄 To update framework in the future:"
    echo "- Run: ./setup.sh $TARGET_DIR"
    echo "- Choose option 1 (Update framework)"
fi
echo ""
echo "Happy coding! 🚀"
