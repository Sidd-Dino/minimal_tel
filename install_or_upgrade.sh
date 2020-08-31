#!/usr/bin/env bash
printf '\e[38;5;6m'
printf '██████  ██████  ██████  ██              ██████  ██████  ██    \n'
printf '██████  ██  ██  ██████  ██                ██    ████    ██    \n'
printf '██  ██  ██  ██  ██  ██  ██████  ██████    ██    ██████  ██████\n'
printf '\e[m'

# status_function
status() {
    printf -- '\e[38;5;6m[*] %s\e[m\n' "$*"
}

# error_printing_function
error() {
    printf -- '\e[38;5;9m[ERR] %s\e[m\n' "$*"
    exit 1
}

get_shell() {
    rc="${HOME}/.${SHELL##*/}rc"

    [ ! -f "$rc" ] &&
       rc="${HOME}/.profile"
}

upgrade_mnml_tel() {
    status "upgrading mnml_tel"
    cd "$HOME/.mnml_tel" || error "Where the frick is $HOME/.mnml_tel"
    if git pull --rebase --stat origin master; then
        status "upgraded mnml_tel"
    else
        error "something's wrong with the upgrade"
    fi
}

install_mnml_tel() {
    pkg install git
    
    status "installing mnml_tel"
    
    git clone 'https://github.com/Sidd-Dino/mnml_tel.git' .mnml_tel ||\
    error "could not clone the git repository
'https://github.com/Sidd-Dino/mnml_tel.git'";
    
    get_shell
    echo ". ~/.mnml_tel/main" >> "$rc"
}

main() {
    # Preserve path
    old_pwd="$PWD"

    cd "$HOME" || error "Couldn't cd into home"

    # If .mnml_tel already exists upgrade mnml_tel
    [[ -d "$HOME/.mnml_tel" ]] && {
        upgrade_mnml_tel    
    }

    # If .mnml_tel doesn't exist install mnml_tel
    [[ ! -a "$HOME/.mnml_tel" ]] && {
        install_mnml_tel
    }

    cd "$old_pwd" || error "Couldn't cd back to intial directory"
}

main