#!/bin/bash
# Create a new company brain and C-Suite profiles

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <company-name> <company-display-name>"
    echo "Example: $0 acme-corp \"Acme Corporation\""
    exit 1
fi

COMPANY_NAME="$1"
COMPANY_DISPLAY="$2"

echo "🏢 Creating company: $COMPANY_DISPLAY ($COMPANY_NAME)"

# Create brain folder structure
mkdir -p ~/Brains/companies/${COMPANY_NAME}/{raw,wiki,decisions,outputs,archive,operations}

# Create INDEX.md
cat > ~/Brains/companies/${COMPANY_NAME}/INDEX.md <<EOF
# ${COMPANY_DISPLAY} Brain Index

## Purpose
Company-specific context, operations, and decision records.

## Structure
- raw/ - Incoming captures and meeting notes
- wiki/ - Distilled company knowledge
- decisions/ - Strategic decisions with rationale
- outputs/ - Drafts and generated materials
- operations/ - SOPs and runbooks

## Active Context
- Current priorities and OKRs
- Team structure and stakeholders
- Product/service offerings
EOF

# Create AGENTS.md
cat > ~/Brains/companies/${COMPANY_NAME}/AGENTS.md <<EOF
# C-Suite Agents

## CEO Agent
**Profile:** ${COMPANY_NAME}-ceo
- Strategy, major decisions, investor relations

## COO Agent
**Profile:** ${COMPANY_NAME}-coo
- Operations, SOPs, delivery management

## CFO Agent
**Profile:** ${COMPANY_NAME}-cfo
- Finance, pricing, unit economics

## CMO Agent
**Profile:** ${COMPANY_NAME}-cmo
- Marketing, content, positioning

## CTO Agent
**Profile:** ${COMPANY_NAME}-cto
- Automation, tooling, technical architecture

## COS Agent
**Profile:** ${COMPANY_NAME}-cos
- Triage, coordination, routing
EOF

# Create operations/CONTEXT.md
mkdir -p ~/Brains/companies/${COMPANY_NAME}/operations
cat > ~/Brains/companies/${COMPANY_NAME}/operations/CONTEXT.md <<EOF
# Operations Context

## Business Model
[Describe core offering and revenue model]

## Target Market
[Primary customer segments and use cases]

## Key Metrics
- MRR/ARR
- Customer count
- Churn rate
- LTV/CAC
EOF

echo "✅ Created brain folder structure"

# Create C-Suite profiles
bash scripts/bootstrap.sh ${COMPANY_NAME} "${COMPANY_DISPLAY}"

echo ""
echo "✅ Company setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit ~/Brains/companies/${COMPANY_NAME}/operations/CONTEXT.md"
echo "2. Start using C-Suite agents:"
echo "   hermes -p ${COMPANY_NAME}-ceo chat"
echo "   hermes -p ${COMPANY_NAME}-coo chat"
