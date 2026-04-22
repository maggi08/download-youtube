import sys
import os
import yt_dlp


def download(url, output_dir):
    opts = {
        "format": "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best",
        "outtmpl": os.path.join(output_dir, "%(title)s.%(ext)s"),
        "merge_output_format": "mp4",
        "quiet": False,
        "no_warnings": False,
        "extractor_args": {"youtube": {"player_client": ["android_vr", "web"]}},
    }
    with yt_dlp.YoutubeDL(opts) as ydl:
        ydl.download([url])


def read_links_from_file(filepath):
    links = []
    with open(filepath, "r") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                links.append(line)
    return links


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  ./download.sh <youtube_url> [url2] [url3] ...")
        print("  ./download.sh links.txt")
        sys.exit(1)

    links = []
    output_dir = os.getcwd()

    for arg in sys.argv[1:]:
        if os.path.isfile(arg):
            output_dir = os.path.dirname(os.path.abspath(arg))
            links.extend(read_links_from_file(arg))
        else:
            links.append(arg)

    if not links:
        print("No links found.")
        sys.exit(1)

    print(f"Downloading {len(links)} video(s) to: {output_dir}\n")

    for i, link in enumerate(links, 1):
        print(f"[{i}/{len(links)}] {link}")
        try:
            download(link, output_dir)
            print(f"  Done.\n")
        except Exception as e:
            print(f"  Failed: {e}\n")


if __name__ == "__main__":
    main()
