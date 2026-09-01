# bue-brain

A clean, reusable template for a multi-agent Hermes brain architecture. Designed for Codespaces with dev container support.

## 🚀 Quick Start

### Option 1: GitHub Codespaces (Recommended)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ValoLoco/bue-brain)

1. Click the button above to open in Codespaces
2. Wait for dev container to build (~5 minutes)
3. Run the setup sequence:
   ```bash
   bash complete-setup.sh
   bash create-folders.sh
   ```
4. Configure your NIM API keys:
   ```bash
   export NVIDIA_API_KEY_PRIMARY=your-primary-key
   export NVIDIA_API_KEY_ALTERNATIVE=your-alternative-key
   export NVIDIA_API_KEY_CONTINGENCY=your-contingency-key
   ```
5. Run bootstrap:
   ```bash
   ./scripts/bootstrap.sh
   ```
6. Start working:
   ```bash
   hermes -p personal chat
   hermes -p example-company-ceo chat
   ```

### Option 2: Local Development

```bash
# Clone the repo
git clone https://github.com/ValoLoco/bue-brain.git
cd bue-brain

# Generate all template files
bash complete-setup.sh

# Create folder structure with .gitkeep files
bash create-folders.sh

# Commit the generated structure
git add -A
git commit -m "Initialize bue-brain template"

# Configure your NIM API keys
export NVIDIA_API_KEY_PRIMARY=your-primary-key
export NVIDIA_API_KEY_ALTERNATIVE=your-alternative-key
export NVIDIA_API_KEY_CONTINGENCY=your-contingency-key

# Run bootstrap to create profiles and configure Hermes
./scripts/bootstrap.sh

# Start working
hermes -p personal chat
hermes -p example-company-ceo chat
```

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      ~/Brains/                              │
├─────────────────────┬───────────────────────────┬───────────┤
│   personal/         │     companies/            │ projects/ │
│   (global context)  │     (shared org brains)   │ (focused) │
└─────────────────────┴───────────────────────────┴───────────┘
                              │
                    ┌─────────┴─────────┐
                    │  Hermes Profiles  │
                    │  (agent minds)    │
                    └───────────────────┘
```

## What's Included

### Brain Structure
- **Personal brain** (`~/Brains/personal/`): Cross-company context, founder areas, decisions
- **Company brains** (`~/Brains/companies/<company>/`): One per company with C-Suite agents
- **Project brains** (`~/Brains/projects/`): Personal focused projects

### C-Suite Agent Profiles
Each company gets 6 specialized profiles:

| Profile | Role | Model Tier | Focus |
|---------|------|------------|-------|
| `<company>-ceo` | Chief Executive | High-reasoning | Strategy, priorities, approvals |
| `<company>-coo` | Chief Operating | Balanced | Operations, delivery, SOPs |
| `<company>-cfo` | Chief Financial | High-reasoning | Finance, pricing, unit economics |
| `<company>-cmo` | Chief Marketing | Balanced | Positioning, content, demand gen |
| `<company>-cto` | Chief Technology | Code-capable | Automation, tooling, infra |
| `<company>-cos` | Chief of Staff | Balanced | Triage, coordination, briefs |

### PACE Resilience

| Tier | Provider | Purpose |
|------|----------|---------|
| **P**rimary | NVIDIA NIM | Main workload |
| **A**lternative | NVIDIA NIM | Failover 1 |
| **C**ontingency | NVIDIA NIM | Failover 2 |
| **E**mergency | Local Ollama | Offline/last resort |

### Folder Structure (per brain)

```
<brain>/
├── raw/          # Immutable source captures
├── wiki/         # Distilled canonical knowledge
├── decisions/    # Decision records with rationale
├── outputs/      # Drafts and generated materials
├── archive/      # Closed work
└── [domain-specific folders]
```

## Directory Structure

```
bue-brain/
├── .devcontainer/
│   ├── devcontainer.json       # Codespaces config
│   ├── Dockerfile              # Ubuntu + Ollama + tools
│   └── post-create.sh          # Auto-starts Ollama
├── brains/
│   ├── personal/
│   │   ├── AGENTS.md
│   │   ├── INDEX.md
│   │   └── [folders]
│   ├── companies/
│   │   └── example-company/
│   │       ├── AGENTS.md
│   │       ├── INDEX.md
│   │       └── [folders]
│   └── projects/
├── hermes/
│   ├── config.yaml             # Global PACE config
│   └── pace-template/          # Profile template
├── scripts/
│   ├── bootstrap.sh            # Interactive setup
│   └── create-company.sh       # Add new companies
├── complete-setup.sh           # Generate all template files
├── create-folders.sh           # Create folder structure
├── .gitignore
└── LICENSE
```

## Adding New Companies

```bash
./scripts/create-company.sh my-company "My Company"
```

This creates:
- Brain folder structure at `~/Brains/companies/my-company/`
- 6 C-Suite profiles: `my-company-ceo` through `my-company-cos`
- All configured with PACE fallback chain

## Usage Patterns

### Personal Agent (Capture & Route)
```bash
hermes -p personal chat
# "I just had an idea for a new client offering..."
# → Creates routing note in company raw/
```

### Company C-Suite
```bash
# CEO: Strategy and approvals
hermes -p example-company-ceo chat
# "Review Q3 priorities and approve new client engagement"

# COO: Operations and delivery
hermes -p example-company-coo chat
# "Launch client engagement using SOP-001"

# COS: Triage and coordination
hermes -p example-company-cos chat
# "Process raw inbox and route to appropriate agents"
```

### Test PACE Fallback
```bash
hermes doctor
hermes chat -q "Reply with active provider and model"
```

## Configuration

### Required Environment Variables

```bash
# NIM API Keys (at least one required)
export NVIDIA_API_KEY_PRIMARY=nvapi-...
export NVIDIA_API_KEY_ALTERNATIVE=nvapi-...  # optional
export NVIDIA_API_KEY_CONTINGENCY=nvapi-...  # optional

# Optional: Custom Ollama model
export OLLAMA_MODEL=llama3.2:3b
```

### Hermes Credentials

Stored in `~/.hermes/.env` (created by bootstrap):
```env
NVIDIA_API_KEY_PRIMARY=...
NVIDIA_API_KEY_ALTERNATIVE=...
NVIDIA_API_KEY_CONTINGENCY=...
OLLAMA_MODEL=llama3.2:3b
```

## License

MIT
