# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PROMPT_COMMAND=ExitStatus

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias lgot='gnome-session-quit'
alias g+='g++ -Wall -Wextra -std=c++17 -O2'
alias gc='gcc -Wall -Wextra -std=c17'
alias cowsay='cowsay -f dragon-and-cow $1'
alias sshfs='sshfs -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=3'
alias py="source $HOME/Project/venv/bin/activate"

#The command 'command' is very important. It prevents functions to recursively call itself forever.
Green="\033[0;92m"
Red="\033[0;31m"
Frog="\xF0\x9F\x90\xB8"
Cross="\xE2\x9D\x8E"
White="\033[0m"
Cyan="\033[0;96m"
Bold=`tput bold`
NonBold=`tput sgr0`
Start=0
OriginPS1=$PS1
ExitStatus () {
	Exit=$?
	if [[ $Start != 0 ]]; then
		printf "\n"
	fi
	Date=`date +%Y/%m/%d`
	if [[ $Exit == 0 ]]; then
		PS1="\[$Green\]\$(printf '$Frog')$Exit$OriginPS1\[$White\]$Date \t\n\[$Cyan\]\[$Bold\]~>\[$NonBold\]\[$White\] "
	else
		PS1="\[$Red\]\$(printf '$Cross')$Exit$OriginPS1\[$White\]$Date \t\n\[$Cyan\]\[$Bold\]~>\[$NonBold\]\[$White\] "
	fi

	Start=1
}

cd () {
	if [[ $# != 0 ]]; then
		command cd "$@";
	fi
}

rm () {
	Flag=0;
	for i in "$@"
	do
		if [[ $i == '-f' || $i == '-rf' || $i == '-fr' ]]; then
			Flag=1
			break
	       	fi
	done
	if [[ $Flag == 1 ]]; then
		printf "Removing in 3 seconds..."
		Final=$(delay)
		if [[ $Final == true ]]; then
			command rm "$@"
		fi
	else
		command rm -i "$@"
	fi
}

delay () {
	command sleep 3
	if [[ $? == 0 ]]; then
		echo true
	else
		echo false
	fi
}

after () {
	min=$1
	shift
	echo "notify-send '$@'" | at now + $min minute
}

bind "TAB:menu-complete"
bind '"\e[Z":menu-complete-backward'
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind "\C-h:backward-kill-word"
bind '"\e[3;5~":shell-kill-word'
