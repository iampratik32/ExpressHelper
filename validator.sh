#!/bin/bash
d1=$(readlink -f "$0")
dir=${d1::-7 }
. "${dir}utility.sh"

function createValidator (){
    validName $1 "Validator"
    cName="/src/middlewares/validators"
    name="$PWD$cName"
    checkFolder $name $cName
    file="$name/$1.js"
    checkFile $1 $file
    
    cat <<-EOF > $file
const { check, validationResult } = require("express-validator")

exports.${1,} = [

    // express-validators validation here...
    
    (req, res, next) => {
        const errors = validationResult(req).array()
        if (errors.length > 0) {
            // handle error here
        }
        else next()
    }
]

EOF
    echo "Validator Created."
}