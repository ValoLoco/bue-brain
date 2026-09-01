#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$ROOT_DIR/.devcontainer" "$ROOT_DIR/scripts" "$ROOT_DIR/hermes/pace-template"
mkdir -p "$ROOT_DIR/brains/personal" "$ROOT_DIR/brains/companies/example-company/operations"

cat > "$ROOT_DIR/.devcontainer/Dockerfile" <<'EOF'
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
RUN apt-get update && apt-get install -y --no-install-recommends curl git ca-certificates jq yq fzf bat eza zoxide python3 python3-venv python3-pip && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://ollama.com/install.sh | sh
CMD ["sleep", "infinity"]
EOF

cat > "$ROOT_DIR/.devcontainer/post-create.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
ollama serve >/tmp/ollama.log 2>&1 &
sleep 3
ollama pull llama3.2:3b || true
echo "Run ./scripts/bootstrap.sh to configure Hermes and PACE."
EOF
chmod +x "$ROOT_DIR/.devcontainer/post-create.sh"

cat > "$ROOT_DIR/hermes/config.yaml" <<'EOF'
# PACE: Primary, Alternative, Contingency, Emergency
model:
  provider: nvidia
  default: nvidia/nemotron-3-super-120b-a12b
fallback_providers:
  - provider: nvidia
    model: nvidia/nemotron-3-super-120b-a12b
    credential_pool: primary
  - provider: nvidia
    model: nvidia/llama-3.3-70b-instruct
    credential_pool: alternative
  - provider: nvidia
    model: nvidia/llama-3.1-8b-instruct
    credential_pool: contingency
  - provider: ollama
    model: llama3.2:3b
    base_url: http://127.0.0.1:11434/v1
memory:
  provider: local
  max_chars: 2200
skills:
  auto_create: true
EOF
cp "$ROOT_DIR/hermes/config.yaml" "$ROOT_DIR/hermes/pace-template/config.yaml"

cat > "$ROOT_DIR/hermes/pace-template/SOUL.md" <<'EOF'
# Agent Identity Template

## Role
[Role and primary responsibility]

## Authority
[Actions allowed without escalation]

## Output Contract
[Required outputs and canonical locations]

## Operating Principles
- Read AGENTS.md and INDEX.md before substantive work
- Keep context scoped to the task
- Draft in outputs, promote only after review
EOF

cat > "$ROOT_DIR/brains/personal/AGENTS.md" <<'EOF'
# Personal Agent Team

## Role
The personal agent captures, triages, and routes. It does not execute company work.

## Routing
- Personal captures: raw/
- Personal decisions: decisions/
- Cross-company learning: wiki/
- Company work: route to ~/Brains/companies/<company>/raw/
EOF

cat > "$ROOT_DIR/brains/personal/INDEX.md" <<'EOF'
# Personal Brain Index

- raw/: unprocessed personal captures
- wiki/: distilled reusable knowledge
- areas/: ongoing life and founder areas
- decisions/: personal decision records
- projects/: personal project brains
- outputs/: drafts
- archive/: closed material
EOF

cat > "$ROOT_DIR/brains/companies/example-company/AGENTS.md" <<'EOF'
# Example Company Agent Team

## C-Suite Profiles
- ceo: strategy, priorities, approvals, decisions
- coo: operations, delivery, SOPs
- cfo: finance, pricing, unit economics
- cmo: positioning, content, demand generation
- cto: automation, tooling, infrastructure
- cos: intake triage and executive coordination

## Rules
- Read INDEX.md before substantive work
- raw/ is immutable source capture
- wiki/ is canonical distilled knowledge
- decisions/ records consequential decisions and rationale
- outputs/ holds drafts until reviewed and promoted
EOF

cat > "$ROOT_DIR/brains/companies/example-company/INDEX.md" <<'EOF'
# Example Company Brain Index

- raw/: intake and source material
- wiki/: company knowledge
- operations/: SOPs, templates, systems
- clients/: client records and delivery
- partnerships/: partner records
- marketing/: positioning, campaigns, content
- finance/: planning and reports
- projects/: active initiatives
- decisions/: decision records
- outputs/: drafts
- archive/: closed work
EOF

cat > "$ROOT_DIR/brains/companies/example-company/operations/CONTEXT.md" <<'EOF'
# Operations Context

- sops/: standard operating procedures
- templates/: reusable internal and external templates
- automation/: scripts and job definitions
- tools/: evaluations and configuration notes

New SOPs use: YYYY-MM-DD--short-name.md
EOF

cat > "$ROOT_DIR/scripts/bootstrap.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

: "${NVIDIA_API_KEY_PRIMARY:?Set NVIDIA_API_KEY_PRIMARY before running bootstrap}"
: "${NVIDIA_API_KEY_ALTERNATIVE:?Set NVIDIA_API_KEY_ALTERNATIVE before running bootstrap}"
: "${NVIDIA_API_KEY_CONTINGENCY:?Set NVIDIA_API_KEY_CONTINGENCY before running bootstrap}"

COMPANY="${1:-example-company}"
HOME_BRAINS="$HOME/Brains"
OLLAMA_MODEL="${OLLAMA_MODEL:-llama3.2:3b}"

mkdir -p "$HOME/.hermes" "$HOME_BRAINS/personal" "$HOME_BRAINS/companies"
cat > "$HOME/.hermes/.env" <<ENV
NVIDIA_API_KEY_PRIMARY=$NVIDIA_API_KEY_PRIMARY
NVIDIA_API_KEY_ALTERNATIVE=$NVIDIA_API_KEY_ALTERNATIVE
NVIDIA_API_KEY_CONTINGENCY=$NVIDIA_API_KEY_CONTINGENCY
OLLAMA_MODEL=$OLLAMA_MODEL
ENV
chmod 600 "$HOME/.hermes/.env"

ollama serve >/tmp/ollama.log 2>&1 &
ollama pull "$OLLAMA_MODEL" || true

cp hermes/config.yaml "$HOME/.hermes/config.yaml"
./scripts/create-company.sh "$COMPANY"

echo "Bootstrap complete. Configure Hermes credentials using its supported setup flow, then start a profile."
EOF
chmod +x "$ROOT_DIR/scripts/bootstrap.sh"

cat > "$ROOT_DIR/scripts/create-company.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

COMPANY="${1:?Usage: ./scripts/create-company.sh <company-slug>}"
BRAIN="$HOME/Brains/companies/$COMPANY"
OLLAMA_MODEL="${OLLAMA_MODEL:-llama3.2:3b}"

mkdir -p "$BRAIN"/{raw,wiki,operations/{sops,templates,automation,tools},clients,partnerships,marketing,finance,projects,decisions,outputs,archive}
cp brains/companies/example-company/AGENTS.md "$BRAIN/AGENTS.md"
cp brains/companies/example-company/INDEX.md "$BRAIN/INDEX.md"
cp brains/companies/example-company/operations/CONTEXT.md "$BRAIN/operations/CONTEXT.md"

for role in ceo coo cfo cmo cto cos; do
  profile="$HOME/.hermes/profiles/$COMPANY-$role"
  mkdir -p "$profile"
  cp hermes/pace-template/config.yaml "$profile/config.yaml"
  cat > "$profile/SOUL.md" <<SOUL
# ${COMPANY} ${role^^} Agent

## Role
${role^^} role for ${COMPANY}.

## Workspace
$BRAIN

## Operating Principles
- Read AGENTS.md and INDEX.md before substantive work
- Use raw for intake, wiki for canonical knowledge, decisions for rationale, outputs for drafts
- Escalate irreversible external actions for human approval
SOUL
done

echo "Created $BRAIN and six C-Suite profile templates."
EOF
chmod +x "$ROOT_DIR/scripts/create-company.sh"

cat > "$ROOT_DIR/.gitignore" <<'EOF'
.env
.hermes/
.ollama/
Brains/
.vscode/
.idea/
*.log
__pycache__/
node_modules/
EOF

cat > "$ROOT_DIR/LICENSE" <<'EOF'
MIT License

Copyright (c) 2026 bue-brain contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

echo "Generated bue-brain template files. Review them, then run git add -A && git commit -m 'Generate bue-brain template'."