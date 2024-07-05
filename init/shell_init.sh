
    export user=$USER
    export home=$HOME
    export uid=$(id -u)
    export here=$(pwd)
    export parent=$(cd .. && pwd)
    export email=webmaster@alexpariah.com

    alias c='clear'
    alias mkdir='mkdir -p'
    alias rm='rm -rf'
    alias cp='cp -r'
    alias echo='echo -e'
    alias up='sudo apt update && sudo apt full-upgrade -y'
    alias ls='ls --color=auto'
    alias ..='cd ..'
    alias ...='cd .. && cd ..'
    alias 00='cd /'
    alias 0='cd ~'



