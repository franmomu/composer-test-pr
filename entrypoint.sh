#!/bin/sh -l

# based on https://gist.github.com/greg0ire/a404831add1247d2bc20fa11107c5d5e

set -e

pullRequest=$(cat /github/workflow/event.json | jq -r .pull_request)
username=$(echo $pullRequest | jq -r .user.login)
repository=$(echo $pullRequest | jq -r .head.repo.html_url)
tags=$(echo $pullRequest | jq -r .base.repo.tags_url)

curl $tags > tags.json
lastTag=$(cat tags.json | jq -r '.[0].name')

baseRef=$(echo $pullRequest | jq -r .head.ref)
composerRepo=$(composer show --self --no-ansi \
        |grep 'name ' \
        |cut -d ':' -f 2 \
        |cut -b 2-)

userRepositoryConfiguration="composer config repositories.$username vcs $repository"
requiredRepository="composer require $composerRepo \"dev-$baseRef as $lastTag\""
comment="### How to test this PR\n\n\`\`\`shell\n$userRepositoryConfiguration\n$requiredRepository\n\`\`\`"

body=$(echo -e $comment | jq -aRs .)

payload="{ \"body\": $body }"
commentsUrl=$(echo $pullRequest | jq -r .comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" -d "$payload" "$commentsUrl" > /dev/null
