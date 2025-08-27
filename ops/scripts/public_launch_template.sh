#!/bin/bash

sudo apt update

sudo apt install nodejs npm

    sudo npm install -g pnpm

cd home/ubuntu

git clone https://github.com/dagmar-lewis/three_tier_web_app.git

cd three_tier_web_app

cd frontend

pnpm install

pnpm run dev


