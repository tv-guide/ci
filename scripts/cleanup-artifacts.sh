#!/usr/bin/env bash

set -euxo pipefail

repoNameWithOwner="$1"
run_id="$2"
max_attempts="${3:-5}"

attempt=1

artifacts_urls=""
while ((attempt < max_attempts)); do
artifacts_urls="$(curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$repoNameWithOwner/actions/runs/$run_id/artifacts" | jq -r '.artifacts[].url')"
  if [[ -z $artifacts_urls ]]; then
    sleep $((attempt++))
    continue
  fi
  break
done
printf "%s\n" "$artifacts_urls" | xargs -t echo curl -fsSL -X DELETE -H "Authorization: Bearer $GITHUB_TOKEN"
