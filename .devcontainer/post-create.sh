#!/usr/bin/env bash
set -euo pipefail

echo "🧠 bue-brain post-create starting..."
echo ""

# Start Ollama service
ollama serve >/tmp/ollama.log 2>&1 &
sleep 3

# Pull default model
ollama pull llama3.2:3b || echo "⚠️  Could not pull model"

echo ""
echo "🚀 Running automated setup..."
echo ""

# Run the setup script
if [ -f "/workspaces/bue-brain/setup.sh" ]; then
    cd /workspaces/bue-brain
    bash setup.sh
else
    echo "⚠️  setup.sh not found"
    echo "Run: bash complete-setup.sh && bash create-folders.sh"
fi
