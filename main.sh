#!/bin/bash

osCheck() {
    if [[ $OSTYPE == "linux-gnu" ]]; then
        return 1
    fi
    return 0
}

cat <<'ASCII'
  _   _             _     ____  _                      _                     
 | | | |_   _ _ __ | |_  / ___|| |__   _____      ____| | _____      ___ __  
 | |_| | | | | '_ \| __| \___ \| '_ \ / _ \ \ /\ / / _` |/ _ \ \ /\ / / '_ \ 
 |  _  | |_| | | | | |_   ___) | | | | (_) \ V  V / (_| | (_) \ V  V /| | | |
 |_| |_|\__,_|_| |_|\__| |____/|_| |_|\___/ \_/\_/ \__,_|\___/ \_/\_/ |_| |_|
                                                                             
                H U N T   S H O W D O W N   P L Y M O U T H
                                             by - Anxhul10
ASCII

if [ osCheck $1 ]; then
    if [[ "$(id -u)" -ne 0 ]]; then
        echo "Please run this as root"
    else 
        source /etc/os-release
        echo -e "\e[31m$NAME detected !!\e[0m"
        if [ "$NAME" = "Ubuntu" ]; then
            read -p "Enter the priority of plymouth : " priority < /dev/tty
            cd  /usr/share/plymouth/themes
            sudo rm -rf huntShowdown-plymouth
            sudo git clone https://github.com/Anxhul10/huntShowdown-plymouth.git
            sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/huntShowdown-plymouth/huntShowdown-plymouth.plymouth $priority
            sudo update-alternatives --config default.plymouth
            sudo update-initramfs -u
            printf "\n\e[32mPlease restart your system to see Plymouth. !!\e[0m\n"
        elif [ "$NAME" = "Fedora Linux" ]; then
            # install dependency on each install (redundant process)
            echo " Is plymouth-theme-script installed in your Fedora Linux ? y/n"
            read answer
            if [ "$answer" != "${answer#[Yy]}" ] ;then 
                echo "skipping plymouth-theme-script installation!!"
            else
                sudo dnf install plymouth-theme-script git
            fi
            cd  /usr/share/plymouth/themes
            sudo rm -rf huntShowdown-plymouth
            sudo git clone https://github.com/Anxhul10/huntShowdown-plymouth.git
            sudo plymouth-set-default-theme huntShowdown-plymouth -R
            sudo dracut --force
            printf "\n\e[32mPlease restart your system to see Plymouth. !!\e[0m\n"
        elif [ "$NAME" = "Arch Linux" ]; then
            echo " Is plymouth installed in your Arch Linux ? y/n"
            read answer
            if [ "$answer" != "${answer#[Yy]}" ] ;then 
                echo "skipping plymouth installation!!"
            else
                sudo pacman -S plymouth
                sudo systemctl enable plymouth-start.service
            fi
            cd  /usr/share/plymouth/themes
            sudo git clone https://github.com/Anxhul10/huntShowdown-plymouth.git
            sudo plymouth-set-default-theme -R huntShowdown-plymouth
            printf "\n\e[32mPlease restart your system to see Plymouth. !!\e[0m\n"
        else 
            echo "Currently, this CLI supports Ubuntu and Fedora."
            echo "If your Linux distribution is not supported, please open an issue at:"
            echo "https://github.com/Anxhul10/huntShowdown-plymouth/issues"
       fi

        
    fi
else 
    echo "Please use linux-gnu"
fi