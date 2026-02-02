#!/bin/bash
# setup_repo.sh - Initialize and push to GitHub
# Run this script to set up the repository

echo "🏛️ Setting up Openclawd No-GC SIR Runtime Repository"
echo "======================================================"

# Check if we're in the right directory
if [ ! -f "README.md" ]; then
    echo "❌ Error: README.md not found. Run this from the repository root."
    exit 1
fi

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
    git branch -M main
else
    echo "📦 Git repository already initialized"
fi

# Create .gitignore
echo "📝 Creating .gitignore..."
cat > .gitignore << 'EOF'
# Rust
target/
Cargo.lock
**/*.rs.bk
*.pdb

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log
debug_logs.txt

# Build artifacts
*.o
*.so
*.a
*.dylib
*.exe
*.dll

# Temporary files
temp_*
*.tmp
*.temp

# Node (if any JS tooling)
node_modules/
npm-debug.log*

# Secrets (NEVER commit these!)
*.pem
*.key
.env
secrets.toml
EOF

# Stage all files
echo "📂 Staging files..."
git add .

# Initial commit
echo "💾 Creating initial commit..."
git commit -m "Initial commit: TypeScript → SIR → GPU Runtime v23.64.0

- SIR (Sovereign Intermediate Representation)
- TypeScript compiler bridge (94.85% corpus)
- Tiered execution: Interpreter → JIT → GPU → AOT
- Unified orchestrator: CPU + iGPU + dGPU
- Thermal governor: 85°C limit with predictive throttling
- Zero-copy memory bridge: GC ↔ GPU
- OSR (On-Stack Replacement) for hot loops

Phase 64 complete: TS to GPU-native execution"

# Add remote (user needs to run these manually with their credentials)
echo ""
echo "🔗 To push to GitHub, run these commands:"
echo "   git remote add origin https://github.com/daavfx/OPenclawd---No-GC-SIR-RUNTIME.git"
echo "   git push -u origin main"
echo ""
echo "⚠️  You'll be prompted for your GitHub credentials"
echo ""

# Check repository size
echo "📊 Repository stats:"
echo "   Files: $(find . -type f -not -path './.git/*' | wc -l)"
echo "   Rust files: $(find . -name '*.rs' -not -path './target/*' | wc -l)"
echo "   Lines of Rust code: $(find . -name '*.rs' -not -path './target/*' -exec wc -l {} + | tail -1 | awk '{print $1}')"

echo ""
echo "✅ Repository ready for push!"
echo "🏛️ Phase 64: SIR Integration Complete"
