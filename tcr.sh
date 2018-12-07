#!/bin/zsh
clear
mix test --exclude pending \
  && git commit -am $1 \
  || git reset --hard \
  && grep -r "@pending" test && mix test --only pending