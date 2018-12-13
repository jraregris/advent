#!/bin/zsh
clear
mix test --exclude pending \
  && git add . \
  && git commit -m $1 1>/dev/null \
  || git reset --hard \
  && grep -r "@tag :pending" test && mix test --only pending && echo "\nIt works, remove '@tag :pending@, ya bobo!'"