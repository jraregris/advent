#!/bin/zsh
clear
mix test --exclude pending \
  && git commit -am $1 \
  || git reset --hard \
  && grep -r "@tag :pending" test && mix test --only pending && echo "It works, remove '@tag :pending@, ya bobo!'"