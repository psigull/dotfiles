export EDITOR="nano"
export PAGER="less"
export LESS='--mouse --wheel-lines=3'
# git config --global core.pager "less -+X -R"

export PATH="$HOME/.local/bin:$PATH"
export GOPATH="$HOME/.go"


# helpers and aliases
alias ls="LC_COLLATE=C ls --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff='diff --color=auto'
alias ip='ip --color=auto'

alias srm='/usr/bin/rm'
alias trm='trash'
alias rm='echo "use trash/trm or srm instead"'

alias pn='pnpm'
alias cpr='rsync -ah --partial --info=progress2'

alias glo="git log --oneline"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias ga="git add"
alias gus="git restore --staged"
alias gcm="git commit -m"
alias gbp="git branch -M master && git push -u origin master"
alias gp="git push"

alias gres="git checkout HEAD -- "
alias gresall="git reset --hard HEAD"
alias greb="git rebase -i "

function calc() {
	echo $* | bc -l
}
alias calc='noglob calc'

alias running='ps xfo tty=,pid=,cmd= --sort=tty' # list running user processes
alias manb="BROWSER=firefox man --html" # open manual entry in browser

alias umu='PROTONPATH=GE-Proton WINEPREFIX=$PWD/00_pfx umu-run '
alias nonet='sg nonet "$@"' # iptables -I OUTPUT -m owner --gid-owner nonet -j REJECT
alias fixwaybar='touch -m .config/waybar/config.jsonc'

alias mpvseq='mpv --merge-files=yes --mf-fps=24 "mf://*.png"'
alias ffseq='ffmpeg -framerate 24 -pattern_type glob -i "*.png" -c:v libx264 out.mp4'

# `helpf grep v` => shows `grep --help` for 'v' flag
function helpf() {
	($1 "--help") | grep -A 7 -E "^\s+?-$2"
}

# exclude csv of file ext from `fd`
function xfiles() {
	str=${1:gs/,/|}
	fd -t f | grep -vEi ".+\.$str"
}

function closefirefox() {
	hyprctl dispatch focuswindow class:firefox
	sleep 0.1

	if ! pidof -q 'ydotoold'; then
		ydotoold &
		sleep 1
	fi

	ydotool key 29:1 16:1 16:0 29:0
	sleep 2
}
alias shutdown='closefirefox && systemctl poweroff'
alias reboot='closefirefox && systemctl reboot'
alias hibernate='systemctl hibernate'


# bluetooth helpers
HEADPHONES="Soundcore"
CONTROLLER="DualSense"
HP_DEV=$(bluetoothctl devices | sed -nE "s/Device\s+(.+)\s+$HEADPHONES.+/\1/pi")
CT_DEV=$(bluetoothctl devices | sed -nE "s/Device\s+(.+)\s+$CONTROLLER.+/\1/pi")
alias btconn="bluetoothctl connect $1"
alias btdisc="bluetoothctl disconnect $1"

alias btbatt="bluetoothctl info | grep Battery"
alias hpconn="btconn $HP_DEV"
alias hpdisc="btdisc $HP_DEV"
alias ctconn="btconn $CT_DEV"
alias ctdisc="btdisc $CT_DEV"

# add file into dotfiles repo
function unstow() {
	str=${1/~/.}
	dn=$(dirname $str)
	mkdir -p $dn
	cp -r $1 $str
	stow --adopt .
}

# check if files match
function fmatch() {
	sumA=$(sha256sum "$1" | awk '{ print $1 }')
	sumB=$(sha256sum "$2" | awk '{ print $1 }')
	echo $sumA
	echo $sumB
	if [[ $sumA == $sumB ]]; then
		echo " > match"
	else
		echo " > DIFFERENT"
	fi
}

# diff two folders
function lsdiff() {
	lsA=$(ls -r1 $1)
	lsB=$(ls -r1 $2)
	diff <(echo "$lsA") <(echo "$lsB")
}


# prompt stuff
if [[ ! -o interactive ]]; then
	return
fi

setopt prompt_subst transient_rprompt

autoload -Uz vcs_info
zstyle ":vcs_info:git*" formats "%b "

function set_title() {
	title=${1/\/home\/${USER}/\~}
	echo -ne "\e]2;$title\007"
}

function preexec() {
	set_title $1
	timer=${timer:-$SECONDS}
}

function precmd() {
	if [ $timer ]; then
		timer_show=$(($SECONDS - $timer))
		export RPROMPT="%(?..%F{yellow}[%?]%f  )%F{7}${timer_show}s%f"
		unset timer
	fi
	
	set_title $PWD
	vcs_info
}

PROMPT='%F{8}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f%F{green}>%f  '


# settings
setopt append_history share_history
HISTFILE=~/.zhistfile
HISTSIZE=5000
SAVEHIST=10000

setopt longlistjobs
setopt extendedglob nomatch noglobdots
setopt notify nobeep
unsetopt autocd
unsetopt prompt_sp

eval $(dircolors -b)


# keybinds
bindkey -e

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[2~" overwrite-mode
bindkey "^[[3~" delete-char
bindkey "^[[5~" up-line-or-search
bindkey "^[[6~" down-line-or-search
bindkey "^[[A" up-line-or-search
bindkey "^[[B" down-line-or-search
bindkey "^[[D" backward-char
bindkey "^[[C" forward-char
bindkey "^K" kill-line
bindkey "^U" backward-kill-line



# completion
setopt hash_list_all hist_ignore_all_dups
setopt correct menu_complete completeinword

autoload -Uz compinit
compinit


# start grml-etc-core...

	# allow one error for every three characters typed in approximate completer
	zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
	# start menu completion only if it could find no unambiguous initial string
	zstyle ':completion:*:correct:*'       insert-unambiguous true
	zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
	zstyle ':completion:*:correct:*'       original true
	# activate color-completion
	zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
	# format on completion
	zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
	# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
	zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
	# insert all expansions for expand completer
	zstyle ':completion:*:expand:*'        tag-order all-expansions
	zstyle ':completion:*:history-words'   list false
	# activate menu
	zstyle ':completion:*:history-words'   menu yes
	# ignore duplicate entries
	zstyle ':completion:*:history-words'   remove-all-dups yes
	zstyle ':completion:*:history-words'   stop yes
	# match uppercase from lowercase
	zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'
	# separate matches into groups
	zstyle ':completion:*:matches'         group 'yes'
	zstyle ':completion:*'                 group-name ''
	# if there are more than 5 options allow selecting from a menu
	zstyle ':completion:*'                 menu select=1
	zstyle ':completion:*:messages'        format '%d'
	zstyle ':completion:*:options'         auto-description '%d'
	# describe options in full
	zstyle ':completion:*:options'         description 'yes'
	# on processes completion complete all user processes
	zstyle ':completion:*:processes'       command 'ps -au$USER'
	# offer indexes before parameters in subscripts
	zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
	# provide verbose completion information
	zstyle ':completion:*'                 verbose true
	# recent (as of Dec 2007) zsh versions are able to provide descriptions
	# for commands (read: 1st word in the line) that it will list for the user
	# to choose from. The following disables that, because it's not exactly fast.
	zstyle ':completion:*:-command-:*:'    verbose false
	# set format for warnings
	zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
	zstyle ':completion:correct:'          prompt 'correct to: %e'
	# Ignore completion functions for commands you don't have:
	zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
	# Provide more processes in completion of programs like killall:
	zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
	# complete manual by their section
	zstyle ':completion:*:manuals'    separate-sections true
	zstyle ':completion:*:manuals.*'  insert-sections   true
	zstyle ':completion:*:man:*'      menu yes select
	# provide .. as a completion
	zstyle ':completion:*' special-dirs ..
	# run rehash on completion so new installed program are found automatically:
	function _force_rehash () {
		(( CURRENT == 1 )) && rehash
		return 1
	}
	zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored

# ...end grml-etc-core


# interactive stuff
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=""
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=""
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey "^[[1;5A" kill-line
bindkey "^[[1;5B" backward-kill-line

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(completion)
