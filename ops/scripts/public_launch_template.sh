#!/bin/bash
cd home/ubuntu

sudo apt update

sudo apt install nodejs npm -y

sudo npm install -g pnpm -y

git clone https://github.com/dagmar-lewis/three_tier_web_app.git

cd three_tier_web_app

cd frontend

sudo npm install

sudo pnpm run dev


