#!/usr/bin/env bash
# Install all nodejs versions found via .nvmrc files with mise

echo "----- INSTALLING NODEJS VERSIONS -----"
find ~/dev -maxdepth 3 -name .nvmrc -type f | while read -r nvmrc; do
  version=$(cat "$nvmrc" | sed 's/^v//')
  echo "Installing Node.js $version from $nvmrc"
  mise install nodejs@"$version"
done
