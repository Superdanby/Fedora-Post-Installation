#!/bin/bash
# https://github.com/Superdanby/Fedora-Post-Installation
# Start this script with local privileges only!

# Created by argbash-init v2.5.0
# ARG_OPTIONAL_BOOLEAN([nvidia],[],[<nvidia's help message goes here>])
# ARG_OPTIONAL_BOOLEAN([dnfyes],[],[<dnfyes's help message goes here>])
# ARG_HELP([<The general help message of my script>])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.5.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info

die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}

begins_with_short_option()
{
	local first_option all_short_options
	all_short_options='h'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}



# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_nvidia=off
_arg_dnfyes=off

print_help ()
{
	printf "%s\n" "<Fedora Post Installation Script>"
	printf 'Usage: %s [--(no-)nvidia] [--(no-)dnfyes] [-h|--help]\n' "$0"
	printf "\t%s\n" "--nvidia: <Installs Nvidia drivers and CUDA from Negativo17.org. Be sure to check out https://github.com/Superdanby/Grub-Nvidia-Entry.> (off by default)"
	printf "\t%s\n" "--dnfyes: <Replies yes to all dnf prompts.> (off by default)"
	printf "\t%s\n" "-h,--help: Prints help"
}

parse_commandline ()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			--no-nvidia|--nvidia)
				_arg_nvidia="on"
				test "${1:0:5}" = "--no-" && _arg_nvidia="off"
				;;
			--no-dnfyes|--dnfyes)
				_arg_dnfyes="on"
				test "${1:0:5}" = "--no-" && _arg_dnfyes="off"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


echo "nvidia is $_arg_nvidia"
echo "dnfyes is $_arg_dnfyes"

Y=''
if [ "$_arg_dnfyes" = on ]
then
    Y='-y'
fi

printf "Configuring dnf to keep caches\n"
[[ -e /etc/dnf/dnf.conf.bak ]] && sudo mv /etc/dnf/dnf.conf.bak /etc/dnf/dnf.conf
sudo cp -p /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak
echo "keepcache=1" | sudo tee -a /etc/dnf/dnf.conf
echo "fastestmirror=1" | sudo tee -a /etc/dnf/dnf.conf
echo "minrate=10k" | sudo tee -a /etc/dnf/dnf.conf
echo "timeout=10" | sudo tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
printf "Done!\n\n"

printf "Installing Google Chrome\n"
curl https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm --output ~/Downloads/google-chrome-stable_current_x86_64.rpm
sudo dnf $Y install ~/Downloads/google-chrome-stable_current_x86_64.rpm
printf "Done!\n\n"

printf "Setting up git...\n"
printf "Please insert git user name:\n"
read git_name
git config --global user.name "$git_name"
printf "\nPlease insert git email:\n"
read git_email
git config --global user.email "$git_email"
printf "Done!\n\n"

printf "Generating public private key pair"
ssh-keygen -t rsa -b 4096 -C "$git_email"
ssh-add ~/.ssh/id_rsa
printf "Done!\n\n"

printf "Add SSH key to Github?\n"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) printf "Please go to https://github.com/settings/keys and add the your public key:";
		cat .ssh/id_rsa.pub; printf "\n"; read -p "Press enter to continue"; ssh -T git@github.com; break;;
		No ) break;;
	esac
done
printf "Done!\n\n"

printf "Disabling Gnome Screen Recorder's time limit\n"
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0
printf "Done!\n\n"

printf "Enable fstrim.timer for SSD?\n"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) sudo systemctl enable fstrim.timer; break;;
		No ) break;;
	esac
done
printf "Done!\n\n"

printf "Replacing .bashrc\n"
[[ -e ~/.bashrc.bak ]] || mv ~/.bashrc ~/.bashrc.bak
mv .bashrc ~/.bashrc
printf "Done!\n\n"

printf "Installing ibus-chewing\n"
sudo dnf $Y install ibus-chewing
printf "Done!(Re-login to take effect.)\n\n"

printf "Installing C Development Tools and Libraries\n"
sudo dnf $Y groupinstall "C Development Tools and Libraries"
sudo dnf $Y install clang astyle
printf "Done!\n\n"

printf "Installing Cross Compilation Essentials\n"
sudo dnf $Y install gmp-devel mpfr-devel libmpc-devel
printf "Done!\n\n"

printf "Enabling RPM Fusion\n"
sudo dnf $Y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
printf "Done!\n\n"

printf "Installing: htop, gnome-tweak-tool(gnome-tweaks), gnome-terminal-nautilus, gnome-usage(available on F28+), vlc, and lollypop\n"
sudo dnf $Y install htop gnome-tweaks gnome-terminal-nautilus gnome-usage lollypop vlc
printf "Done!\n\n"

printf "Installing: unrar\n"
sudo dnf $Y install unrar
printf "Done!\n\n"

printf "Installing mkvtoolnix, gaupol, and openshot\n"
sudo rpm -Uhv https://mkvtoolnix.download/fedora/bunkus-org-repo-2-3.noarch.rpm
sudo dnf $Y install mkvtoolnix gaupol openshot
printf "Done!\n\n"

printf "Installing argbash, vim, Atom, and ShellCheck\n"
sudo rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey
sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/yum.repos.d/atom.repo'
sudo dnf $Y install argbash vim atom ShellCheck
printf "Ensure Atom launching from Application view works.\n"
sudo sed -i -e 's/\/share\/atom\/atom/\/bin\/atom/g' /usr/share/applications/atom.desktop
printf "Done!\n\n"

printf "Do you want to make Atom the default GUI editor?\n"
if [[ "$_arg_dnfyes" = on ]]; then
	xdg-mime default atom.desktop text/plain
else
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) xdg-mime default atom.desktop text/plain; break;;
			No ) break;;
		esac
	done
fi

printf "Installing Powertop & tuned-utils\n"
sudo dnf $Y install powertop tuned-utils
sudo systemctl start tuned
printf "tuned recommendation: "
tuned-adm recommend
echo "SUBSYSTEM==\"power_supply\", ATTR{online}==\"0\", RUN+=\"`whereis tuned-adm | cut -d' ' -f2` profile laptop\"" | sudo tee --append /etc/udev/rules.d/powersave.rules
echo "SUBSYSTEM==\"power_supply\", ATTR{online}==\"1\", RUN+=\"`whereis tuned-adm | cut -d' ' -f2` profile desktop\"" | sudo tee --append /etc/udev/rules.d/powersave.rules
echo "SUBSYSTEM==\"power_supply\", ATTR{status}==\"Discharging\", RUN+=\"`whereis tuned-adm | cut -d' ' -f2` profile laptop\"" | sudo tee --append /etc/udev/rules.d/powersave.rules
echo "SUBSYSTEM==\"power_supply\", ATTR{status}!=\"Discharging\", RUN+=\"`whereis tuned-adm | cut -d' ' -f2` profile desktop\"" | sudo tee --append /etc/udev/rules.d/powersave.rules
sudo udevadm control --reload-rules && udevadm trigger
sudo systemctl enable tuned
printf "\nDone!\n\n"

printf "Enableing Bluetooth reconnection ability\n"
sudo sed -i '/ReconnectAttempts=/s/#//g' /etc/bluetooth/main.conf
sudo sed -i '/ReconnectIntervals=/s/#//g' /etc/bluetooth/main.conf
printf "\nDone!\n\n"

printf "Installing Dolphin Emulator, Wireshark, and Fedora Media Writer\n"
sudo dnf $Y install dolphin-emu wireshark mediawriter
printf "Done!\n\n"

printf "Installing Gnome - Chrome Integration(Starting from F27, the copr repo is no longer required.)\n"
# dnf copr enable region51/chrome-gnome-shell
sudo dnf $Y install chrome-gnome-shell
printf "Done!\n\n"

# printf "Installing backgrounds(Gnome) starting from f27\n"
# sudo dnf $Y install f2[78]-backgrounds-gnome f2[78]-backgrounds-extras-gnome f2*-backgrounds-animated
# printf "Done!\n\n"

printf "Gnome icon theme is renewed in Gnome 3.22\n"
# printf "Installing paper-icon-theme\n"
# sudo dnf $Y copr enable heikoada/gtk-themes
# sudo dnf $Y install paper-icon-theme
# printf "Done!\n\n"

if [ "$_arg_nvidia" = on ]
then
    printf "Adding nvidia-driver & cuda tools repo from negativo17.org.\n"
    sudo dnf $Y config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo
    printf "Done!\n\n"

    printf "Installing Nvidia drivers and Cuda development tools.\n"
    sudo dnf $Y install nvidia-settings kernel-devel dkms-nvidia vulkan.i686 nvidia-driver-libs.i686 cuda-devel nvidia-modprobe
    printf "Done!\n\n"

    printf "For laptop users, please check out https://github.com/Superdanby/Grub-Nvidia-Entry\n"
fi

printf "Installing vulkan-tools\n"
sudo dnf $Y install vulkan-tools
printf "Done!\n\n"

printf "Possibly further configurations: /etc/fstab, Java\n"
printf "References: https://superdanby.github.io/Blog/fedora-installation.html\n"

# ] <-- needed because of Argbash
