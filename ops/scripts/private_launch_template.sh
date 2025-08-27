#!/bin/bash

cd home/ubuntu

sudo apt update

sudo apt install unzip -y

curl -fsSL https://bun.sh/install | bash

sudo echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/dagmar-lewis/three_tier_web_app.git

cd three_tier_web_app

cd backend

sudo bun install

sudo bun run dev

