# test-lerna-semantic-release
Testing repo to verify lerna-semantic-release functionality

## Steps to setup lerna-semantic-release

### Install

1. $ `yarn init -y`
2. $ `yarn add -D lerna@2.0.0-beta.38 lerna-semantic-release commitizen`
3. $ `commitizen init cz-lerna-changelog --save-dev --save-exact`
4. $ `lerna init`

###  Setup CI

1. Login to travis and add your new project https://travis-ci.org/profile
2. Go to project settings and set following variables in 'display values off' mode
3. Get github personal token here https://github.com/settings/tokens and set it to GH_TOKEN
4. set RELEASE_GH_USERNAME and RELEASE_GH_EMAIL
5. set RELEASE_GH_TOKEN to github personal token created in step 1.
6. set NPM_CONFIG_EMAIL and NPM_CONFIG_USERNAME
7. login to npm and get token $ `npm login && cat ~/.npmrc` set token to NPM_TOKEN
8. copy .travis.yml and .ci folder to your project

### Setup packages

1. create packages under packages directory
2. set for each scoped package
```json
  "publishConfig": {
    "access": "public"
  },
```

### Commit Workflow

1. $ `git add README.md`
2. $ `git cz`
3. $ `git commit && git push`

### Initial release

Run manual_release.sh for each package.

```bash
$ ./manual-release.sh @elmariofredo/test-lerna-semantic-release-p2 patch && \
./manual-release.sh @elmariofredo/test-lerna-semantic-release-p1 patch && \
./manual-release.sh @elmariofredo/test-lerna-semantic-release patch
```
