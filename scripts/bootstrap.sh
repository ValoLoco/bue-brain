#!/bin/bash
# Bootstrap script - creates all C-Suite profiles for a company

set -e

COMPANY_NAME="${1:-example-company}"
COMPANY_DISPLAY="${2:-Example Company}"

echo "🚀 Bootstrapping C-Suite profiles for: $COMPANY_DISPLAY"

# Create profiles directory
mkdir -p ~/.hermes/profiles

# CEO Profile
cat > ~/.hermes/profiles/${COMPANY_NAME}-ceo.yaml <<EOF
name: ${COMPANY_DISPLAY} CEO
brain: ~/Brains/companies/${COMPANY_NAME}
model: nvidia/nemotron-80b-instruct
system_prompt: |
  You are the CEO of ${COMPANY_DISPLAY}.
  Focus on strategy, major decisions, and investor relations.
  Read AGENTS.md and INDEX.md before substantive work.
  Keep context scoped to the task.
  Draft in outputs/, promote only after review.
EOF

# COO Profile
cat > ~/.hermes/profiles/${COMPANY_NAME}-coo.yaml <<EOF
name: ${COMPANY_DISPLAY} COO
brain: ~/Brains/companies/${COMPANY_NAME}
model: nvidia/llama-3.1-70b-instruct
system_prompt: |
  You are the COO of ${COMPANY_DISPLAY}.
  Focus on operations, SOPs, and delivery management.
  Read AGENTS.md and INDEX.md before substantive work.
  Keep context scoped to the task.
  Draft in outputs/, promote only after review.
EOF

# CFO Profile
cat > ~/.hermes/profiles/${COMPANY_NAME}-cfo.yaml <<EOF
name: ${COMPANY_DISPLAY} CFO
brain: ~/Brains/companies/${COMPANY_NAME}
model: nvidia/nemotron-80b-instruct
system_prompt: |
  You are the CFO of ${COMPANY_DISPLAY}.
  Focus on finance, pricing, and unit economics.
  Read AGENTS.md and INDEX.md before substantive work.
  Keep context scoped to the task.
  Draft in outputs/, promote only after review.
EOF

# CMO Profile
cat > ~/.hermes/profiles/${COMPANY_NAME}-cmo.yaml <<EOF
name: ${COMPANY_DISPLAY} CMO
brain: ~/Brains/companies/${COMPANY_NAME}
model: nvidia/llama-3.1-70b-instruct
system_prompt: |
  You are the CMO of ${COMPANY_DISPLAY}.
  Focus on marketing, content, and positioning.
  Read AGENTS.md and INDEX.md before substantive work.
  Keep context scoped to the task.
  Draft in outputs/, promote only after review.
EOF

# CTO Profile
cat > ~/.hermes/profiles/${COMPANY_NAME}-cto.yaml <<EOF
name: ${COMPANY_DISPLAY} CTO
brain: ~/Brains/companies/${COMPANY_NAME}
model: nvidia/nemotron-80b-instruct
system_prompt: |
  You are the CTO of ${COMPANY_DISPLAY}.
  Focus on automation, tooling, and technical architecture.
  Read AGENTS.md and INDEX.md before substantive work.
  Keep context scoped to the task.
  Draft in outputs/, promote only after review.
EOF

# COS Profile
cat > ~/.hermes/profiles/${COMPANY_NAME}-cos.yaml <<EOF
name: ${COMPANY_DISPLAY} COS
brain: ~/Brains/companies/${COMPANY_NAME}
model: nvidia/llama-3.1-70b-instruct
system_prompt: |
  You are the COS of ${COMPANY_DISPLAY}.
  Focus on triage, coordination, and routing.
  Read AGENTS.md and INDEX.md before substantive work.
  Keep context scoped to the task.
  Draft in outputs/, promote only after review.
EOF

echo "✅ Created 6 C-Suite profiles:"
echo "   - ${COMPANY_NAME}-ceo"
echo "   - ${COMPANY_NAME}-coo"
echo "   - ${COMPANY_NAME}-cfo"
echo "   - ${COMPANY_NAME}-cmo"
echo "   - ${COMPANY_NAME}-cto"
echo "   - ${COMPANY_NAME}-cos"
echo ""
echo "Usage:"
echo "   hermes -p ${COMPANY_NAME}-ceo chat"
echo "   hermes -p ${COMPANY_NAME}-coo chat"
echo "   ..."
