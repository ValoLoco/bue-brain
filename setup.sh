#!/usr/bin/env bash
# Automated setup script for Codespaces
# Runs all setup steps in sequence

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              bue-brain Automated Setup                     ║"
echo "║         Installing dependencies and configuring...         ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Generate template files
echo "📦 Step 1/5: Generating template files..."
bash "$ROOT_DIR/complete-setup.sh"
echo ""

# Step 2: Create folder structure
echo "📁 Step 2/5: Creating folder structure..."
bash "$ROOT_DIR/create-folders.sh"
echo ""

# Step 3: Install Hermes
echo "🤖 Step 3/5: Installing Hermes Agent..."
if ! command -v hermes &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
    export PATH="$HOME/.hermes/bin:$PATH"
    echo "✅ Hermes installed"
else
    echo "✅ Hermes already installed"
fi
echo ""

# Step 4: Commit generated files
echo "💾 Step 4/5: Committing generated structure..."
cd "$ROOT_DIR"
git config --global user.email "codespaces@github.com"
git config --global user.name "GitHub Codespaces"
git add -A
git commit -m "Initialize bue-brain template structure" || echo "No changes to commit"
echo ""

# Step 5: Configure Hermes with PACE and API keys
echo "🔑 Step 5/5: Configuring Hermes with PACE..."
echo ""

# Check for API keys
if [ -n "${NVIDIA_API_KEY_PRIMARY:-}" ]; then
    echo "✅ NIM API keys detected in environment"
    
    # Create .hermes directory
    mkdir -p "$HOME/.hermes"
    
    # Create .env with API keys
    cat > "$HOME/.hermes/.env" << ENV
# bue-brain generated credentials
NVIDIA_API_KEY_PRIMARY=$NVIDIA_API_KEY_PRIMARY
NVIDIA_API_KEY_ALTERNATIVE=${NVIDIA_API_KEY_ALTERNATIVE:-}
NVIDIA_API_KEY_CONTINGENCY=${NVIDIA_API_KEY_CONTINGENCY:-}
NVIDIA_API_KEY=$NVIDIA_API_KEY_PRIMARY
ENV
    chmod 600 "$HOME/.hermes/.env"
    echo "✅ Created ~/.hermes/.env"
    
    # Copy PACE config
    cp "$ROOT_DIR/hermes/config.yaml" "$HOME/.hermes/config.yaml"
    echo "✅ Applied PACE configuration"
    
    # Register credential pools
    echo "📋 Registering credential pools..."
    hermes auth add nvidia --api-key "$NVIDIA_API_KEY_PRIMARY" --pool primary 2>/dev/null || echo "  Primary pool registered"
    [ -n "${NVIDIA_API_KEY_ALTERNATIVE:-}" ] && hermes auth add nvidia --api-key "$NVIDIA_API_KEY_ALTERNATIVE" --pool alternative 2>/dev/null || echo "  Alternative pool registered"
    [ -n "${NVIDIA_API_KEY_CONTINGENCY:-}" ] && hermes auth add nvidia --api-key "$NVIDIA_API_KEY_CONTINGENCY" --pool contingency 2>/dev/null || echo "  Contingency pool registered"
    
    # Run bootstrap to create profiles
    echo ""
    echo "🧠 Creating C-Suite profiles..."
    export COMPANY_NAME="${COMPANY_NAME:-example-company}"
    export COMPANY_DISPLAY="${COMPANY_DISPLAY:-Example Company}"
    bash "$ROOT_DIR/scripts/bootstrap.sh" "$COMPANY_NAME" "$COMPANY_DISPLAY"
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║              ✅ Setup Complete!                             ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "Your bue-brain is ready. Start working:"
    echo ""
    echo "  # Personal agent (capture & route)"
    echo "  hermes -p personal chat"
    echo ""
    echo "  # Company C-Suite"
    echo "  hermes -p ${COMPANY_NAME:-example-company}-ceo chat"
    echo "  hermes -p ${COMPANY_NAME:-example-company}-coo chat"
    echo ""
else
    echo "⚠️  NIM API keys not found in environment"
    echo ""
    echo "To complete setup, export your NIM API keys:"
    echo ""
    echo "  export NVIDIA_API_KEY_PRIMARY=nvapi-your-primary-key"
    echo "  export NVIDIA_API_KEY_ALTERNATIVE=nvapi-your-alternative-key"
    echo "  export NVIDIA_API_KEY_CONTINGENCY=nvapi-your-contingency-key"
    echo ""
    echo "Then run bootstrap:"
    echo ""
    echo "  ./scripts/bootstrap.sh"
    echo ""
    echo "Get your keys at: https://build.nvidia.com/"
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         ⏳ Waiting for API keys to complete setup          ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
fi
