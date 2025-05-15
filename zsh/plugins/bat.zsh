# bat integrations
#
# Prettier diff
batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

alias bd="batdiff"
