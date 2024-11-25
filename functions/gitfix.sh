#!/bin/bash

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

auth_git() {
    repo=$1
    username=$2
    email=$3
    branch="${4:-main}"
    current_branch=$(git branch --show-current)
    git config --global user.name "$username"
    git config --global user.email "$email"
    git config --global credential.helper store

    if [[ -z "$current_branch" ]]; then
        current_branch=$branch
    fi
    if [[ $repo != git@github.com:$username* ]]; then
        repo_name=$(basename -s .git "$repo")
        git remote set-url origin "git@github.com:$username/$repo_name.git"
    fi
    git checkout "$current_branch" >&/dev/null
    git push -u origin "$current_branch" >&/dev/null
    check
    git branch main >&/dev/null
    return 0
}

gitfix() {
    branch=$1
    dotenv="$HOME/.env"
    username="${1:-$GH_USERNAME}"
    email="${2:-$GH_EMAIL}"
    repo=$(get_repo)
    if [[ -f "$dotenv" ]]; then
        source "$dotenv"
    fi
    if [[ -z "$username" || -z "$email" ]]; then
        error "GitHub username/email not found. Update (dot).env or pass as arguments."
        return 1
    fi
    if [[ ! -z "$GH_TOKEN" ]]; then
        echo "$GH_TOKEN" | gh auth login --with-token >&/dev/null
        check
        return 0
    else
        auth_git "$repo" "$username" "$email" "$branch"
    fi
}
