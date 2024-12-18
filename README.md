# Getting Started

This holds a handful of scripts that will generate repos and teams in github.com that align with the test data created by liatrio/seed-dora.

The scripts depend on eachother. When working from a fresh start run
```bash
./create_teams.sh
./create_repos.sh
./assign_teams_to_repos.sh
./set_custom_property_team_name.sh
```

To cleanup run
```bash
./delete_repos.sh
./delete_teams.sh
```
