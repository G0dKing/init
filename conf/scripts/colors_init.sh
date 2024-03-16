#!/bin/bash

set_colors() {
    if tput setaf 1 &> /dev/null; then
        export colors_unsupported=0

        export nc="\033[0m"
        export black="\033[0;30m"
        export red="\033[0;31m"
        export green="\033[0;32m"
        export yellow="\033[0;33m"
        export blue="\033[0;34m"
        export purple="\033[0;35m"
        export cyan="\033[0;36m"
        export white="\033[0;37m"
        export bold_black="\033[1;30m"
        export bold_red="\033[1;31m"
        export bold_green="\033[1;32m"
        export bold_yellow="\033[1;33m"
        export bold_blue="\033[1;34m"
        export bold_purple="\033[1;35m"
        export bold_cyan="\033[1;36m"
        export bold_white="\033[1;37m"
        export line_black="\033[4;30m"
        export line_red="\033[4;31m"
        export line_green="\033[4;32m"
        export line_yellow="\033[4;33m"
        export line_blue="\033[4;34m"
        export line_purple="\033[4;35m"
        export line_cyan="\033[4;36m"
        export line_white="\033[4;37m"
        export bg_black="\033[40m"
        export bg_red="\033[41m"
        export bg_green="\033[42m"
        export bg_yellow="\033[43m"
        export bg_blue="\033[44m"
        export bg_purple="\033[45m"
        export bg_cyan="\033[46m"
        export bg_white="\033[47m"
        export blacker="\033[0;90m"
        export redder="\033[0;91m"
        export greener="\033[0;92m"
        export yellower="\033[0;93m"
        export bluer="\033[0;94m"
        export purpler="\033[0;95m"
        export cyaner="\033[0;96m"
        export whiter="\033[0;97m"
        export blackest="\033[1;90m"
        export reddest="\033[1;91m"
        export greenest="\033[1;92m"
        export yellowest="\033[1;93m"
        export bluest="\033[1;94m"
        export purplest="\033[1;95m"
        export cyanest="\033[1;96m"
        export whitest="\033[1;97m"
        export bg_blacker="\033[0;100m"
        export bg_redder="\033[0;101m"
        export bg_greener="\033[0;102m"
        export bg_yellower="\033[0;103m"
        export bg_bluer="\033[0;104m"
        export bg_purpler="\033[0;105m"
        export bg_cyaner="\033[0;106m"
        export bg_whiter="\033[0;107m"
    else
        export colors_unsupported=1
        export nc=""
        export black=""
        export red=""
        export green=""
        export yellow=""
        export blue=""
        export purple=""
        export cyan=""
        export white=""
        export bold_black=""
        export bold_red=""
        export bold_green=""
        export bold_yellow=""
        export bold_blue=""
        export bold_purple=""
        export bold_cyan=""
        export bold_white=""
        export line_black=""
        export line_red=""
        export line_green=""
        export line_yellow=""
        export line_blue=""
        export line_purple=""
        export line_cyan=""
        export line_white=""
        export bg_black=""
        export bg_red=""
        export bg_green=""
        export bg_yellow=""
        export bg_blue=""
        export bg_purple=""
        export bg_cyan=""
        export bg_white=""
        export blacker=""
        export redder=""
        export greener=""
        export yellower=""
        export bluer=""
        export purpler=""
        export cyaner=""
        export whiter=""
        export blackest=""
        export reddest=""
        export greenest=""
        export yellowest=""
        export bluest=""
        export purplest=""
        export cyanest=""
        export whitest=""
        export bg_blacker=""
        export bg_redder=""
        export bg_greener=""
        export bg_yellower=""
        export bg_bluer=""
        export bg_purpler=""
        export bg_cyaner=""
        export bg_whiter=""
    fi
    
    return 0
}

set_escape_codes() {
    export soft_reset="\033[!p"
    export set_key="\033[;p"  # Use as \033[{key};{string}p
    export font_default="\033[10m"
    export font_1="\033[11m"
    export font_2="\033[12m"
    export font_3="\033[13m"
    export font_4="\033[14m"
    export font_5="\033[15m"
    export font_6="\033[16m"
    export font_7="\033[17m"
    export font_8="\033[18m"
    export font_9="\033[19m"

    return 0
}

set_symbols() {
 if tput setaf 1 &> /dev/null; then
        export sym_airplane=$(printf '\U2708')
        export sym_alarm=$(printf '\U23F0')
        export sym_angry=$(printf '\U1F620')
        export sym_basketball=$(printf '\U1F3C0')
        export sym_bear=$(printf '\U1F43B')
        export sym_bicycle=$(printf '\U1F6B2')
        export sym_bio=$(printf '\U2623')
        export sym_book=$(printf '\U1F4D6')
        export sym_bus=$(printf '\U1F68C')
        export sym_car=$(printf '\U1F697')
        export sym_cat=$(printf '\U1F431')
        export sym_clap=$(printf '\U1F44F')
        export sym_coffee=$(printf '\U2615')
        export sym_dog=$(printf '\U1F436')
        export sym_drum=$(printf '\U1F941')
        export sym_earth=$(printf '\U1F30D')
        export sym_fire=$(printf '\U1F525')
        export sym_football=$(printf '\U1F3C8')
        export sym_fox=$(printf '\U1F98A')
        export sym_ghost=$(printf '\U1F47B')
        export sym_globe=$(printf '\U1F30E')
        export sym_guitar=$(printf '\U1F3B8')
        export sym_heart=$(printf '\U1F49A')
        export sym_horse=$(printf '\U1F434')
        export sym_laugh=$(printf '\U1F606')
        export sym_lion=$(printf '\U1F981')
        export sym_mail=$(printf '\U1F4E7')
        export sym_medal=$(printf '\U1F3C5')
        export sym_moon=$(printf '\U1F314')
        export sym_motorcycle=$(printf '\U1F3CD')
        export sym_mountain=$(printf '\U26F0')
        export sym_mouse=$(printf '\U1F42D')
        export sym_music=$(printf '\U1F3B5')
        export sym_nuke=$(printf '\U2622')
        export sym_panda=$(printf '\U1F43C')
        export sym_peace=$(printf '\U262E')
        export sym_saxophone=$(printf '\U1F3B7')
        export sym_skull=$(printf '\U1F480')
        export sym_smile=$(printf '\U1F603')
        export sym_soccer=$(printf '\U26BD')
        export sym_star=$(printf '\U2B50')
        export sym_sun=$(printf '\U2600')
        export sym_sweat=$(printf '\U1F613')
        export sym_think=$(printf '\U1F914')
        export sym_thumbs_down=$(printf '\U1F44E')
        export sym_thumbs_up=$(printf '\U1F44D')
        export sym_tiger=$(printf '\U1F42F')
        export sym_train=$(printf '\U1F683')
        export sym_trophy=$(printf '\U1F3C6')
        export sym_unicorn=$(printf '\U1F984')
        export sym_universe=$(printf '\U1F30C')
        export sym_volcano=$(printf '\U1F30B')
        export sym_wink=$(printf '\U1F609')
        export sym_yinyang=$(printf '\U262F')
        export sym_zzz=$(printf '\U1F4A4')
  else
        export sym_airplane=""
        export sym_alarm=""
        export sym_angry=""
        export sym_basketball=""
        export sym_bear=""
        export sym_bicycle=""
        export sym_bio=""
        export sym_book=""
        export sym_bus=""
        export sym_car=""
        export sym_cat=""
        export sym_clap=""
        export sym_coffee=""
        export sym_dog=""
        export sym_drum=""
        export sym_earth=""
        export sym_fire=""
        export sym_football=""
        export sym_fox=""
        export sym_ghost=""
        export sym_globe=""
        export sym_guitar=""
        export sym_heart=""
        export sym_horse=""
        export sym_laugh=""
        export sym_lion=""
        export sym_mail=""
        export sym_medal=""
        export sym_moon=""
        export sym_motorcycle=""
        export sym_mountain=""
        export sym_mouse=""
        export sym_music=""
        export sym_nuke=""
        export sym_panda=""
        export sym_peace=""
        export sym_saxophone=""
        export sym_skull=""
        export sym_smile=""
        export sym_soccer=""
        export sym_star=""
        export sym_sun=""
        export sym_sweat=""
        export sym_think=""
        export sym_thumbs_down=""
        export sym_thumbs_up=""
        export sym_tiger=""
        export sym_train=""
        export sym_trophy=""
        export sym_unicorn=""
        export sym_universe=""
        export sym_volcano=""
        export sym_wink=""
        export sym_yinyang=""
        export sym_zzz=""
  fi
  return 0
}

colors_init() {
    set_colors
    set_symbols
    set_escape_codes
    return 0
}