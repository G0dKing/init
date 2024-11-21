#!/bin/bash

# gk.sh | v. 1.0 | 11.17.24

gk_vars() {
<<<<<<< HEAD
    envdir=$HOME/g0dking
    conf_1=$HOME/.bashrc
    conf_2=$envdir/files/sys/dot.bashrc
    shdir=$envdir/functions
    confdir=$envdir/files/config
    webdir=$envdir/www
=======
    local envdir=$HOME/g0dking
    local conf_1=$HOME/.bashrc
    local conf_2=$envdir/files/sys/dot.bashrc
    local shdir=$envdir/functions
    local confdir=$envdir/files/config
    local webdir=$envdir/www
    local here=$(pwd)
>>>>>>> f21742d (Updates (nethunter))
}

gk_up() {
    gk_vars
<<<<<<< HEAD
    m="$1"

    if [ -z "$m" ]; then
        m="General Updates"
    fi

=======
    local m="$1"

    if [ -z "$m" ]; then
        local m="General Updates"
    fi

    local dir=$here
>>>>>>> f21742d (Updates (nethunter))
    cd $envdir
    cp $conf_1 $conf_2
    git add .
    git commit -m "$m"
<<<<<<< HEAD
    git checkout main
    git push origin main
    return 0
=======
    git push origin main
    cd $dir
}

gk_pull() {
    gk_vars
    local dir=$here
    cd $envdir
    git pull origin main
    cd $dir
>>>>>>> f21742d (Updates (nethunter))
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

<<<<<<< HEAD
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
=======

#    gk_edit() {
#        gk_vars
#        local file=$1
#
#        if [ -z "$file" ]; then
#            error "Specify file to edit."
#            return 1
#        fi
#
#        if [ -f "$confdir"/"$file" ]; then
#            local dir=$confdir
#        else
#            local dir=$shdir
#        fi
#
#        if [ -f "$dir"/"$file" ]; then
#            code $dir/$file || nano $dir/$file
#        elif [ ! -f "$dir"/"$file" ] && [ "$file" == "*.{conf,config}" ]; then
#            code $confdir/$file || nano $confdir/$file
#        elif [ ! -f "$dir"/"$file" ] && [ "$file" == "*.sh" ]' then
#            code $shdir/$file || nano $shdir/$file
#        elif [ -f "$webdir/$file" ]; then
#            code $webdir/$file || nano $webdir/$file
#        else
#            error "Invalid file."
#            return 1
#        fi
#    }
>>>>>>> f21742d (Updates (nethunter))
