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
3. Get github personal token here https://github.com/settings/tokens and set it to `GH_TOKEN`
4. set `RELEASE_GH_USERNAME` and `RELEASE_GH_EMAIL`
5. set `RELEASE_GH_TOKEN` to github personal token created in step 1.
6. set `NPM_CONFIG_EMAIL` and `NPM_CONFIG_USERNAME`
7. login to npm and get token $ `npm login && cat ~/.npmrc` set token to `NPM_TOKEN`
8. copy `./package.json` `./.travis.yml` and `./.ci` folder to your project


### Setup packages

1. create packages under packages directory
2. set for each scoped package
```json
  "publishConfig": {
    "access": "public"
  },
```


### Initial release

Run manual_release.sh for each package.

```bash
$ ./manual-release.sh @elmariofredo/test-lerna-semantic-release-p2 1.0.0 && \
./manual-release.sh @elmariofredo/test-lerna-semantic-release-p1 1.0.0 && \
./manual-release.sh @elmariofredo/test-lerna-semantic-release 1.0.0
```


### Commit Workflow

1. $ `git add README.md`
2. $ `git cz` !!!check if you have valid scope in Troubleshooting section!!!
3. $ `git commit && git push`


## Troubleshooting

1. **error: message=There are no relevant changes, so no new version is released., code=ENOCHANGE**

    make sure that commit message match with `/^(\w*)(\(([\w\$\.\-\* ]*)\))?\: (.*)$/` pattern as described here https://github.com/atlassian/lerna-semantic-release/issues/73#issuecomment-286766534

2. **ERR! commits The commit the last release of this package was derived from is not in the direct history of the "master" branch.**

    Check if you have all env variables properly set specially `GH_TOKEN`

3. **npm ERR! code ENEEDAUTH**

    If you decide to use own CI script make sure that you are not running semantic-release package.json script using yarn command($ `yarn semantic-release`). For some strange reason it won't reach auth information from within yarn subshell

    see issue https://github.com/yarnpkg/yarn/issues/2935

4. some other errror

    Check if variables are properly set, after_succes script will show you variables at the beggining of execution with masked sensitive tokens. For some strange reason it can happen that Travis CI will forgot or simply wont set variables from settings to execution context.

