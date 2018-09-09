#!/bin/bash

# Rename JPEG accordingly to EXIF
jhead -autorot -nf"Pont %Y-%m-%d %H-%M-%S %03i" *.jpg

# Rename other files accordingly to modify date
for ext in mp4 png
  do
  for file in *.${ext}
    do
    NEW_FILENAME=$(stat "${file}" --format %y | cut -c -19 | tr : -)
    mv "${file}" "Pont ${NEW_FILENAME}.${ext}"
  done
done
