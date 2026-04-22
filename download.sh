#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

# Create venv if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    /opt/homebrew/bin/python3.13 -m venv "$VENV_DIR"
    echo "Installing dependencies..."
    "$VENV_DIR/bin/pip" install --quiet 'yt-dlp[default]'
    echo "Setup complete."
    echo ""
fi

# Run the downloader
"$VENV_DIR/bin/python" "$SCRIPT_DIR/download.py" "$@"
