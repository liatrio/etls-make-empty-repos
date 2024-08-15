#!/bin/bash

# Check if the JSON file exists
if [ ! -f "repos.json" ]; then
  echo "repos.json file not found!"
  exit 1
fi

# Read the JSON data from repos.json
json_data=$(cat repos.json)

# Delete repos
echo "$json_data" | jq -r 'to_entries[] | .value[]' | while read -r repo; do
  echo "Deleting repository: $repo from liatrio organization"

  # Delete repository in the Liatrio org
  gh repo delete "liatrio/$repo" --yes
done
