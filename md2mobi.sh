#!/bin/bash
# Convert all markdown files in the current directory to MOBI format using calibre.
set -euo pipefail

for i in *.md; do
    target=`basename -s md "$i"`
    ebook-convert "$i" "$target"mobi;
done
