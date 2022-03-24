#!/bin/bash
source ./utility.sh

function createController (){
    validName $1 "Controller"
    name="$PWD/src/controllers/"
    checkFolder $name "controllers"
    file="$name/$1.js"
    checkFile $1 $file
    
    cat <<-EOF > $file
exports.index = async (req, res) => {    
   
}

exports.create = async (req,res) => {
    
}

exports.show = async (req, res) => {
    
}

exports.store = async (req, res) => {
    
}

exports.update = async (req, res) => {

}

exports.destory = async (req, res) => {
    
}

EOF
    echo "Controller Created."
}