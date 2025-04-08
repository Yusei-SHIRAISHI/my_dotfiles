if [[ -d $HOME/.zsh.d ]];then
  for x in `ls $HOME/.zsh.d/`;do
      source $HOME/.zsh.d/${x}
  done
fi

setopt SH_WORD_SPLIT

setopt prompt_subst
autoload -U colors; colors
autoload -Uz add-zsh-hook

#prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' formats       \
    "[%F{green}%b%f] %m"
zstyle ':vcs_info:*' actionformats \
    "[%F{magenta}%b|%F{red}%a%f] %m"
zstyle ':vcs_info:git+set-message:*' hooks \
	git_set_status_to_misc
function +vi-git_set_status_to_misc() {
  if [[ "$hook_com[staged]" == "S" ]] || [[ "$hook_com[unstaged]" == "U" ]]; then
    hook_com[misc]="×"
  elif [[ -n "$(git log $hook_com[branch]..origin/$hook_com[branch] 2> /dev/null)" ]]; then
    hook_com[misc]="↓"
  elif [[ -n "$(git log origin/$hook_com[branch]..$hook_com[branch] 2> /dev/null)" ]]; then
    hook_com[misc]="↑"
  else
    hook_com[misc]="○"
  fi
	return 0
}
precmd () { vcs_info }

PROMPT="%K{green}💩%k %F{cyan}%1~%f \${vcs_info_msg_0_}"
add-zsh-hook precmd update_prompt
function update_prompt() {
  if [[ $? -eq 0 ]]; then
		exit_status_color='green'
	else
		exit_status_color='red'
	fi
  PROMPT="%K{${exit_status_color}}💩%k %F{cyan}%1~%f\${vcs_info_msg_0_} "
}

#completion
autoload -U compinit && compinit
fpath=(~/.zsh/completion $fpath)
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:setopt:*' menu true select
zstyle ':completion:*:default' list-colors di=36 ex=31 ln=35
zstyle ':completion:*' completer _complete _approximate _correct _prefix
zstyle ':completion:*:approximate' max-errors 2 NUMERIC

#opt
setopt auto_cd
setopt auto_menu
setopt list_packed
setopt list_types
setopt noautoremoveslash
setopt magic_equal_subst
setopt print_eight_bit

#export
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8


#alias
alias ls="ls --color=auto -F"
alias la='ls -a'
alias ll='ls -l -a'
alias cl='clear'

if [ -f /usr/local/bin/tmux ]; then
    alias t="tmux";
    alias tls="tmux ls";
fi


. "$HOME/.local/bin/env"
