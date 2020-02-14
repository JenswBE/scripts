#!/bin/bash

# Author: Jens Willemsens <jens@jensw.be>
# License: MIT
#
# === Purpose ===
# Downloads video with youtube-dl and extracts audio into Ogg Opus format

# -i: Ignore errors
# -x: Extract audio
youtube-dl -i -x --audio-format opus $@
