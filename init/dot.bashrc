# | ~/.bashrc | v. 10.0.1 | 7.6.24

[[ $- != *i* ]]

bashrc() {
    source=$1
    . $source/init/colors.config
    . $source/init/prompt.config
    . $source/init/initialize.sh
    initialize $source
}

# Edit as needed to match cloned directory:
bashrc "$HOME/g0dking"
