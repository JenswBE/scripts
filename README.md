# :warning: Archived this repo in favor of https://github.com/JenswBE/setup/tree/main/scripts

# Scripts
Some usefull Bash and Powershell scripts

## Bash

### extract-audio-dl
Downloads video with youtube-dl and extracts audio into Ogg Opus format

#### Dependencies
- youtube-dl
- ffmpeg / avconv


### gpg-enc
Small helper to encrypt a file to <filename>.gpg using AES256. Passphrase is asked at execution.

#### Dependencies
- gpg


### rename_date
Renames media files accordingly to the EXIF or modification date

#### Dependencies
- jhead


### snapshot_photos
For each top directory: Tar contents, compresses with BZIP2 and encrypts with AES256

#### Dependencies
- gpg
- parallel

### git_pull_subdirs
Running in a directory, will execute `git pull` in each subdirectory.

**Big thanks to following authors in the [StackOverflow questions](https://stackoverflow.com/questions/3497123/run-git-pull-over-all-subdirectories):**
- [Petah](https://stackoverflow.com/users/268074/petah)
- [leo](https://stackoverflow.com/users/1658147/leo)
- [Zarat](https://stackoverflow.com/users/578323/zarat)

### SAP: fpo1-to-csv
This program generates a CSV file from a dump of transaction FPO1 in SAP.
The output file contains only the totals for each Business Partner.

### SAP: unconverted-to-csv
This program generates a CSV file from "Save to local file - Unconverted".

### SAP: bootstrapHANA
Bootstraps a VPS or server with HANA express on docker.
*Warning*: To be executed as root, a new user will be created and root will be disabled. Also ufw will be enabled.

## Powershell

### KillHandle
Applies an additional regex filter to handle's output, writes an overview to STDOUT and optionally kills the processes in the list

#### Dependencies
- handle.exe or handle64.exe (https://docs.microsoft.com/en-us/sysinternals/downloads/handle)
