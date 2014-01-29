#!/bin/bash

if [ -z $1 ]; then
    echo "------> Application name missing"
    echo "------> Please run heroku_setup.sh application_name github_id github_secret"
else
    echo "Setting up $1"
    heroku addons:add mongohq --app $1
    heroku addons:add scheduler --app $1
    heroku addons:add sendgrid:starter --app $1


    if [ -z $2 ]; then
        echo "------> Please provide your github application id"
    else
        heroku config:set GITHUB_KEY=$2 --app $1
    fi

    if [ -z $3 ]; then
        echo "------> Please provide your github application secret key"
    else
        heroku config:set GITHUB_SECRET=$3 --app $1
    fi
fi

