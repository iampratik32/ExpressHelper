#!/bin/bash

function validName(){
    if [[ $1 =~ ['!@#$%^&*()-_+'] ]]; then
        echo "Enter A Valid $2 Name"
        exit
    fi
}

function checkFile(){
    if [ -f "$2" ]; then
        echo "$1$3 Already Exists..."
        exit
    fi
}

function checkFolder(){
    if [ ! -d "$1" ]; then
        echo "src/$2 Folder Does Not Exist"
        exit   
    fi
}