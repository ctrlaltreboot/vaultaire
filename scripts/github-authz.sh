#!/usr/bin/env bash

set -e

: ${GITHUB_TEAM_1:=product}
: ${GITHUB_TEAM_2:=support}

authn_github_team() {
  local TEAM="$1"
  echo
  echo "Let's try logging in as a user that belongs to $TEAM"
  echo 'You must create a Github token before attempting to login'
  echo 'https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/'
  echo 'Save your token as `.token`, it will be Git ignored.'
  TOKEN=$(cat .$TEAM.token)
  echo "Running: vault login -method=github token=$TOKEN"
  vault login -method=github token=$TOKEN
  echo
  echo "As a GitHub user that belongs to $TEAM: "
  echo 'Running this command should work: '
  echo "    vault write secret/$TEAM/$TEAM-application API_KEY=12345abcdefg67890"
  echo
  echo 'Writing to restricted path would fail: '
  echo 'Running these commands would fail: '
  echo "    vault write secret/management/administrative PASSWORD=09876qwerty54321"
  echo "    vault read secret/management/finance"
  echo
}

echo 'Create two different GitHub users'
echo "Assign one user to $GITHUB_TEAM_1 team and the other to $GITHUB_TEAM_2 team within the $GITHUB_ORG organization"
authn_github_team "$GITHUB_TEAM_1"
authn_github_team "$GITHUB_TEAM_2"
