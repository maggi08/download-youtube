# download-youtube

Simple terminal tool for downloading YouTube videos via [yt-dlp](https://github.com/yt-dlp/yt-dlp). Pass URLs directly or feed in a text file with one URL per line.

## What gets installed automatically vs. manually

The Python dependency (`yt-dlp`) is installed automatically into a local virtual environment (`.venv/`) on first run. **System dependencies** must be installed manually, because they're not Python packages:

| Dependency | Why it's needed | Install command |
|---|---|---|
| **Python 3.10+** | Required by yt-dlp (3.9 was deprecated) | macOS: `brew install python@3.13` <br> Linux: `sudo apt install python3.13 python3.13-venv` |
| **ffmpeg** | Merges separate video + audio streams into one MP4 | macOS: `brew install ffmpeg` <br> Linux: `sudo apt install ffmpeg` |
| **bash** | Runs the wrapper script | Pre-installed on macOS/Linux |

## Setup on a new machine

```bash
git clone <repo-url>
cd download-youtube
chmod +x download.sh
```

That's it — the first run of `./download.sh` will:
1. Detect a Python 3.10+ interpreter
2. Create `.venv/` in the project folder
3. Install `yt-dlp` from `requirements.txt`

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
├── download.sh         # Bash wrapper: manages venv, runs Python script
├── download.py         # Python script: parses args, calls yt-dlp
├── requirements.txt    # Python dependencies (yt-dlp)
├── .gitignore          # Excludes .venv/ and downloaded media
└── README.md
```

## Troubleshooting

**`Python 3.10+ not found`** — Install Python via the commands in the table above, then re-run.

**`Warning: ffmpeg not found`** — Videos may download as separate video/audio files instead of merged MP4. Install ffmpeg.

**`HTTP Error 403: Forbidden` or `Requested format is not available`** — YouTube changed something. Update yt-dlp:
```bash
.venv/bin/pip install --upgrade 'yt-dlp[default]'
```

**Resuming an interrupted download** — Just re-run the same command. yt-dlp picks up from `.part` files automatically.
