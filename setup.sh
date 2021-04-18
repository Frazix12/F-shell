#!/data/data/com.termux/files/usr/bin/bash
clear
#get current dir
pdir=$(pwd)
#installing necessary packages
apt install figlet toilet -y > /dev/null 2>&1
pkg install git ruby ncurses-utils -y > /dev/null 2>&1
gem install lolcat
cd ~
rm -rf ../usr/share/figlet/
mv F-shell/figlet/ ../usr/share/
cd $HOME
clear
rm -rf .termux/*
mkdir .termux
mv F-shell/termux/* ~/.termux
# Setting up commands
getCPos() (
	local opt=$*
	exec < /dev/tty
	oldstty=$(stty -g)
	stty raw -echo min 0
	# on my system, the following line can be replaced by the line below it
	echo -en "\033[6n" > /dev/tty
	# tput u7 > /dev/tty    # when TERM=xterm (and relatives)
	IFS=';' read -r -d R -a pos
	stty $oldstty
	# change from one-based to zero based so they work with: tput cup $row $col
	row=$((${pos[0]:2} - 1))    # strip off the esc-[
	col=$((${pos[1]} - 1))
	if [[ $opt =~ .*-row.* ]]
	then
		printf $row
	else
		printf $col
	fi
)
spinner() (
	PID=$!
	stty -echo
	local opt=$*
	tput civis
	cstat(){
		local optstat="$(if [[ ! $opt =~ .*$1.* ]]
						 then
							 echo 0
						 else
							 echo 1
						 fi)"
		#echo $opt
		echo $optstat
	}
	#echo $(cstat -s)
	if [ "$(cstat -s)" -eq 1 ]
	then
		printf '\n'
		# While process is running...
		while kill -0 $PID 2> /dev/null;
		do  
			printf '\u2588\e[1B\e[1D\u2588\e[1A'
    		sleep 0.3
		done
	elif [ "$(cstat -p)" -eq 1 ]
	then
		while kill -0 $PID 2> /dev/null;
		do  
			printf '\u2588\e[1B\e[1D\u2588\e[1A'
    		sleep 0.3
		done
	elif [ "$(cstat -t)" -eq 1 ]
	then
		until [ $(getCPos) -eq $(($(tput cols))) ]
		do
			#echo $(getCPos) >> log.txt
			#getCPos
			#tput cols
			if [ ! $(getCPos) -eq $(($(tput cols)-1)) ]
			then
				printf '\u2588\e[1B\e[1D\u2588\e[1A'
				printf '\u2588\e[1B\e[1D\u2588\e[1A'
			else
				#echo 1
				#echo hi
				local row=$(($(getCPos -row)+1))
				local plen=$(tput cols)
				printf '\u2588'
				tput cup "$row" "$plen"
				printf '\u2588'
				break
			fi
		done
		printf "\n\n\nDone!\n"
	fi
	#echo hh
	tput cnorm
	stty echo
)
#Updating secondary packages
echo Updating Packages....	
pip install mdv > /dev/null 2>&1 & spinner -s
apt-get update > /dev/null 2>&1 & spinner -p
apt-get upgrade -y > /dev/null 2>&1 & spinner -p
apt-get autoremove > /dev/null 2>&1 & spinner -p
apt-get autoclean > /dev/null 2>&1 & spinner -p
apt-get install git -y > /dev/null 2>&1 & spinner -p && spinner -t
clear
#Script starts
#cd $HOME
#cd termuxstyling
echo "Script made by:- Code with Frazix"
#Assigns Username
if [ ! -e ".user.cfg" ] 
then
	printf "Type your username: "
	read uname
	echo "This is your username: $uname"
	echo "$uname" > .user.cfg
	echo "1" >> .user.cfg
	clear
#Rename Username
else
	printf "Would You Like to Change Your Username[Y/N]: "
	read ink
	case "$ink" in
		[yY][eE][sS]|[yY])
	rm .user.cfg;
	clear
	bash setup.sh;
	;;
	*)
	clear
	echo "Welcome back $uname"
	;;
	esac
fi
#installing script
echo "Installing..."
mkdir -p $PREFIX/var/lib/postgresql > /dev/null 2>&1 & spinner -s
if [ -e "/data/data/com.termux/files/usr/etc/motd" ];then rm ~/../usr/etc/motd;fi & spinner -p
sleep 0.1 & spinner -p && spinner -t
#Set default username if found null
if [ -z "$uname" ]
then
	uname="Frazix"
fi
#Sets bash.bashrc aka startup
echo "command_not_found_handle() {
        /data/data/com.termux/files/usr/libexec/termux/command-not-found "'$1'"
}
shell() {
	bash \$1.sh 2>/dev/null
	if [ \$? -ne 0 ]
	then 
		bash \$1.bash 2>/dev/null
		if [ \$? -ne 0 ]
		then
			printf '\e[0;31mNo shell script found\n'
		fi
	fi
}

figlet -f Font $uname | lolcat
PS1='\[\e[36m\]┌─[\[\e[37m\]\T\[\e[36m\]]─────\e[1;96m[Root@Termux]\e[0;36m───[\#]\n|\n\e[0;36m└─[\[\e[35m\]\e[0;94m\W\[\e[36m\]]────►\e[1;96m'

alias md=\"mkdir\"
alias msf=\"msfconsole\"
alias msfdb=\"initdb \$PREFIX/var/lib/postgresql;pg_ctl -D \$PREFIX/var/lib/postgresql start \"
alias clear=\"clear;printf '\e[0m';figlet -f Font $uname | lolcat\"
alias dir=\"ls\"
alias ins=\"pkg install\"
alias ains=\"apt install\"
alias cls=\"clear\"
alias rf=\"rm -rf\"
alias gic=\"git clone\"
alias fuck=\"printf '\e[0m';figlet FUCK;figlet OFF\"
alias upg=\"git reset --hard;git pull\"
alias update=\"apt-get update;apt-get upgrade\"" > /data/data/com.termux/files/usr/etc/bash.bashrc
cd /$HOME
echo Script made by
toilet Code with | lolcat
toilet Frazix | lolcat
sleep 2
echo Subscribe to our YT channel Codewith Frazix
echo Restart to apply changes
exit
