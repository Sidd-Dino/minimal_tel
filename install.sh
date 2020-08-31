#!/usr/bin/env bash
printf '██████  ██████  ██████  ██              ██████  ██████  ██    \n'
printf '██████  ██  ██  ██████  ██                ██    ████    ██    \n'
printf '██  ██  ██  ██  ██  ██  ██████  ██████    ██    ██████  ██████\n'

old_pwd="$PWD"
PWD="~"

# status_function
status() {
    printf -- '\e[38;5;6m%s\e[m\n' "$*"
}

#error_printing_function
error() {
    printf -- '\e[38;5;9m%s\e[m\n' "$*"
}

status "[*] updating packages"
pkg update -y 2>&1

status "[*] upgrading packages"
pkg upgrade -y 2>&1

status "[*] installing dependencies"
pkg install fzf curl wget nano ncurses-utils python jq git make -y 2>&1

[[ -a ".mnml_tel" ]] || {
    status "[*] installing framework"
    git clone 'https://github.com/Sidd-Dino/mnml_tel.git' .mnml_tel
    cd .mnml_tel || { print "[ERR] could not clone the git repository\n'https://github.com/Sidd-Dino/mnml_tel.git'"; exit 1; }
}

echo ". ~/.mnml_tel/main.sh" >> ~/.bashrc

status "[*] installing dino prompt"
curl "https://raw.githubusercontent.com/Sidd-Dino/dino_prompt/master/install.sh" | sh

cd "$old_pwd" || exit 1