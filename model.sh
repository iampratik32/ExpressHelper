#!/bin/bash
source ./utility.sh

function createModel(){
    validName $1 "Model"
    name="$PWD/src/models/"
    checkFolder $name "models"
    createNewModel $1 $name
    handleParams $1 $2
}

function handleParams(){
    params=$2
    if [[ ${#params} -gt 1 ]]; then
        first=${params:1:1}
        second=${params:2:1}
        if [[ $first != "" ]]; then
            checkParam $first $1
        fi
        if [[ $second != "" ]]; then
            checkParam $second $1
        fi
    fi
}

function checkParam(){
    if [[ $1 == "c" ]]; then
        source ./controller.sh
        createController "${2}Controller"
    elif [[ $1 == "v" ]]; then
        echo "Create Validator"
    fi
}


function createNewModel(){
    file="$2$1.js"
    checkFile $1 $file " Model"

    name="${1,,}s"
    cat <<-EOF > $file
const Sequelize = require('sequelize')
const db = require('../config/db')

const $1 = db.define('$1', {
    
}, { tableName: '$name' })

$1.sync({ alter: false })

module.exports = $1

EOF
echo "Model Created."
}