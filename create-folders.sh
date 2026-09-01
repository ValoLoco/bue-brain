#!/usr/bin/env bash
# Create the complete brain folder structure with .gitkeep files
# Run this after complete-setup.sh to have all folders ready

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Creating brain folder structure..."

# Personal brain
mkdir -p "$ROOT_DIR/brains/personal"/{raw,wiki,decisions,outputs,archive}
mkdir -p "$ROOT_DIR/brains/personal/areas"/{founder,learning,health,finance,relationships,systems}
mkdir -p "$ROOT_DIR/brains/personal/projects"

# Example company brain
mkdir -p "$ROOT_DIR/brains/companies/example-company"/{raw,wiki,decisions,outputs,archive}
mkdir -p "$ROOT_DIR/brains/companies/example-company/operations"/{sops,templates,automation,tools}
mkdir -p "$ROOT_DIR/brains/companies/example-company/clients"
mkdir -p "$ROOT_DIR/brains/companies/example-company/partnerships"
mkdir -p "$ROOT_DIR/brains/companies/example-company/marketing"/{content-calendar,seo-articles,social}
mkdir -p "$ROOT_DIR/brains/companies/example-company/finance"/{pricing,unit-economics,reports}
mkdir -p "$ROOT_DIR/brains/companies/example-company/projects"

# Projects folder
mkdir -p "$ROOT_DIR/brains/projects"

# Create .gitkeep files in all folders
find "$ROOT_DIR/brains" -type d -empty -exec touch {}/.gitkeep \;

echo "✅ Created folder structure:"
echo ""
echo "brains/"
echo "├── personal/"
echo "│   ├── raw/"
echo "│   ├── wiki/"
echo "│   ├── decisions/"
echo "│   ├── areas/"
echo "│   │   ├── founder/"
echo "│   │   ├── learning/"
echo "│   │   ├── health/"
echo "│   │   ├── finance/"
echo "│   │   ├── relationships/"
echo "│   │   └── systems/"
echo "│   ├── projects/"
echo "│   ├── outputs/"
echo "│   └── archive/"
echo "├── companies/"
echo "│   └── example-company/"
echo "│       ├── raw/"
echo "│       ├── wiki/"
echo "│       ├── operations/"
echo "│       │   ├── sops/"
echo "│       │   ├── templates/"
echo "│       │   ├── automation/"
echo "│       │   └── tools/"
echo "│       ├── clients/"
echo "│       ├── partnerships/"
echo "│       ├── marketing/"
echo "│       │   ├── content-calendar/"
echo "│       │   ├── seo-articles/"
echo "│       │   └── social/"
echo "│       ├── finance/"
echo "│       │   ├── pricing/"
echo "│       │   ├── unit-economics/"
echo "│       │   └── reports/"
echo "│       ├── projects/"
echo "│       ├── decisions/"
echo "│       ├── outputs/"
echo "│       └── archive/"
echo "└── projects/"
echo ""
echo "All folders contain .gitkeep files to track them in git."
