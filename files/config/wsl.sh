# CUSTOM CONFIGURATIONS FOR WINDOWS FOR SUBSYSTEM FOR LINUX (UBUNTU)

# Navigation

wsl_nav() {
    local alpha=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

    if [ -z $loaded_wsl_conf ]; then    
        for x in ${alpha[@]}; do
            local y=${x,,}
            export ${x}:=/mnt/${y}
        done
        export loaded_wsl_conf=1
    fi
}
