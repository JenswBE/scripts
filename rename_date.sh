#!/bin/bash

# Settings
PREFIX="Pont "
APPENDIX=""
OTHER_EXT=( "png" "mp4" )

# Rename JPEG accordingly to EXIF
jhead -autorot -nf"${PREFIX}%Y-%m-%d %H-%M-%S %03i${APPENDIX}" *.jpg

# Rename other files accordingly to modify date
for ext in "${OTHER_EXT[@]}"
  do
  for file in *.${ext}
    do
    NEW_FILENAME=$(stat "${file}" --format %y | cut -c -19 | tr : -)
    mv "${file}" "${PREFIX}${NEW_FILENAME}${APPENDIX}.${ext}"
  done
done
