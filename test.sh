#!/usr/bin/env bash
# Test dotfiles installation in Docker
# Usage: ./test.sh [--interactive]

set -e

IMAGE_NAME="dotfiles-test"

echo "Building Docker image..."
docker build -t "$IMAGE_NAME" .

if [[ "$1" == "--interactive" || "$1" == "-i" ]]; then
    echo "Starting interactive shell..."
    docker run -it --rm "$IMAGE_NAME" /bin/bash
else
    echo "Running verification..."
    docker run --rm "$IMAGE_NAME" /bin/bash -c '
        echo "=== Verifying symlinks ==="

        check_symlink() {
            if [[ -L "$1" ]]; then
                echo "✓ $1 -> $(readlink "$1")"
            elif [[ -e "$1" ]]; then
                echo "✗ $1 exists but is not a symlink"
                return 1
            else
                echo "✗ $1 does not exist"
                return 1
            fi
        }

        FAILED=0

        check_symlink ~/.bashrc || FAILED=1
        check_symlink ~/.gitconfig || FAILED=1
        check_symlink ~/.config/nvim || FAILED=1
        check_symlink ~/.vimrc || FAILED=1
        check_symlink ~/.zshrc || FAILED=1
        check_symlink ~/.tmux.conf || FAILED=1
        check_symlink ~/.config/btop || FAILED=1
        check_symlink ~/.config/fish || FAILED=1
        check_symlink ~/.config/htop || FAILED=1

        echo ""
        if [[ $FAILED -eq 0 ]]; then
            echo "=== All checks passed! ==="
        else
            echo "=== Some checks failed ==="
            exit 1
        fi
    '
fi
