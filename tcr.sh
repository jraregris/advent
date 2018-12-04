#!/bin/zsh
mix test --exclude pending && git commit -am $1 || git reset --hard && mix test --only pending