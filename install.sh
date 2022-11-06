#!/bin/bash

if (( $EUID != 0 )); then
    echo "Rode esse script usando root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf pterodactyl.tar.gz
    echo "Installing theme..."
    cd /var/www/pterodactyl
    rm -r pterodactyl
    git clone https://github.com/CatValentine-Dev/pterodactyl.git
    cd pterodactyl
    rm /var/www/pterodactyl/resources/scripts/MinecraftPurpleTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv MinecraftPurpleTheme.css /var/www/pterodactyl/resources/scripts/MinecraftPurpleTheme.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Tem certeza de que deseja instalar o tema [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Por favor responda yes ou no.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactyl/main/repair.sh)
}

restoreBackUp(){
    echo "Restoring backup..."
    cd /var/www/
    tar -xvf MinecraftPurpleThemebackup.tar.gz
    rm MinecraftPurpleThemebackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (c) 2022 TemuxOS"
echo "Esse progama e um software livre, você pode modificar e distribuir sem problemas"
echo ""
echo "Discord: https://discord.gg/WkVVtTaBRh/"
echo ""
echo "[1] Instalar o Tema"
echo "[2] Restaurar backup"
echo "[3] Reparar Painel (Use caso tenha algo problema na instalação do thema)"
echo "[4] Sair"

read -p "Insira um numero: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi