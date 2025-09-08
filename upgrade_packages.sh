#!/bin/bash

git switch -c update_packages

yarn upgrade --latest

git add .
git commit -m "⬆️ upgrade packages"
git push
