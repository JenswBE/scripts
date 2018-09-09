# scripts
Some usefull bash scripts

## gpg-enc
Small helper to encrypt a file to <filename>.gpg using AES256. Passphrase is asked at execution.

### Dependencies
- gpg


## rename_date
Renames media files accordingly to the EXIF or modification date

### Dependencies
- jhead


## snapshot_photos
For each top directory: Tar contents, compresses with BZIP2 and encrypts with AES256

### Dependencies
- gpg
- parallel
