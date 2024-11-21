#!/bin/bash

# gk.sh | v. 1.0 | 11.17.24

gk_vars() {
    envdir=$HOME/g0dking
    conf_1=$HOME/.bashrc
    conf_2=$envdir/files/sys/dot.bashrc
    shdir=$envdir/functions
    confdir=$envdir/files/config
    webdir=$envdir/www
}

gk_up() {
    gk_vars
    m="$1"

    if [ -z "$m" ]; then
        m="General Updates"
    fi

    cd $envdir
    cp $conf_1 $conf_2
    git add .
    git commit -m "$m"
    git checkout main
    git push origin main
    return 0
}

gk_sh() {
    gk_vars
    local file=$1
    code "$file".sh || nano "$file".sh
    return 0
}

gk_conf() {
    gk_vars
    cd $confdir
    return 0
}

#        gk_edit() {
#            gk_vars
#            local file=$1

#            if [ -z "$file" ]; then
#               error "Specify file to edit."

#            fi

#            if [ -f "$confdir"/"$file" ]; then
#                local dir=$confdir
#            else
#                local dir=$shdir
#            fi
#
#            if [ -f "$dir"/"$file" ]; then
#                code $dir/$file || nano $dir/$file
#            elif [ ! -f "$dir"/"$file" ] && [ "$file" == "*.{conf,config}" ]; then
#                code $confdir/$file || nano $confdir/$file
#            elif [ ! -f "$dir"/"$file" ] && [ "$file" == "*.sh" ]' then
#                code $shdir/$file || nano $shdir/$file
#            elif [ -f "$webdir/$file" ]; then
#                code $webdir/$file || nano $webdir/$file
#            else
#                error "Invalid file."
#                return 1
#            fi
#        }
