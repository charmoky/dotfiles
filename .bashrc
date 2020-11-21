#
# ~/.bashrc
#

if ! pgrep -u $USER ssh-agent > /dev/null; then
    eval $(ssh-agent > ~/.ssh-agent-thing)
fi

if [ "$PS1" ]; then
    echo -n
fi

#if [[ "$SSH_AGENT_PID" == "" ]]; then
#  eval $(<~/.ssh-agent-thing)
#fi
#ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
        
#Exports
force_color_prompt=yes
export PATH=$PATH:/home/$USER/bin/
export SUDO_EDITOR=vim
export EDITOR=vim
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_ENABLE_HIGHDPI_SCALING=0
#export GEM_HOME=$(ruby -e 'print Gem.user_dir')

#PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

eval `dircolors ~/.dir_colors`

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh'
alias grep='grep --color=auto'
alias voui='sudo pacman -Syu --noconfirm'
alias reboot='sudo systemctl reboot'
alias cv='cd /Yep/Documents/CV'
alias matlab='sudo /usr/local/MATLAB/R2018a/bin/matlab'
alias pikaur='pikaur --noconfirm'
PS1='[\u@\h-$(show_temp) \W]\$ '

if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
    echo "Launching tmux session"
    tmux
fi
