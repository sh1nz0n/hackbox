#!/usr/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

tmpdir=/var/tmp/hackbox

mkdir $tmpdir
cd $tmpdir

# install deps
apt -y install unzip python3-pip

# install basic enumeration tools
apt -y install nmap sqlmap dnsenum dnsmap dnsrecon ffuf gobuster dirb

# install basic password cracking & brute forcing tools
apt -y install john hydra medusa hashcat

# install seclists
wget https://github.com/danielmiessler/SecLists/archive/refs/tags/2022.4.tar.gz \
 && tar xzvf ./2022.4.tar.gz \
 && mv ./SecLists-2022.4 /usr/share/seclists \
 && tar xzvf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/seclists/Passwords/Leaked-Databases/ \
 && ln -sf /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt /usr/share/seclists/rockyou.txt 

# install metasploit
wget https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb \
  && chmod +x msfupdate.erb \
  && ./msfupdate.erb

# install mimikatz 2.2.0-20220919
wget https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.zip
mkdir -p /root/tools/mimikatz \
  && cd /root/tools/mimikatz \
  && unzip $tmpdir/mimikatz_trunk.zip \
  && cp -a /root/tools/mimikatz /etc/skel/tools

cd $tmpdir

# install Villain backdoor framework
git clone https://github.com/t3l3machus/Villain.git \
  && pip3 install -r $tmpdir/Villain/requirements.txt \
  && cp -a $tmpdir/Villain /etc/skel/tools \
  && cp -a $tmpdir/Villain /root/tools

cd $tmpdir

# download burp suite community edition 2023.1.2 installer
curl -o burpsuite_community_linux_v2023_1_2.sh 'https://portswigger-cdn.net/burp/releases/download?product=community&version=2023.1.2&type=Linux' \
  && chmod +x burpsuite_community_linux_v2023_1_2.sh \
  && ln -sf $tmpdir/burpsuite_community_linux_v2023_1_2.sh /etc/skel/tools/ \
  && ln -sf $tmpdir/burpsuite_community_linux_v2023_1_2.sh /root/tools/
  
cd $tmpdir

# install winPEAS & linPEAS
mkdir -p /root/tools \
  && wget https://github.com/carlospolop/PEASS-ng/archive/refs/tags/20230212.tar.gz \
  && tar xzvf 20230212.tar.gz \
  && mv PEASS-ng-20230212 /root/tools/peass \
  && cp -a /root/tools/peass /etc/skel/tools

cd $tmpdir

# install powerup
wget https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1 \
  && cp -a ./PowerUp.ps1 /root/tools/ \
  && cp -a ./PowerUp.ps1 /etc/skel/tools 

# install tailscale
# curl -fsSL https://tailscale.com/install.sh | sh

# create bashrc
cp /etc/skel/.bashrc /etc/skel/.bashrc.orig
cp /root/.bashrc /root/.bashrc.orig
cat << 'EOF' > /etc/skel/.bashrc
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
        if [ "$USER" = root ]; then
                PS1="\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;11m\]@\h\[$(tput sgr0)\]\[\033[38;5;14m\]:\[$(tput sgr0)\]\[\033[38;5;11m\]\w\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;14m\]>\[$(tput sgr0)\] \[$(tput sgr0)\]"
        else
                PS1="\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;11m\]@\h\[$(tput sgr0)\]\[\033[38;5;14m\]:\[$(tput sgr0)\]\[\033[38;5;11m\]\w\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;14m\]>\[$(tput sgr0)\] \[$(tput sgr0)\]"
        fi
else
        PS1="\u@\h:\w > \[$(tput sgr0)\]"
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
EOF

. /etc/skel/.bashrc
cp -a /etc/skel/.bashrc /root
