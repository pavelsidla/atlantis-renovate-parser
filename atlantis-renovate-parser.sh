#!/bin/bash

usage() {
  echo "Usage: $0 -o <owner> -r <repo> -b <branch> [-O]"
  exit 1
}

OPEN_URLS=false

while getopts "o:r:b:O" opt; do
  case ${opt} in
    o ) OWNER=$OPTARG ;;
    r ) REPO=$OPTARG ;;
    b ) BRANCH=$OPTARG ;;
    O ) OPEN_URLS=true ;;
    * ) usage ;;
  esac
done

[ -z "$OWNER" ] || [ -z "$REPO" ] || [ -z "$BRANCH" ] && usage

commit_sha=$(gh api "/repos/$OWNER/$REPO/branches/$BRANCH" --jq '.commit.sha')

page=1
printf "%-50s | %-30s | %s\n" "Terraform Plan" "Changes" "URL"
printf -- "%.0s-" {1..120}
printf "\n"
while : ; do
  response=$(gh api "/repos/$OWNER/$REPO/commits/$commit_sha/statuses?per_page=100&page=$page")
  page_results=$(echo "$response" | jq -r '
    .[]
    | select(.context | startswith("atlantis/plan"))
    | select(.description | test("Plan:.*([1-9][0-9]* to add|[1-9][0-9]* to change|[1-9][0-9]* to destroy)"))
    | (.context | sub("atlantis/plan: "; "")) + "|" + (.description | sub("Plan: "; "")) + "|" + .target_url
  ')

  if [ -z "$page_results" ]; then
    break
  fi

  echo "$page_results" | while IFS="|" read -r context description url; do
    printf "%-50s | %-30s | %s\n" "$context" "$description" "$url"
    if [ "$OPEN_URLS" = true ]; then
      open "$url"
    fi
  done

  page=$((page + 1))
done

