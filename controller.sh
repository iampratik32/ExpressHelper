#!/bin/bash
d1=$(readlink -f "$0")
dir=${d1::-7 }
. "${dir}utility.sh"

function createController (){
    validName $1 "Controller"
    cName="/src/controllers"
    name="$PWD$cName"
    checkFolder $name $cName
    file="$name/$1.js"
    checkFile $1 $file
    handleParams $2 $file
}

function handleParams(){
    params=$1
    if [ ${#params} == 2 ]; then
        first=${params:1:1}
        if [ $first == "a" ]; then
            fun=("index" "show" "store" "update" "destroy")
        elif [ $first == "w" ]; then
            fun=("index" "show" "store" "update" "destroy" "create" "edit")
        else
            fun=("index")
        fi
        writeFile $fun $2
    else
        fun=("index")
        writeFile $fun $2
    fi
}

function writeFile (){
    fun=$1
    everything=()
    for fo in ${fun[@]}; do
        element="exports.$fo-=-async-(req,-res)-=>-{}"
        everything+=(`echo $element`)
    done    
    
    cat <<-EOF > $file
${everything[0]//-/ }
${everything[1]//-/ }
${everything[2]//-/ }
${everything[3]//-/ }
${everything[4]//-/ }
${everything[5]//-/ }
${everything[6]//-/ }
EOF

    perl -pi -w -e 's/^\n$//' $file
    sed -i 'G;' $file
    perl -pi -e 'chomp if eof' $file
    echo "Controller Created."

}