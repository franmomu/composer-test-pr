# composer-test-pr

An action that shows the code necessary to be added to composer in order to test a PR

## Example

You can use it as a Github Action like this:

_.github/workflows/composer_test_pr.yml_
```
on:
  pull_request:
    types: [opened]
name: How to test a PR
jobs:
  composer-test-pr:
    runs-on: ubuntu-latest
    steps:
    - name: Composer Test PR
      uses: franmomu/composer-test-pr@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
