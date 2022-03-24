#!/bin/bash
d1=$(readlink -f "$0")
dir=${d1::-7 }
. "${dir}utility.sh"

function createRoute(){
    validName $1 "Route"
    cName="/src/routes"
    name="$PWD$cName"
    checkFolder $name $cName
    file="$name/$1.js"
    checkFile $1 $file

    cat <<-EOF > $file
const express = require('express')
const routes = express.Router()

module.exports = () => {
    
    routes.get('/',(req,res)=>res.send('Hello World'))

    return routes
}

EOF
    echo "Route Created."
}