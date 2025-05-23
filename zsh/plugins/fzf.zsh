# Stop docker containers
cs() {
    local cid
    cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker stop "$cid"
}
#
# Remove docker containers
cr() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker rm "$cid"
}

# Remove docker containers forcefully
crf() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker rm -f "$cid"
}

crmi() {
    docker images | sed 1d | fzf -q "$1" -m | awk '{print $3}' | xargs -r docker rmi
}

# fco - checkout git branch
fco() {
    local branches branch
    branches=$(git --no-pager branch -vv)
    branch=$(echo "$branches" | fzf +m -q "$1")
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

_pick_dir() {
    fd . "${GOPATH}/src/" --type d --max-depth 3 --min-depth 3 | fzf -q "$1"
}

_fd_repos() {
    DIR="$(_pick_dir "$1")"

    if [[ -z $DIR ]]; then
        return 0
    fi

    cd "$DIR" || return 1
}

repos() {
    if command -v tmux &> /dev/null && command -v tmux_repos &> /dev/null; then
        tmux_repos "$1"
    else
        _fd_repos "$1"
    fi
}
