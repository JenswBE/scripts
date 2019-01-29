#!/bin/bash
set -euo pipefail

# Author: Jens Willemsens <jens@jensw.be>
# Date: 07/04/2018
# License: MIT

# This program generates a CSV file from a dump of transaction FPO1.
# The output file contains only the totals for each Business Partner

cat "${1}" | # Get file contents
sed 's/&nbsp;//g' | # Remove all non-breaking spaces
sed 's/background:#/\n/g' | # Append new line for each row
iconv -f iso8859-1 -t utf-8 | # Convert charset, otherwise grep will fail
grep -E '^(f0f008|fbc36e)' | # Filter rows for BP number and totals
sed 's/<\/nobr><\/font><\/td>  <\/tr>.*//' | # Remove html after data
sed 's/fbc36e.*://' | # Remove html before partner
sed 's/.*EUR//' | # Remove html before total
awk '{partner=$0; getline; print partner "; " $0;}' > "${1}.csv" # Merge every 2 lines into 1 CSV line and write output file
