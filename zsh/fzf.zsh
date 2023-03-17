# Set catppuccin for fzf colors
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Change to a repo from anywhere
repos() {
    DIR="$(fd . "${GOPATH}/src/" --type d --max-depth 3 --min-depth 3 | fzf)"
    cd "${DIR}"
}

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

# SSH into vagrant VM
bssh() {
    #List all vagrant boxes available in the system including its status, and try to access the selected one via ssh
    kitty +kitten ssh $(jq '.machines[] | {name, vagrantfile_path, state}' < "${HOME}/.vagrant.d/data/machine-index/index" | jq '.name + "," + .state  + "," + .vagrantfile_path' | sed 's/^"\(.*\)"$/\1/' | column -s, -t | sort -rk 2 | fzf | awk '{print $1}')
}

# fco - checkout git branch
fco() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
