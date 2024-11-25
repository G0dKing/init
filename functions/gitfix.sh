#!/bin/bash

check() {
    if [ $? -eq 0 ]; then
        echo -e "${green}SUCCESSFUL${nc}"
    else
        local err_output="${2:-}"
        local err="${1:-FAILED}"
        if [ -n "$err_output" ]; then
            local error_msg="${red}Error:${nc} $err_output$"
        else
            local error_msg="${red}Error:${nc} $err"
        echo -e "$error_msg"
        fi
    fi
    echo
}

get_repo() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        repo=$(git remote get-url origin 2>/dev/null)
        if [[ -z "$repo" ]]; then
            error "No remote repository. Use 'git remote add origin <url>'."
            return 1
        fi
    else
        error "Not a git repository."
        return 1
    fi

    echo "$repo"
}

gitfix() {
    branch=$1

    dotenv="$HOME/.env"
    if [[ -f "$dotenv" ]]; then
        source "$dotenv"
    fi

    username="${1:-$GH_USERNAME}"
    email="${2:-$GH_EMAIL}"

    if [[ -z "$username" || -z "$email" ]]; then
        error "Missing credentials. Pass username and email or set in environment."
    fi

    repo=$(get_repo)
    auth_git "$repo" "$username" "$email" "$branch"
}

auth_git() {
    repo=$1
    username=$2
    email=$3
    branch="${4:-main}"

    if [[ ! -z "$GH_TOKEN" ]]; then
        echo "$GH_TOKEN" | gh auth login --with-token
        return 0
    else
        git config --global user.name "$username"
        git config --global user.email "$email"
        git config --global credential.helper store
    fi

    if [[ $repo != git@github.com:$username* ]]; then
        repo_name=$(basename -s .git "$repo")
        git remote set-url origin "git@github.com:$username/$repo_name.git"
    fi

    current_branch=$(git branch --show-current)
    if [[ -z "$current_branch" ]]; then
        current_branch=$branch
    fi

    git checkout "$current_branch" >&/dev/null
    git push -u origin "$current_branch" >&/dev/null
    success
    git branch main >&/dev/null
}}
