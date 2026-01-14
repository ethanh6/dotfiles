# Dockerfile for testing dotfiles installation
# Usage:
#   docker build -t dotfiles-test .
#   docker run -it dotfiles-test

FROM ubuntu:22.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal dependencies needed for install.sh
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user (stow needs this for ~/)
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Copy dotfiles into container
COPY --chown=testuser:testuser . /home/testuser/dotfiles

# Run the install script
RUN cd dotfiles && ./install.sh

# Verify symlinks were created
RUN ls -la ~/.bashrc ~/.gitconfig ~/.config/nvim ~/.zshrc 2>/dev/null || true

# Default shell
CMD ["/bin/bash"]
