#!/bin/bash
# Convert web pages to ebooks in MOBI format using wget and calibre.
set -euo pipefail

# Assign and check that URL argument is provided
URL=${1:-}
if [ -z "$URL" ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR" || exit
# Download the webpage
# --user-agent: acts like a browser so all images get downloaded
# --level=inf: follows links to an unlimited depth (useful for downloading all linked assets)
# --no-clobber: don't overwrite any existing files, so you can run the script multiple times without re-downloading everything
# --page-requisites: downloads all necessary files to display the page, including CSS files, images, and JavaScript files
# --html-extension: save the downloaded HTML file with a .html extension, even if the original URL didn't have one
# --convert-links: converts all links in the downloaded files to relative links so they work offline
# --restrict-file-names=windows: replace any characters in filenames that are illegal on Windows (such as : or ?) with underscores
wget --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" \
  --level=inf \
  --no-clobber \
  --page-requisites \
  --html-extension \
  --convert-links \
  --restrict-file-names=windows "$URL"

# Parse the host name from the URL
host=$(echo "$URL" | cut -d"/" -f3)

# Determine name of downloaded HTML file
html_file=$(find "$host" -name "*.html" -o -name "*.htm" | head -1)
if [ -z "$html_file" ]; then
  echo "No HTML file found."
  exit 1
fi

# Get full path name
html_file=$(realpath "$html_file")
# return to current directory
cd -

# Convert HTML file to EPUB using calibre
ebook-convert "$html_file" "$(basename "$URL" .html).mobi" --output-profile kindle --allow-local-files-outside-root

# Remove temporary directory
rm -rf "$TMP_DIR"
