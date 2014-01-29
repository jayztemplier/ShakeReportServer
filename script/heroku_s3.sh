#!/bin/bash

if [ -z $1 ]; then
    echo "------> Application name missing"
    echo "------> Please run heroku_setup.sh application_name amazon_key amazon_secret_key amazon_bucket"
else
    echo "Setting up AWS on $1"

    if [ -z $2 ]; then
        echo "------> Please provide the AWS access key"
    else
      heroku config:set AWS_ACCESS_KEY_ID=$2 --app $1
    fi

    if [ -z $3 ]; then
        echo "------> Please provide the AWS secret key"
    else
      heroku config:set AWS_SECRET_ACCESS_KEY=$3 --app $1
    fi

    if [ -z $4 ]; then
      echo "------> Please provide the AWS bucket name"
    else
      heroku config:set AWS_BUCKET=$4 --app $1
    fi
    
fi

