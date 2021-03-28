#!/bin/bash

mkdir temp
cp ./lambda/main.py temp

pip3 install -r ./lambda/requirements.txt --target="./temp"
zip punk_request.zip -r temp

rm -r temp