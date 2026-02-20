function clear_github_caches -d "delete caches from github repo"
    set -f ACCEPT "Accept: application/vnd.github+json"
    set -f GH_API_VERSION "X-GitHub-Api-Version: 2022-11-28"
    set -f JQ_QUERY ".actions_caches | map(.id) | @sh"
    set -f ENDPOINT "/repos/$argv[1]/actions/caches"
    # fetch all caches for the repo
    set -f CACHES (gh api --paginate --jq $JQ_QUERY -H $ACCEPT -H $GH_API_VERSION $ENDPOINT)
    # strip surrounding quotes and store the list of cache ids
    set -f CACHE_IDS (string split --no-empty ' ' (string replace --all '"' '' $CACHES))
    for id in $CACHE_IDS
        echo "Deleting cache $id"

        gh api --method DELETE -H $ACCEPT -H $GH_API_VERSION "$ENDPOINT/$id"
    end
end
