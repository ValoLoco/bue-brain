# bue-brain

A clean, reusable template for a multi-agent Hermes brain architecture with C-Suite agents. Designed for GitHub Codespaces with full automation.

## 🚀 Quick Start

### GitHub Codespaces (Recommended)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ValoLoco/bue-brain)

**What happens automatically:**
1. Dev container builds (~5 min): Ubuntu 24.04 + Ollama + Hermes Agent
2. Ollama starts and pulls llama3.2:3b model
3. `setup.sh` runs automatically:
   - Generates all template files
   - Creates folder structure
   - Installs Hermes Agent
   - Applies PACE configuration
   - Creates C-Suite profiles (CEO, COO, CFO, CMO, CTO, COS)
4. **Ready to work!**

**Required:** Set your NIM API keys as Codespace secrets:
- `NVIDIA_API_KEY_PRIMARY`
- `NVIDIA_API_KEY_ALTERNATIVE` (optional)
- `NVIDIA_API_KEY_CONTINGENCY` (optional)

If keys are set, setup completes automatically. If not, you'll get instructions to add them.

### Local Development

```bash
git clone https://github.com/ValoLoco/bue-brain.git
cd bue-brain

# Run automated setup
bash setup.sh

# Start working
hermes -p personal chat
hermes -p example-company-ceo chat
```

## Architecture

```
~/Brains/
├── personal/          # Your global context
├── companies/         # One brain per company
│   └── example-company/
└── projects/          # Personal focused projects

~/.hermes/profiles/
├── personal/          # Personal agent
└── example-company-{ceo,coo,cfo,cmo,cto,cos}/  # C-Suite
```

## What's Included

### C-Suite Agent Profiles
Each company gets 6 specialized profiles with PACE resilience:

| Profile | Role | Model Tier |
|---------|------|------------|
| `<company>-ceo` | Strategy, decisions | High-reasoning (NIM Primary) |
| `<company>-coo` | Operations, SOPs | Balanced (NIM Alternative) |
| `<company>-cfo` | Finance, pricing | High-reasoning (NIM Primary) |
| `<company>-cmo` | Marketing, content | Balanced (NIM Alternative) |
| `<company>-cto` | Automation, tooling | Code-capable (NIM Primary) |
| `<company>-cos` | Triage, coordination | Balanced (NIM Alternative) |

### PACE Resilience

| Tier | Provider | Purpose |
|------|----------|---------|
| **P**rimary | NVIDIA NIM | Main workload |
| **A**lternative | NVIDIA NIM | Failover 1 |
| **C**ontingency | NVIDIA NIM | Failover 2 |
| **E**mergency | Local Ollama | Offline/last resort |

### Brain Folder Structure

```
<brain>/
├── raw/          # Immutable source captures
├── wiki/         # Distilled canonical knowledge
├── decisions/    # Decision records with rationale
├── outputs/      # Drafts and generated materials
├── archive/      # Closed work
└── [domain folders]
```

## Usage

### Personal Agent (Capture & Route)
```bash
hermes -p personal chat
# "I had an idea for a new client offering..."
# → Creates routing note in company raw/
```

### Company C-Suite
```bash
# CEO: Strategy and approvals
hermes -p example-company-ceo chat

# COO: Operations and delivery
hermes -p example-company-coo chat

# COS: Triage and coordination
hermes -p example-company-cos chat
```

### Add New Company
```bash
./scripts/create-company.sh my-company "My Company"
```

### Test PACE Fallback
```bash
hermes doctor
hermes chat -q "Reply with active provider and model"
```

## Configuration

### Environment Variables
```bash
export NVIDIA_API_KEY_PRIMARY=nvapi-...
export NVIDIA_API_KEY_ALTERNATIVE=nvapi-...  # optional
export NVIDIA_API_KEY_CONTINGENCY=nvapi-...  # optional
export OLLAMA_MODEL=llama3.2:3b
```

### Hermes Credentials
Stored in `~/.hermes/.env` (created by setup):
```env
NVIDIA_API_KEY_PRIMARY=...
NVIDIA_API_KEY_ALTERNATIVE=...
NVIDIA_API_KEY_CONTINGENCY=...
```

## Repository Structure

```
bue-brain/
├── .devcontainer/
│   ├── devcontainer.json    # Codespaces config
│   ├── Dockerfile           # Ubuntu + Ollama + Hermes
│   └── post-create.sh       # Auto-runs setup
├── brains/
│   ├── personal/
│   └── companies/example-company/
├── hermes/
│   └── pace-template/
├── scripts/
│   ├── bootstrap.sh         # Create profiles
│   └── create-company.sh    # Add companies
├── complete-setup.sh        # Generate templates
├── create-folders.sh        # Create folders
├── setup.sh                 # Full automation
├── README.md
├── .gitignore
└── LICENSE
```

## License

MIT
