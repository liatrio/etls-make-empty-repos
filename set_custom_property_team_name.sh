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

# Extract the team names and repos, and set the custom_property 'team_name' for each repo
echo "$json_data" | jq -r 'to_entries[] | "\(.key) \(.value[])"' | while read -r team repo; do
  echo "Setting custom property 'team_name: $team' on repository: $repo"

  # Use the GitHub API to set the custom property on the repository
  gh api \
    --method PATCH \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/liatrio/$repo/properties/values" \
    -f "properties[][property_name]=team_name" \
    -f "properties[][value]=$team" \
    --silent

  if [ $? -eq 0 ]; then
    echo "Successfully set 'team_name: $team' on $repo"
  else
    echo "Failed to set 'team_name: $team' on $repo"
  fi

done
