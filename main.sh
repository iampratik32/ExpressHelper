#!/bin/bash

function init(){
    src="$PWD/src"
    if [ ! -d $src ]; then
        npm init
        mkdir -p $src
        folders=("config" "controllers" "models" "routes" "utilities")
        for fo in ${folders[@]}; do
            folder $fo
        done
        readAll
    else
        echo "Remove Src Folder And Continue? All Your Items In Src Folder Will Be Lost [N/Y]"
        read remove
        if [ "${remove^^}" = "Y" ]; then
            rm -rf $src
            init
        fi
    fi
}

function readAll(){
    echo "Enter Your Required Packages"
    read all
    npm i $all
    
}

function folder(){
    src="$PWD/src/$1"
    if [ ! -d $src ]; then
        mkdir -p $src
    fi
}


"$@"