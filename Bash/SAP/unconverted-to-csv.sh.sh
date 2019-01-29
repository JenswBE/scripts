#!/bin/bash
set -euo pipefail

# Author: Jens Willemsens <jens@jensw.be>
# Date: 29/01/2019
# License: MIT

# usage: unconverted-to-csv.sh <FILE> <HEADER>

# This program converts SAP "Unconverted" output to a csv file

tail -n +9 "${1}"  | # Read file and skip first 8 lines
iconv -f iso8859-1 -t utf-8 | # Convert file to utf-8 to make sure all replacements are executed correctly
sed 's/|//' | # Remove leading separator
sed 's/|/;/g' | # Replace separators with ";"
sed 's/\(.*\);/\1/' | # Remove trailing separator
sed "1s/^/${2}\r\n/" | # Insert header
 head -n -1 # Remove bottom border

