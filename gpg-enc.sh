#!/bin/bash

gpg -c -o "$1.gpg" --cipher-algo AES256 "$1"
