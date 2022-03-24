#!/bin/bash
d1=$(readlink -f "$0")
dir=${d1::-7 }

function model(){
    . "${dir}model.sh"
    createModel $1 $2
}

function controller(){
    . "${dir}controller.sh"
    createController $1
}

function validator(){
    . "${dir}validator.sh"
    createValidator $1
}

function route(){
    . "${dir}route.sh"
    createRoute $1
}

function remove(){
    src="$PWD/src"
    node="$PWD/node_modules"
    rm -rf src
    rm -rf node
    rm -f package.json
    rm -f .env
    rm -f index.js
    rm -f package-lock.json
}

function init(){
    src="$PWD/src"
    if [ ! -d $src ]; then
        npm init
        mkdir -p $src
        folders=("config" "controllers" "models" "routes" "utilities" "middleware/validators")
        for fo in ${folders[@]}; do
            folder $fo
        done
        readAll
    else
        echo "Remove Src Folder And Continue? All Your Items In Src Folder Will Be Lost [N/Y]"
        read remove
        if [ "${remove^^}" = "Y" ]; then
            remove
            init
        fi
    fi

    createEnv
    checkNodemon
    createIndex

    local res=$(checkDB)
    if [ $res == 0 ]; then
    sed -i 5d index.js
    fi
}

function checkNodemon(){
    isInFile=$(cat package.json | grep -c "nodemon")
    if [ $isInFile -gt 0 ]; then
    sed -i 's/"scripts": {/"scripts": {\n    "dev": "nodemon index.js",/g' package.json
    fi
}

function checkDB(){
    sequelize=$(cat package.json | grep -c "sequelize")
    pg=$(cat package.json | grep -c "pg")
    if [ $pg -gt 0 ] && [ $sequelize -gt 0 ]; then

    cat <<-EOF > src/config/db.js
const { Sequelize } = require('sequelize')

const db = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASSWORD, {
    host: process.env.DB_HOST,
    dialect: process.env.DB_DIALECT,
    pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000
    },
    logging: false
})

db.authenticate().then(() => console.log('Connected')).catch((err) => console.log(err))

module.exports = db
EOF
        echo 1
    else
        echo 0
    fi
    
}

function createEnv(){
    cat <<-EOF > .env
APP_NAME= App Name
APP_SECRET = 'XXX--Secret--XXX'
APP_PORT= 6969

DB_NAME= Database_Name
DB_PASSWORD= Database_Password
DB_HOST= localhost
DB_USER= postgres
DB_DIALECT= postgres
DB_PORT= 5432

MAIL_USER= mail@mail.com
MAIL_PASSWORD = mailPassword
EOF
}

function createIndex(){
    cat <<-EOF > index.js
const express = require('express')
const app = express()
require('dotenv').config({ encoding: 'latin1' })
const port = process.env.APP_PORT
const db = require('./src/config/db')

app.use('/', (req,res) => {
    return res.send('Hello World')
})

app.listen(port, () => {
    console.log("http://localhost:"+port)
})

EOF

    
}

function readAll(){
    echo "Enter Your Required Packages"
    read all
    npm i $all
    echo "Enter Your Development Packages"
    read all2
    npm i $all2 -D
}

function folder(){
    src="$PWD/src/$1"
    if [ ! -d $src ]; then
        mkdir -p $src
    fi
}


"$@"