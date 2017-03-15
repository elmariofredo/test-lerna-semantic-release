#!/bin/bash
set -e
# Note: do not do set -x or the passwords will leak!

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "We are in a pull request, not releasing"
  exit 0
fi

if [[ $TRAVIS_BRANCH == 'master' ]]; then

  # Release project packages
  npm run semantic-release

  # Deploy project website to Github Pages

  # Build project to tmp/site
  yarn site

  # Init git from sratch in tmp/site and push it to gh-pages branch
  cd tmp/site
  git init
  git add .
  git commit -m "Deployed to Github Pages"
  git push --force --quiet master:gh-pages > /dev/null 2>&1

fi
