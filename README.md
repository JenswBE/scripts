# scripts
Some usefull bash scripts

## Bash

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
