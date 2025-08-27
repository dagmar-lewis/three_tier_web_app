#!/bin/bash

sudo apt install unzip

curl -fsSL https://bun.sh/install | bash

echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

cd home/ubuntu

git clone https://github.com/dagmar-lewis/three_tier_web_app.git

cd three_tier_web_app

cd frontend

bun install

bun run dev


