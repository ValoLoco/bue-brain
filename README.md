# bue-brain

A clean, reusable template for a multi-agent Hermes brain architecture with C-Suite agents. Designed for GitHub Codespaces with full automation.

## 🚀 Quick Start

### Option 1: GitHub Codespaces (Recommended)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ValoLoco/bue-brain)

**What happens automatically:**
1. Dev container builds (~5 min): Ubuntu 24.04 + Ollama + Hermes Agent
2. Ollama starts and pulls llama3.2:3b model
3. Post-create script configures Hermes with PACE resilience
4. **Ready to create brains!**

**Required:** Set your NIM API keys as Codespace secrets:
- `NVIDIA_API_KEY_PRIMARY`
- `NVIDIA_API_KEY_ALTERNATIVE` (optional)
- `NVIDIA_API_KEY_CONTINGENCY` (optional)

### Option 2: Manual Setup with skills.sh

```bash
git clone https://github.com/ValoLoco/bue-brain.git
cd bue-brain

# Create brains on-demand using skills.sh
bash skills.sh /new-personal-brain
bash skills.sh /new-company-brain acme-corp "Acme Corporation"
bash skills.sh /new-project q4-launch "Q4 Product Launch"
```

## 📋 skills.sh Commands

| Command | Purpose | Creates |
|---------|---------|---------|
| `/new-personal-brain` | Your global knowledge brain | `~/Brains/personal/` with guardrails |
| `/new-company-brain <slug> "Name"` | Company C-Suite brain | `~/Brains/companies/<slug>/` with 6 C-Suite profiles |
| `/new-project <slug> "Name"` | Focused project brain | `~/Brains/projects/<slug>/` with project agent |

### Examples

```bash
# Create your personal brain
bash skills.sh /new-personal-brain

# Create a company brain with C-Suite agents
bash skills.sh /new-company-brain acme-corp "Acme Corporation"
# Creates: ~/Brains/companies/acme-corp/
# Profiles: acme-corp-ceo, acme-corp-coo, acme-corp-cfo, etc.

# Create a project brain
bash skills.sh /new-project q4-launch "Q4 Product Launch"
# Creates: ~/Brains/projects/q4-launch/
# Profile: q4-launch-project
```

## 🧠 Architecture

```
~/Brains/
├── personal/          # Your global context (created by /new-personal-brain)
├── companies/         # One brain per company (created by /new-company-brain)
│   └── acme-corp/
│       ├── AGENTS.md          # C-Suite guardrails
│       ├── INDEX.md           # Brain purpose
│       ├── operations/CONTEXT.md
│       └── .profiles/         # CEO, COO, CFO, CMO, CTO, COS
└── projects/          # Focused initiatives (created by /new-project)
    └── q4-launch/
        ├── AGENTS.md          # Project guardrails
        ├── INDEX.md
        └── .profiles/
```

### Brain Folder Structure

```
<brain>/
├── raw/          # Immutable source captures
├── wiki/         # Distilled canonical knowledge (reviewed only)
├── decisions/    # Decision records with rationale
├── outputs/      # Drafts and generated materials
├── archive/      # Closed work
└── .profiles/    # Hermes agent profiles
```

## 🛡️ Boundary Guardrails

Every brain created by `skills.sh` includes explicit guardrails:

### Agent Boundaries (in AGENTS.md and profile system_prompts)

- **Directory boundary:** Only read/write within brain directory
- **Cross-brain isolation:** Never access other company/project brains
- **Raw immutability:** Never modify `raw/` captures
- **Wiki protection:** Never write directly to `wiki/` - promote from `outputs/` after review
- **Company separation:** Personal brain never mixes company facts into canonical knowledge

### Example: Company C-Suite Guardrails

```markdown
## Boundary rules (critical)
- Directory boundary: Only read and write within this brain directory
- Cross-brain isolation: Never read or write to other company/project brains
- Raw immutability: Treat raw/ as immutable source material
- Wiki protection: Never write directly to wiki/. Promote from outputs/ only after human review
```

## 🔧 Configuration

### Environment Variables

```bash
export NVIDIA_API_KEY_PRIMARY=nvapi-...
export NVIDIA_API_KEY_ALTERNATIVE=nvapi-...  # optional
export NVIDIA_API_KEY_CONTINGENCY=nvapi-...  # optional
export OLLAMA_MODEL=llama3.2:3b
```

### Hermes Credentials

Stored in `~/.hermes/.env` (created by Codespaces post-create):
```env
NVIDIA_API_KEY_PRIMARY=...
NVIDIA_API_KEY_ALTERNATIVE=...
NVIDIA_API_KEY_CONTINGENCY=...
```

## 📖 Usage

### Personal Agent (Capture & Route)

```bash
hermes -p personal chat
# "I had an idea for a new client offering..."
# → Creates routing note in company raw/
```

### Company C-Suite

```bash
# CEO: Strategy and approvals
hermes -p acme-corp-ceo chat

# COO: Operations and delivery
hermes -p acme-corp-coo chat

# COS: Triage and coordination
hermes -p acme-corp-cos chat
```

### Test PACE Fallback

```bash
hermes doctor
hermes chat -q "Reply with active provider and model"
```

## 🔍 Troubleshooting

### "Command not found: hermes"

Hermes Agent isn't installed. In Codespaces, wait for dev container build to complete. Manually:
```bash
curl -fsSL https://hermes-agent.com/install.sh | bash
```

### "No profiles found"

Create brains using `skills.sh`:
```bash
bash skills.sh /new-personal-brain
bash skills.sh /new-company-brain my-company "My Company"
```

### "API key not set"

Set your NVIDIA API keys:
```bash
export NVIDIA_API_KEY_PRIMARY=nvapi-...
```

In Codespaces: Settings → Secrets → Add `NVIDIA_API_KEY_PRIMARY`

### "Agent writes to wrong directory"

Check the brain path in your profile (`~/.hermes/profiles/<name>.yaml`):
```yaml
brain: ~/Brains/companies/my-company  # should match your brain location
```

### "Want to add a new company"

Use `skills.sh` - don't manually create directories:
```bash
bash skills.sh /new-company-brain new-co "New Company Inc"
```

This creates proper guardrails, profiles, and folder structure.

## 📁 Repository Structure

```
bue-brain/
├── .devcontainer/
│   ├── devcontainer.json    # Codespaces config
│   ├── Dockerfile           # Ubuntu + Ollama + Hermes
│   └── post-create.sh       # Auto-configures Hermes
├── skills.sh                # ✨ Brain creation commands
├── brains/
│   ├── personal/            # Example personal brain
│   └── companies/example-company/  # Example company brain
├── hermes/
│   └── pace-template/       # PACE config template
├── scripts/                 # Legacy scripts (optional)
│   ├── bootstrap.sh
│   └── create-company.sh
├── README.md
├── .gitignore
└── LICENSE
```

## 🎯 Key Principles

1. **One brain per context** - Personal, company, project
2. **Guardrails in code** - AGENTS.md + profile system_prompts
3. **Boundary enforcement** - Agents stay in their directory
4. **Raw is immutable** - Never overwrite source captures
5. **Wiki is sacred** - Only reviewed knowledge goes here
6. **Drafts in outputs/** - Clear status: Draft | Review | Approved

## License

MIT
