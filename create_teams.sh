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

# Extract the team names and create teams in the GitHub org with visibility set to 'Visible'
echo "$json_data" | jq -r 'keys[]' | while read -r team; do
  echo "Creating GitHub team: $team in liatrio organization with visibility set to 'Visible'"

  # Create the team with 'Visible' privacy in the Liatrio organization using the GitHub CLI
  gh api --method POST -H "Accept: application/vnd.github.v3+json" /orgs/liatrio/teams -f name="$team" -f privacy="closed" --silent

done
