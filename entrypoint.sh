#!/bin/sh
ln  /env $HOME/.env  -s
export PATH=$PATH:$HOME/.env/tools/scripts
sed -i -e 's/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=y/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=n/g'  /env/tools/scripts/cmds/.config
if [ -r SConstruct ]; then
    pkgs --printenv
    pkgs --list
    pkgs --update
    if [ -z "${CPPCHECK}" ]; then
        cppcheck ${CPPCHECK} 
    fi

    if [-z "${TARGET}" ]; then
    scons --target=${TARGET}
    else
    scons 
    fi
else
pkgs --help
echo "fogret checkout?"    
fi    