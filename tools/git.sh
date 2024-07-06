clone() {
    local repo=$1
    local url="https://github.com"
    local name="G0dKing"
    local cmd="git clone $url/$name/$repo.git"
    exec $cmd
}
