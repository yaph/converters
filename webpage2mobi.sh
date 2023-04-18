#!/bin/bash
# Convert web pages to ebooks in MOBI format using wget and calibre.
set -euo pipefail

# Assign and check that URL argument is provided
URL=${1:-}
if [ -z "$URL" ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

# Download the webpage
# --level=inf: follows links to an unlimited depth (useful for downloading all linked assets)
# --no-clobber: don't overwrite any existing files, so you can run the script multiple times without re-downloading everything
# --page-requisites: downloads all necessary files to display the page, including CSS files, images, and JavaScript files
# --html-extension: save the downloaded HTML file with a .html extension, even if the original URL didn't have one
# --convert-links: converts all links in the downloaded files to relative links so they work offline
# --restrict-file-names=windows: replace any characters in filenames that are illegal on Windows (such as : or ?) with underscores
wget --level=inf --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows "$URL"

# Parse the host name from the URL
host=$(echo "$URL" | cut -d"/" -f3)

# Determine name of downloaded HTML file
html_file=$(find "$host" -name "*.html" -o -name "*.htm" | head -1)
if [ -z "$html_file" ]; then
  echo "No HTML file found in $subdir"
  exit 1
fi

# Convert HTML file to EPUB using calibre
ebook-convert "$html_file" "$(basename "$URL" .html).mobi" --output-profile kindle_pw