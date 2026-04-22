# download-youtube

Simple terminal tool for downloading YouTube videos via [yt-dlp](https://github.com/yt-dlp/yt-dlp). Pass URLs directly or feed in a text file with one URL per line.

## Setup on a new machine

Two steps — like `npm install` then `npm run`:

```bash
git clone <repo-url>
cd download-youtube
chmod +x install.sh download.sh

# Step 1: install everything (system + Python deps)
./install.sh

# Step 2: download
./download.sh "https://youtu.be/VIDEO_ID"
```

### What `install.sh` does

It checks for and installs everything needed:

| Dependency | Why it's needed | Auto-installed by |
|---|---|---|
| **Python 3.10+** | Required by yt-dlp | `brew install python@3.13` (macOS) or `sudo apt install python3.13 python3.13-venv` (Linux) |
| **ffmpeg** | Merges video + audio streams into one MP4 | `brew install ffmpeg` (macOS) or `sudo apt install ffmpeg` (Linux) |
| **yt-dlp** | The actual downloader | `pip install` into local `.venv/` |

Supported platforms: **macOS** (via Homebrew) and **Debian/Ubuntu Linux** (via apt). On other systems, install Python 3.10+ and ffmpeg manually, then re-run `./install.sh` — it will skip what's already there and just create the venv.

After `install.sh` finishes, everything lives in `.venv/` — `download.sh` runs from there with no further setup.

## Usage

```bash
# Single video (always quote URLs — they contain ? and & which the shell interprets)
./download.sh "https://youtu.be/VIDEO_ID"

# Multiple videos at once
./download.sh "URL1" "URL2" "URL3"

# Bulk download from a text file
./download.sh links.txt

# Choose where to save downloads
./download.sh -o ~/Downloads "URL1" "URL2"
./download.sh --output /path/to/folder links.txt

# Show all options
./download.sh --help
```

### Where files are saved

The output folder is decided in this order:
1. `-o` / `--output` flag, if provided
2. Folder containing the `.txt` file, if you passed one
3. Current working directory

The folder is created automatically if it doesn't exist.

### What multi-link output looks like

When you pass multiple URLs, the script prints a clear header per video and a summary at the end:

```
============================================================
Downloading 3 video(s)
Destination: /Users/you/Downloads
============================================================

[1/3] https://youtu.be/aaa
------------------------------------------------------------
[youtube] aaa: Downloading webpage
[download] 100% of 45.2MiB at 8.21MiB/s
  ✓ [1/3] Done: First Video Title

[2/3] https://youtu.be/bbb
------------------------------------------------------------
[youtube] bbb: Downloading webpage
[download] 100% of 120.4MiB at 9.55MiB/s
  ✓ [2/3] Done: Second Video Title

[3/3] https://youtu.be/ccc
------------------------------------------------------------
ERROR: Video unavailable
  ✗ [3/3] Failed: Video unavailable

============================================================
Summary: 2 succeeded, 1 failed (of 3)
============================================================

Failed downloads:
  - https://youtu.be/ccc
      Video unavailable
```

If any video fails the script exits with code 1, so you can chain it in shell pipelines.

### Text file format

One URL per line. Lines starting with `#` are treated as comments:

```
# Music videos
https://youtu.be/abc123
https://youtu.be/def456

# Tutorials
https://youtube.com/watch?v=ghi789
```

## What it downloads

- Best available quality, MP4 format
- Video and audio merged into a single file
- Saved as `<video_title>.mp4`

## Project structure

```
download-youtube/
├── install.sh          # One-time setup: installs system deps + creates venv
├── download.sh         # Runs the downloader from .venv/
├── download.py         # Python script: parses args, calls yt-dlp
├── requirements.txt    # Python dependencies (yt-dlp)
├── .gitignore          # Excludes .venv/ and downloaded media
└── README.md
```

## Troubleshooting

**`Error: virtual environment not found`** — Run `./install.sh` first.

**`Error: Homebrew is required`** (macOS) — Install Homebrew from https://brew.sh, then re-run `./install.sh`.

**`HTTP Error 403: Forbidden` or `Requested format is not available`** — YouTube changed something. Refresh the deps:
```bash
.venv/bin/pip install --upgrade -r requirements.txt
```

**Resuming an interrupted download** — Just re-run the same command. yt-dlp picks up from `.part` files automatically.

**Starting over from scratch** — Delete `.venv/` and re-run `./install.sh`.
