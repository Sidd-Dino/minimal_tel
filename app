#!/usr/bin/env bash

print_ERR_and_die(){
    printf "\e[38;5;1m[!]%s\n\e[m"\
           "$*"
    exit 1
}

show_help(){
    printf  -- '%s\n'\
            "app"\
            "Launch Android Apps from Termux\n"\
            ""\
            "Usage"\
            "  $name  [OPTION] [PATTERN]"\
            "Options:"\
            "  -u   update app cache"\
            "  -h   display this help message"
}

update_cache(){
    am broadcast --user 0 \
         --es com.termux.app.reload_style apps-cache \
         -a com.termux.app.reload_style com.termux > /dev/null
}

main(){
    cachefile="$HOME/.apps"
    namefile="$HOME/.app_names"
    
    case "$1" in
        -u)
            update_cache
            exit 0
        ;;

        -h)
            show_help
            exit 0
        ;;
    esac

    pattern=$*

    [[ ! -a "$cachefile" || ! -s "$cachefile" ]] &&\
       print_ERR_and_die "App cache is empty."\
                         "Run \`app -u\`"
        
    if [ -z "$pattern" ];then
        app_name=$( fzf < "$namefile" | cut -d "|" -f1)
    else
        app_name=$( fzf -f "$pattern" < "$namefile" |head -n 1 | cut -d "|" -f1)
    fi

    [[ -z "$app_name" ]] && print_ERR_and_die "Couldnt get app"

    activity=$( grep "$app_name" "$cachefile" | cut -d "|" -f2 )
    echo "[*]launching $activity"

    am start -n "$activity" --user 0 > /dev/null 2>&1

}

main "$@"