#!/bin/bash
set -e
# Note: do not do set -x or the passwords will leak!

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "We are in a pull request, not setting up release"
  exit 0
fi

if [[ $TRAVIS_BRANCH == 'master' ]]; then

  # Git auth
  git config credential.helper store
  echo "https://${RELEASE_GH_USERNAME}:${RELEASE_GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" > ~/.git-credentials
  git remote set-url origin https://${RELEASE_GH_USERNAME}:${RELEASE_GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
  git config user.name ${RELEASE_GH_USERNAME}
  git config user.email ${RELEASE_GH_EMAIL}

  # Prevent log warning by explicitly setting push strategy
  git config --global push.default simple

  # Npm auth
  npm config set //registry.npmjs.org/:_authToken=$NPM_TOKEN -q

  # Fetch tags
  git fetch --tags

  # Set upstream branch
  git branch -u origin/$TRAVIS_BRANCH

fi
