#!/bin/bash

# Check if the JSON file exists
if [ ! -f "repos.json" ]; then
  echo "repos.json file not found!"
  exit 1
fi

# Read the JSON data from repos.json
json_data=$(cat repos.json)

# Create repos and add catalog-info.yaml
echo "$json_data" | jq -r 'to_entries[] | "\(.value[]) \(.key)"' | while read -r repo team; do
  echo "Creating repository: $repo in team: $team"

  # Create repository in the Liatrio org
  gh repo create "liatrio/$repo" --public --confirm

  # Clone the newly created repo
  git clone "https://github.com/liatrio/$repo.git"

  # Navigate into the repo directory
  cd "$repo" || exit

  # Create the catalog-info.yaml file
  cat <<EOF > catalog-info.yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: $repo
  annotations:
    github.com/project-slug: liatrio/$repo
spec:
  type: other
  lifecycle: unknown
  owner: backstage-foundations
EOF

  # Add, commit, and push the catalog-info.yaml file to the repo
  git add catalog-info.yaml
  git commit -m "Add catalog-info.yaml"
  git push origin main

  # Navigate back to the parent directory
  cd ..

  # Remove the local clone of the repo
  rm -rf "$repo"
done
