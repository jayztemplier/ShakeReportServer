#!/bin/sh
set -e

need_mongodb=true
need_imagemagick=true

for arg
do
  if [ $arg = "-no-mongodb" ]; then
    need_mongodb=false
  fi
  if [ $arg = "-no-imagemagick" ]; then
    need_imagemagick=false
  fi
done

brew update

if $need_mongodb
  then
  echo "Looking for an exisiting installation of mongodb ..."
  if ! brew list | grep mongodb 
    then
    echo "Installing MongoDB ..."
    brew install mongodb
    echo "MongoDB installed"
  else
    echo "MongoDB already installed"
  fi
fi



if $need_imagemagick
  then
  echo "Looking for an exisiting installation of imagemagick ..."
  if ! brew list | grep imagemagick 
    then
    echo "Installing imagemagick ..."
    brew install imagemagick
    echo "imagemagick installed"
  else
    echo "imagemagick already installed"
  fi
fi
