#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
HEIGHT=20
WIDTH=90
CHOICE_HEIGHT=4
BACKTITLE="Fedora Setup Util"
TITLE="Please Make a selection"
MENU="Please Choose one of the following options:"

#Other variables
OH_MY_ZSH_URL="https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

#Check to see if Dialog is installed, if not install it - Thanks Kinkz_nl
if [ $(rpm -q dialog 2>/dev/null | grep -c "is not installed") -eq 1 ]; then
	sudo dnf install -y dialog
fi

OPTIONS=(1 "Enable RPM Fusion - Enables the RPM Fusion repos for your specific version"
	2 "Update Firmware - If your system supports FW update delivery"
	3 "Speed up DNF - Sets max parallel downloads to 10"
	4 "Enable Flatpak - Enables the Flatpak repo and installs packages located in flatpak-packages.txt"
	5 "Install Software - Installs software located in dnf-packages.txt"
	6 "Install Oh-My-ZSH - Installs Oh-My-ZSH along with Starship prompt"
	7 "Install Extras - Themes Fonts and Codecs"
	8 "Install Programming Languages - Go, Node, Python, C++/C"
	9 "Quit")

while [ "$CHOICE -ne 4" ]; do
	CHOICE=$(dialog --clear \
		--backtitle "$BACKTITLE" \
		--title "$TITLE" \
		--nocancel \
		--menu "$MENU" \
		$HEIGHT $WIDTH $CHOICE_HEIGHT \
		"${OPTIONS[@]}" \
		2>&1 >/dev/tty)

	clear
	case $CHOICE in
	1)
		echo "Enabling RPM Fusion"
		sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
		sudo dnf upgrade --refresh
		sudo dnf groupupdate -y core
		sudo dnf install -y rpmfusion-free-release-tainted
		sudo dnf install -y dnf-plugins-core
		notify-send "RPM Fusion Enabled" --expire-time=10
		;;
	2)
		echo "Updating System Firmware"
		sudo fwupdmgr get-devices
		sudo fwupdmgr refresh --force
		sudo fwupdmgr get-updates
		sudo fwupdmgr update
		;;
	3)
		echo "Speeding Up DNF"
		echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
		notify-send "Your DNF config has now been amended" --expire-time=10
		;;
	4)
		echo "Enabling Flatpak"
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
		flatpak update
		source flatpak-install.sh
		notify-send "Flatpak has now been enabled" --expire-time=10
		;;
	6)
		echo "Installing Oh-My-Zsh with Starship"
		sudo dnf -y install zsh util-linux-user
		sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"
		echo "change shell to ZSH"
		chsh -s "$(which zsh)"
		notify-send "Oh-My-Zsh is ready to rock n roll" --expire-time=10
		curl -sS https://starship.rs/install.sh | sh
		echo "eval "$(starship init zsh)"" >>~/.zshrc
		notify-send "Starship Prompt Activated" --expire-time=10
		;;
	7)
		echo "Installing Extras and Fonts"
		sudo dnf groupupdate -y sound-and-video
		sudo dnf install -y libdvdcss
		sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
		sudo dnf install -y lame\* --exclude=lame-devel
		sudo dnf group upgrade -y --with-optional Multimedia
		sudo dnf copr enable peterwu/iosevka -y
		sudo -s dnf -y copr enable dawid/better_fonts
		sudo dnf update -y
		sudo -s dnf install -y fontconfig-font-replacements
		sudo -s dnf install -y fontconfig-enhanced-defaults  
    		sudo dnf copr enable atim/lazygit -y
		sudo dnf install -y lazygit
		sudo dnf update -y 
		sudo dnf install -y iosevka-term-fonts jetbrains-mono-fonts-all gnome-shell-theme-flat-remix flat-remix-icon-theme flat-remix-theme terminus-fonts terminus-fonts-console google-noto-fonts-common mscore-fonts-all fira-code-fonts
    		cd ~/Downloads 
    		wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
		wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip

		# unpack fonts
		mkdir ~/.fonts && cd ~/.fonts
		unzip ~/Downloads/JetBrainsMono.zip
		unzip ~/Downloads/Hack.zip 

		# rebuild Fedora font cache
		fc-cache 
		cd ~/.dotfiles/
		notify-send "All done" --expire-time=10
		;; 
  8) 
		echo "Installing required programming languages"
    		sudo dnf install -y gcc gcc-c++ golang nodejs python
		notify-send "All base programming langauges have been installed" --expire-time=10	 
		;;
   9)
		echo "Installing neovim" 
    sudo dnf install -y neovim
		;;
	10)
		exit 0
		;;
	esac
done
