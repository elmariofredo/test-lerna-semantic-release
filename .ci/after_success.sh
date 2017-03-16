#!/bin/bash
set -e
# Note: do not do set -x or the passwords will leak!

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "We are in a pull request, not releasing"
  exit 0
fi

if [[ $TRAVIS_BRANCH == 'master' ]]; then

  #
  # Prepare git and npm for release
  #

    echo "get branch"

    # Checkout explicit branch
    git fetch
    git checkout master

    echo "auth"

    # Git auth
    git config --global credential.helper store
    echo "DONE git config --global credential.helper store"
    echo "https://${RELEASE_GH_USERNAME}:${RELEASE_GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" > ~/.git-credentials
    echo "DONE .git-credentials"
    git remote set-url origin https://${RELEASE_GH_USERNAME}:${RELEASE_GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
    echo "DONE set-url remote"
    # git config --global user.name ${RELEASE_GH_USERNAME}
    # git config --global user.email ${RELEASE_GH_EMAIL}
    echo "SKIPPED set config name & email"

    # Prevent log warning by explicitly setting push strategy
    git config --global push.default simple

    echo "npm auth"

    # Npm auth
    npm config set //registry.npmjs.org/:_authToken=$NPM_TOKEN -q

    echo "fetch tags"

    # Fetch tags
    git fetch --tags

    echo "set upstream"

    # Set upstream branch
    git branch -u origin/$TRAVIS_BRANCH


  #
  # Build app
  #

    # Run build task
    yarn build


  #
  # Release
  #

    # Release project packages
    yarn semantic-release


  #
  # Deploy project website to Github Pages
  #

    # Build project to tmp/site
    yarn site

    # Init git from sratch in tmp/site and push it to gh-pages branch
    cd tmp/site
    git init
    git add .
    git commit -m "Deployed to Github Pages"
    git push --force --quiet master:gh-pages > /dev/null 2>&1

fi
