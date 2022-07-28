#!/usr/bin/env bash
if [ ! -d ~/.env ]; then ln  /env ~/.env  -s;fi
export PATH=$PATH:~/.env/tools/scripts
sed -i -e 's/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=y/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=n/g'  /env/tools/scripts/cmds/.config
