#!/bin/bash

# Check if the JSON file exists
if [ ! -f "repos.json" ]; then
  echo "repos.json file not found!"
  exit 1
fi

# Disable pager for unattended mode
export GIT_PAGER=""

# Read the JSON data from repos.json
json_data=$(cat repos.json)

# Extract the team names and delete teams in the GitHub org
echo "$json_data" | jq -r 'keys[]' | while read -r team; do
  echo "Deleting GitHub team: $team from liatrio organization"

  # Delete the team in the Liatrio organization using the GitHub CLI
  gh api --method DELETE -H "Accept: application/vnd.github.v3+json" "/orgs/liatrio/teams/$team" --silent

done
