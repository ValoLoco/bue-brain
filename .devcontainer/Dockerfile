FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    jq \
    yq \
    fzf \
    bat \
    eza \
    zoxide \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Go
RUN curl -fsSL https://go.dev/dl/go1.23.0.linux-amd64.tar.gz | tar -C /usr/local -xz
ENV PATH=$PATH:/usr/local/go/bin

ARG USERNAME=vscode
ARG USER_UID=1000

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Install Hermes Agent
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

ENV PATH="/home/${USERNAME}/.hermes/bin:${PATH}"

# Create directory structure
RUN mkdir -p /home/${USERNAME}/Brains/personal/{raw,wiki,decisions,areas,projects,outputs,archive} \
    && mkdir -p /home/${USERNAME}/Brains/companies/example-company/{raw,wiki,operations,clients,partnerships,marketing,finance,projects,decisions,outputs,archive} \
    && mkdir -p /home/${USERNAME}/Brains/projects \
    && mkdir -p /home/${USERNAME}/.hermes/profiles \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/Brains /home/${USERNAME}/.hermes

# Set up shell
RUN echo 'eval "$(zoxide init bash)"' >> /home/${USERNAME}/.bashrc \
    && echo 'alias ls="eza"' >> /home/${USERNAME}/.bashrc \
    && echo 'alias ll="eza -la"' >> /home/${USERNAME}/.bashrc \
    && echo 'alias cat="bat"' >> /home/${USERNAME}/.bashrc

USER ${USERNAME}
WORKDIR /workspaces/bue-brain

CMD ["sleep", "infinity"]
