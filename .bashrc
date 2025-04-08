[ -e $HOME/.zshenv ] && source $HOME/.zshenv

if [ $(uname) = 'Darwin' ];then
    alias ls="ls -G"
    if [ -f /usr/local/bin/gls ];then
        alias ls="gls --color=auto"
    fi
else
    alias ls="ls --color=auto"
fi

alias la="ls -a"
alias lal="ls -la"
alias sl="ls"
alias ll="ls -l"

alias poweroff="sudo shutdown -h now"

psgrep() {
    term=$(echo $1 | perl -pe "s/(.)(.*)/[\1]\2/")
    ps -ef | grep ${term};
}

if [ -f /usr/local/bin/tmux ]; then
    alias t="tmux";
    alias tls="tmux ls";
fi


export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

. "$HOME/.local/bin/env"
