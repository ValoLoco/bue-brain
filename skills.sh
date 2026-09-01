#!/usr/bin/env bash
# skills.sh — bue-brain scaffolding commands
# Usage: ./skills.sh /new-company-brain <slug> "<display name>"

set -Eeuo pipefail

BRAINS_ROOT="${BRAINS_ROOT:-$HOME/Brains}"

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }
info() { printf '==> %s\n' "$*"; }

validate_slug() {
  [[ "$1" =~ ^[a-z0-9][a-z0-9-]*$ ]] || fail "Slug must use lowercase letters, numbers, and hyphens."
}

ensure_new_dir() {
  [[ ! -e "$1" ]] || fail "Destination already exists: $1"
}

write_common_files() {
  local root="$1" title="$2" purpose="$3"
  mkdir -p "$root"/{raw,wiki,decisions,outputs,archive}
  touch "$root"/{raw,wiki,decisions,outputs,archive}/.gitkeep

  cat > "$root/INDEX.md" <<EOF
# ${title}

## Purpose
${purpose}

## Structure
- \`raw/\` — immutable captures, source notes, and meeting notes
- \`wiki/\` — reviewed canonical knowledge
- \`decisions/\` — decision records and rationale
- \`outputs/\` — drafts and deliverables awaiting review
- \`archive/\` — completed or superseded work
EOF
}

new_company_brain() {
  local slug="${1:-}" name="${2:-}"
  [[ -n "$slug" && -n "$name" ]] || fail "Usage: $0 /new-company-brain <slug> \"<company name>\""
  validate_slug "$slug"
  local root="$BRAINS_ROOT/companies/$slug"
  ensure_new_dir "$root"
  info "Creating company brain: $name"
  write_common_files "$root" "$name Brain" "Company-specific operating context, decisions, and delivery knowledge."
  mkdir -p "$root"/{operations,people,finance,marketing,technology,.profiles}
  touch "$root"/{operations,people,finance,marketing,technology}/.gitkeep

  cat > "$root/AGENTS.md" <<EOF
# ${name} C-Suite Guardrails

## Boundary rules (critical)
- **Directory boundary:** Only read and write within this brain directory (\`$root/\`). Never access files outside this directory.
- **Cross-brain isolation:** Never read or write to other company/project brains. Route via personal brain if cross-brain context is needed.
- **Raw immutability:** Treat \`raw/\` as immutable source material. Never overwrite, delete, or modify raw captures.
- **Wiki protection:** Never write directly to \`wiki/\`. Promote from \`outputs/\` only after human review.

## Shared rules
- Read INDEX.md and relevant context before substantive work.
- Draft in \`outputs/\` and promote only after human review.
- Record material decisions with rationale in \`decisions/\`.
- Mark drafts clearly with status headers (e.g., \`## Status: Draft | Review | Approved\`).
- Escalate cross-functional conflicts and irreversible actions to the CEO/human owner.

## Roles
- CEO: strategy, priorities, major decisions; \`outputs/strategy/\` and \`decisions/\`.
- COO: operations, SOPs, delivery; \`operations/\` and \`outputs/operations/\`.
- CFO: finance, pricing, unit economics; \`finance/\` and \`outputs/finance/\`.
- CMO: positioning, content, campaigns; \`marketing/\` and \`outputs/marketing/\`.
- CTO: systems, automation, technical architecture; \`technology/\` and \`outputs/technology/\`.
- COS: triage, coordination, sequencing; \`outputs/coordination/\`.
EOF

  cat > "$root/operations/CONTEXT.md" <<EOF
# Operating Context

## Business model
[Describe the offer, customer, and revenue model.]

## Current priorities
- [Priority]

## Key metrics
- Revenue / cash
- Customer count / retention
- Delivery quality / throughput

## Cadence
- Weekly: metrics and operating review
- Monthly: financial close and strategic review
- Quarterly: objectives and resource planning

## Escalation
- Decision owner: [Name]
- Urgent customer issue: [Process]
- Financial approval: [Process]
EOF

  local role
  for role in ceo coo cfo cmo cto cos; do
    cat > "$root/.profiles/$role.yaml" <<EOF
name: ${name} ${role^^}
brain: ~/Brains/companies/${slug}
model: nvidia/llama-3.1-70b-instruct
system_prompt: |
  You are the ${role^^} for ${name}.
  
  ## Boundaries (critical)
  - Only read and write within this brain directory. Never access files outside this directory.
  - Never read or write to other company/project brains.
  - Never write directly to wiki/. Promote from outputs/ only after human review.
  - Treat raw/ as immutable; never overwrite source captures.
  
  ## Operating rules
  - Read AGENTS.md, INDEX.md, and relevant context before substantive work.
  - Respect the role boundaries and output locations in AGENTS.md.
  - Draft in outputs/; never present drafts as approved facts or decisions.
  - Mark drafts with status headers (Draft | Review | Approved).
EOF
  done

  info "Created $root"
  printf 'Next: complete %s/operations/CONTEXT.md and copy .profiles/*.yaml to ~/.hermes/profiles/ if needed.\n' "$root"
}

new_personal_brain() {
  local root="$BRAINS_ROOT/personal"
  ensure_new_dir "$root"
  info "Creating personal brain"
  write_common_files "$root" "Personal Brain" "Personal priorities, cross-company patterns, and durable knowledge."
  mkdir -p "$root/.profiles"

  cat > "$root/AGENTS.md" <<'EOF'
# Personal Brain Guardrails

## Boundary rules (critical)
- **Directory boundary:** Only read and write within this brain directory (`~/Brains/personal/`). Never access files outside this directory.
- **Cross-brain isolation:** Never read or write to company/project brains directly. Create routing notes to move material to appropriate brains.
- **Raw immutability:** Treat `raw/` as immutable source material. Never overwrite or delete raw captures.
- **Wiki protection:** Never write directly to `wiki/`. Promote from `outputs/` only after human review.
- **Company separation:** Never mix company-specific facts into personal canonical knowledge. Keep company context in company brains.

## Role
Capture, organize, and route information without mixing company-specific facts into personal canonical knowledge.

## Rules
- Read INDEX.md before substantive work.
- Put incoming material in `raw/` and reviewed knowledge in `wiki/`.
- Create a routing note when material belongs to a company or project brain.
- Keep private, sensitive, or unverified information clearly labeled.
- Draft in `outputs/` and archive only completed work.
EOF

  cat > "$root/.profiles/personal.yaml" <<'EOF'
name: Personal Agent
brain: ~/Brains/personal
model: nvidia/llama-3.1-70b-instruct
system_prompt: |
  You manage personal knowledge capture, triage, and routing.
  
  ## Boundaries (critical)
  - Only read and write within this brain directory. Never access files outside this directory.
  - Never read or write to company/project brains directly. Create routing notes instead.
  - Never write directly to wiki/. Promote from outputs/ only after human review.
  - Never mix company-specific facts into personal canonical knowledge.
  - Treat raw/ as immutable; never overwrite source captures.
  
  ## Operating rules
  - Read AGENTS.md and INDEX.md before substantive work.
  - Preserve source context, distinguish drafts from approved knowledge.
  - Route company/project work via routing notes to dedicated brains.
EOF

  info "Created $root"
}

new_project() {
  local slug="${1:-}" name="${2:-}"
  [[ -n "$slug" && -n "$name" ]] || fail "Usage: $0 /new-project <slug> \"<project name>\""
  validate_slug "$slug"
  local root="$BRAINS_ROOT/projects/$slug"
  ensure_new_dir "$root"
  info "Creating project brain: $name"
  write_common_files "$root" "$name Project Brain" "A focused initiative with defined outcomes, milestones, and ownership."
  mkdir -p "$root"/{plans,risks,.profiles}
  touch "$root"/{plans,risks}/.gitkeep

  cat > "$root/AGENTS.md" <<EOF
# ${name} Project Guardrails

## Boundary rules (critical)
- **Directory boundary:** Only read and write within this brain directory (\`$root/\`). Never access files outside this directory.
- **Cross-brain isolation:** Never read or write to other company/project brains. Route via personal brain if cross-brain context is needed.
- **Raw immutability:** Treat \`raw/\` as immutable source material. Never overwrite or delete raw captures.
- **Wiki protection:** Never write directly to \`wiki/\`. Promote from \`outputs/\` only after human review.
- **Scope boundary:** Keep all work within the agreed project scope. Escalate scope changes before proceeding.

## Role
Plan, coordinate, and execute work toward the project outcome.

## Rules
- Read INDEX.md before substantive work and keep work within project scope.
- Store plans in \`plans/\`, risks and dependencies in \`risks/\`, and decisions in \`decisions/\`.
- Put working drafts and deliverables in \`outputs/\`.
- Escalate scope, timeline, budget, or ownership changes to the project sponsor.
- Archive completed artifacts; do not silently overwrite source material.
EOF

  cat > "$root/.profiles/project.yaml" <<EOF
name: ${name} Project Agent
brain: ~/Brains/projects/${slug}
model: nvidia/llama-3.1-70b-instruct
system_prompt: |
  You coordinate ${name}.
  
  ## Boundaries (critical)
  - Only read and write within this brain directory. Never access files outside this directory.
  - Never read or write to other company/project brains.
  - Never write directly to wiki/. Promote from outputs/ only after human review.
  - Treat raw/ as immutable; never overwrite source captures.
  - Keep work within the agreed project scope.
  
  ## Operating rules
  - Read AGENTS.md and INDEX.md before substantive work.
  - Document decisions and risks in their respective directories.
  - Escalate material changes (scope, timeline, budget, ownership) to the project sponsor.
EOF

  info "Created $root"
}

case "${1:-}" in
  /new-company-brain) shift; new_company_brain "$@" ;;
  /new-personal-brain) shift; new_personal_brain "$@" ;;
  /new-project) shift; new_project "$@" ;;
  *)
    cat <<EOF
Usage:
  $0 /new-company-brain <slug> "<company name>"
  $0 /new-personal-brain
  $0 /new-project <slug> "<project name>"

Set BRAINS_ROOT to override the default: ~/Brains
EOF
    ;;
esac
