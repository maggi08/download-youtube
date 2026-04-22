#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

# Find a Python interpreter that's >= 3.10 (yt-dlp requirement)
find_python() {
    for cmd in python3.13 python3.12 python3.11 python3.10 python3 python; do
        if command -v "$cmd" >/dev/null 2>&1; then
            version=$("$cmd" -c 'import sys; print(sys.version_info[0]*100 + sys.version_info[1])' 2>/dev/null || echo 0)
            if [ "$version" -ge 310 ]; then
                echo "$cmd"
                return 0
            fi
        fi
    done
    return 1
}

# Create venv if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    PYTHON=$(find_python) || {
        echo "Error: Python 3.10+ not found. Install it first:"
        echo "  macOS:  brew install python@3.13"
        echo "  Linux:  sudo apt install python3.13 python3.13-venv"
        exit 1
    }
    echo "Creating virtual environment with $PYTHON..."
    "$PYTHON" -m venv "$VENV_DIR"
    echo "Installing dependencies..."
    "$VENV_DIR/bin/pip" install --quiet --upgrade pip
    "$VENV_DIR/bin/pip" install --quiet -r "$SCRIPT_DIR/requirements.txt"
    echo "Setup complete."
    echo ""
fi

# Check ffmpeg is available (needed for merging video+audio)
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Warning: ffmpeg not found. Install it for best quality merging:"
    echo "  macOS:  brew install ffmpeg"
    echo "  Linux:  sudo apt install ffmpeg"
    echo ""
fi

# Run the downloader
"$VENV_DIR/bin/python" "$SCRIPT_DIR/download.py" "$@"
