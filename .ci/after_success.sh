#!/bin/bash
set -e
# Note: do not do set -x or the passwords will leak!

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo ">>> We are in a pull request, not releasing <<<"
  exit 0
fi

if [ "$TRAVIS_BRANCH" != "master" ]; then
  echo ">>> We are not on master branch, not releasing <<<"
  exit 0
fi

#
# Prepare git and npm for release
#

  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> START: SETTING GIT/NPM FOR RELEASE <<<<<<<<<<<<<<<<<<<<<<<<<<<"

  # Checkout explicit branch
  echo ">>> START: git fetch <<<"
  git fetch
  echo ">>> DONE($?): git fetch <<<"

  echo ">>> START: git checkout master <<<"
  git checkout "${TRAVIS_BRANCH}"
  echo ">>> DONE($?): git checkout master <<<"

  # Git auth
  echo ">>> START: git config --global credential.helper store <<<"
  git config --global credential.helper store
  echo ">>> DONE($?): git config --global credential.helper store <<<"

  echo ">>> START: fill ~/.git-credentials <<<"
  echo "https://${RELEASE_GH_USERNAME}:${RELEASE_GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" > ~/.git-credentials
  echo ">>> DONE($?): fill ~/.git-credentials <<<"

  echo ">>> START: git remote set-url origin <<<"
  git remote set-url origin https://${RELEASE_GH_USERNAME}:${RELEASE_GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
  echo ">>> DONE($?): git remote set-url origin <<<"

  echo ">>> START: git config user.name <<<"
  git config user.name "${RELEASE_GH_USERNAME}"
  echo ">>> DONE($?): git config user.name <<<"

  echo ">>> START: git config user.email <<<"
  git config user.email "${RELEASE_GH_EMAIL}"
  echo ">>> DONE($?): git config user.email <<<"

  # Prevent log warning by explicitly setting push strategy
  echo ">>> START: git config --global push.default simple <<<"
  git config --global push.default simple
  echo ">>> DONE($?): git config --global push.default simple <<<"

  # Npm auth
  echo ">>> START: npm config set //registry.npmjs.org/:_authToken=... <<<"
  npm config set //registry.npmjs.org/:_authToken=$NPM_TOKEN -q
  echo ">>> DONE($?): npm config set //registry.npmjs.org/:_authToken=... <<<"

  # Fetch tags
  echo ">>> START: git fetch --tags <<<"
  git fetch --tags
  echo ">>> DONE($?): git fetch --tags <<<"

  # Set upstream branch
  echo ">>> START: git branch -u origin/$TRAVIS_BRANCH <<<"
  git branch -u origin/$TRAVIS_BRANCH
  echo ">>> DONE($?): git branch -u origin/$TRAVIS_BRANCH <<<"

  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> DONE: SETTING GIT/NPM FOR RELEASE <<<<<<<<<<<<<<<<<<<<<<<<<<<"

#
# Build app
#

  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> START: BUILDING APP <<<<<<<<<<<<<<<<<<<<<<<<<<<"

  # Run build task
  echo ">>> START: yarn build <<<"
  yarn build
  echo ">>> DONE($?): yarn build <<<"

  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> DONE: BUILDING APP <<<<<<<<<<<<<<<<<<<<<<<<<<<"

#
# Release
#

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> START: RELEASE <<<<<<<<<<<<<<<<<<<<<<<<<<<"

# Release project packages
echo ">>> START: yarn semantic-release <<<"
yarn semantic-release
echo ">>> DONE($?): yarn semantic-release <<<"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> DONE: RELEASE <<<<<<<<<<<<<<<<<<<<<<<<<<<"

#
# Deploy project website to Github Pages
#

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> START: DEPLOY GH-PAGES <<<<<<<<<<<<<<<<<<<<<<<<<<<"

# Build project to tmp/site
echo ">>> START: yarn site <<<"
yarn site
echo ">>> DONE($?): yarn site <<<"

# Init git from sratch in tmp/site and push it to gh-pages branch
echo ">>> START: init git for gh-pages publishing <<<"
cd tmp/site
git init
git add .
git commit -m "Deployed to Github Pages"
echo ">>> DONE: init git for gh-pages publishing <<<"

echo ">>> START: git push --force --quiet master:gh-pages > /dev/null 2>&1 <<<"
git push --force --quiet master:gh-pages > /dev/null 2>&1
echo ">>> DONE($?): git push --force --quiet master:gh-pages > /dev/null 2>&1 <<<"


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>> DONE: DEPLOY GH-PAGES <<<<<<<<<<<<<<<<<<<<<<<<<<<"
