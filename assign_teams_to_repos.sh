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

# Extract the team names and repos, and assign teams to the repos in the GitHub org
echo "$json_data" | jq -r 'to_entries[] | "\(.key) \(.value[])"' | while read -r team repo; do
  echo "Assigning team: $team to repository: $repo"

  # Assign the team to the repository with write permissions using the GitHub CLI
  gh api --method PUT -H "Accept: application/vnd.github.v3+json" \
    "/orgs/liatrio/teams/$team/repos/liatrio/$repo" \
    -f permission="push" --silent

done
