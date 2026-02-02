#!/bin/bash
# push_to_github.sh - Push repository to GitHub
# Run this after setup_repo.sh

echo "🏛️ Pushing Openclawd No-GC SIR Runtime to GitHub"
echo "=================================================="
echo ""

# Verify we're in a git repo
if [ ! -d ".git" ]; then
    echo "❌ Error: Not a git repository. Run ./setup_repo.sh first"
    exit 1
fi

# Add the remote
echo "🔗 Adding GitHub remote..."
git remote add origin https://github.com/daavfx/OPenclawd---No-GC-SIR-RUNTIME.git 2>/dev/null || echo "Remote already exists"

# Check current status
echo ""
echo "📊 Repository status:"
git status --short

# Push to GitHub
echo ""
echo "📤 Pushing to GitHub..."
echo "   You will be prompted for your GitHub credentials"
echo "   Username: daavfx"
echo ""

git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! Repository pushed to GitHub"
    echo ""
    echo "🔗 Repository URL:"
    echo "   https://github.com/daavfx/OPenclawd---No-GC-SIR-RUNTIME"
    echo ""
    echo "🎉 PHASE 64 COMPLETE - Welcome to legendary status!"
else
    echo ""
    echo "❌ Push failed. Common issues:"
    echo "   1. Wrong credentials"
    echo "   2. Repository doesn't exist on GitHub yet"
    echo "   3. Network issues"
    echo ""
    echo "To create the repo on GitHub:"
    echo "   1. Go to https://github.com/new"
    echo "   2. Name: OPenclawd---No-GC-SIR-RUNTIME"
    echo "   3. Set to Public or Private"
    echo "   4. Click 'Create repository'"
    echo "   5. Run this script again"
fi
