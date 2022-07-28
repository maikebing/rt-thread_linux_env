#!/bin/sh
if [ ! -d ~/.env ]; then
 ln  /env ~/.env  -s
 fi
export PATH=$PATH:~/.env/tools/scripts
sed -i -e 's/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=y/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=n/g'  /env/tools/scripts/cmds/.config

if [ -f SConstruct ]; then
    pkgs --printenv
    pkgs  --list
    pkgs --update
    if [[ -z "${CPPCHECK}" ]]; then
    cppcheck ${CPPCHECK} 
    fi

    
    if [[ -z "${TARGET}" ]]; then
    scons --target=${TARGET}
    else
    scons 
    fi
else
echo "fogret checkout?"    
fi    