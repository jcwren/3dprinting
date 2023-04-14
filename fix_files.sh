#!/usr/bin/env bash

if  [[ $(uname -s) == CYGWIN* ]]; then
  echo "Fixing ownership..."
  GLOBIGNORE="*.dll:*.exe:*.pl:*.sh"
  chmod -R 644 -- *
  GLOBIGNORE=""
  chown -R "$(whoami)":None -- *
  find . -type d -exec chmod 755 {} \;
  find . \( -name \*.exe -o -name \*.dll -o -name \*.sh \) -exec chmod 755 {} \;
fi

echo "Fixing trailing spaces..."
if ! command -v perl &> /dev/null; then
  echo "  Can't do it, perl not installed"
else
  find . -name \*.scad -print0 | xargs -0 perl -i.bak -plwe 's/\s+$//g'
  find . -name \*.bak -exec rm {} \;
fi

echo "Fixing line endings..."
if ! command -v dos2unix &> /dev/null; then
  echo "  Can't do it, dos2unix not installed"
else
  find . -type f -name \*.scad -exec dos2unix -q {} \;
fi
