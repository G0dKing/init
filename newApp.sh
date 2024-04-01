#!/bin/bash
# newApp.sh

# USAGE: 'newApp [PROJECT_DIR]'

setup_log() {
    local logdir="$HOME/.logs/newApp"
    local logfile="$logdir/newApp.log"
    if [[ ! -d "$logdir" ]]; then
        mkdir -p "$logdir"
    fi
    if [[ ! -f "$logfile" ]]; then
        echo "# newApp.log" > "$logfile"
    fi
}
error() {
    echo "Error: $1" >&2
    echo "Error: $1" >> "$logfile"
    exit 1
}
check_command() {
    if ! command -v "$1" &>/dev/null; then
        echo "$2 is not installed. Installing..."
        eval "$3" || error "$4"
    else
        echo "$2 detected."
    fi
}

install_curl() {
    sudo apt install -y curl
}
install_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install node
    nvm use node
}
install_git() {
    sudo apt install -y git
}
install_gh() {
    sudo apt install -y gh
}
check_dependencies() {
    sudo apt update
    check_command "curl" "cURL" "install_curl" "Failed to install cURL."
    check_command "nvm" "Node Version Manager (NVM)" "install_nvm" "Failed to install NVM."
    check_command "node" "Node.js" "nvm install node" "Failed to install Node.js."
    check_command "git" "Git" "install_git" "Failed to install Git."
    check_command "gh" "GitHub CLI" "install_gh" "Failed to install GitHub CLI"
    return 0
}

init_newApp() {
    setup_log
    check_dependencies
    if [[ $# -eq 0 ]]; then
        clear
        read -p "Specify Project Directory (Default: './app'): " project
        project=${project:-"./app"}
    else
        project="$1"
    fi
    mkdir -p "$project" || error "Failed to create project directory."
    cd "$project"
    build_newApp "$project"
}

build_newApp() {
    local project=$1
    local github="https://github.com/G0dKing"
    local name=$(basename "$project")
    local server_file=https://gist.githubusercontent.com/G0dKing/d37c4a58f0e167f69e84b77e9ca458bc/raw/49a9d7bc9683b7c6641f9c8e179e4136f3fb5b8b/server.js
    local json_file=https://gist.githubusercontent.com/G0dKing/77a569c5818e847e22d1a8eb21f76867/raw/1b90994283b6780dbebc35527c83a4074ac0d320/package.json
    local ignore_file=https://gist.githubusercontent.com/G0dKing/8004e19e32b7f873824fb9010474f34c/raw/2f50e62933a4d778567ed8907de74cc8ad956491/.gitignore

    mkdir client || error "Failed to create client directory."
    mkdir server || error "Failed to create server directory."
    npm init -y || error "Failed to initialize npm."
    cd server && curl $server_file > server.js && cd ..
    npm create vite@latest -- --template react "$name" || error "Failed to create Vite project."
    cp -r "$name" client && rm -rf "$name"
    curl $json_file > package.json || error "Failed to acquire package.json"
    npm i

    git init
    git config --global init.defaultBranch main
    git add .
    git commit -m "Initial Commit"
    gh auth login
    gh repo create "$name" --public --source=. --remote=origin || error "Failed to create GitHub repository."
    curl $ignore_file > .gitignore || error "Failed to acquire .gitignore"
    git push origin main || error "Failed to push to remote repository."
    return 0
}

newApp() {
    project=$1
    clear
    echo "Initializing..."
    init_newApp "$project"
    clear
    echo "\[${green}\]Success! \[${nc}]\Initialized Fullstack Environment."
    echo "Location: \[$red\]$project\[$nc\]"
    echo ""
    wait 3
    read -r "Press Enter to Exit"
    clear
    return 0
}
