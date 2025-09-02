#!/bin/bash

yarn upgrade --latest

git add .
git commit -m "⬆️ upgrade packages"
git push
