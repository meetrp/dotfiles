#####################################################################
# My Changes

# -- Common
if [ $(id -u) -eq 0 ]; then
PS1="\[\033[36m\][ \d \t ] \[\033[32m\]\[\e[30;43m\]\u\[\e[m\]@\H:\[\033[33m\]\$PWD\n\[\033[00m\]$> "
else
PS1="\[\033[36m\][ \d \t ] \[\033[32m\]\u@\H:\[\033[33m\]\w\n\[\033[00m\]$> "
fi


alias s='source ~/.bashrc'

alias ..='cd ..'
alias grep='grep --color'                     # show differences in colour
alias g='grep -rIin'
alias f='find . -iname'

alias ls='ls -hF --color=tty'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias lt='ll -tr'                             # long list in reverse order

#alias vim='gvim'
alias vi='vim'
alias e='emacs'

# -- Code and related
alias ct='find | grep "\.c$\|\.h$\|.sh$" | grep -v 'test' > ./cscope.files; cscope -b; ctags -L cscope.files'
alias cs='find | grep "\.c$\|\.h$\|.sh$" | grep -v 'test' > ./cscope.files; cscope -b; ctags -L cscope.files; cscope'
export CSCOPE_EDITOR="vim"

alias mc='make clean'
alias mcm='make clean; make'

# -- git and related
function __version() {
	#
	# is this a git repo?!
	local BRANCH=$(git symbolic-ref HEAD 2>/dev/null | cut -d'/' -f3-)
	if [ -z $BRANCH ]; then
		echo "Not a git repo!"
		return
	fi

	#
	# mandatory details
	local BRANCH_NAME=$(echo $BRANCH | awk -F'/' '{print $NF}')
	local COMMIT=$(git reflog -n1 2> /dev/null | awk '{print $1}')
	local COUNT=$(git rev-list --all --count 2> /dev/null)

	#
	# tag details
	local TAG=""
	local DESCRIBE=$(git describe --tags 2> /dev/null)
	if [ ! -z $DESCRIBE ]; then
		local TAG=$(echo $DESCRIBE | awk '{split($0,a,"-"); print a[1]}')
		local COUNT=$(echo $DESCRIBE | awk '{split($0,a,"-"); print a[2]}')
		local VER="$TAG (${COMMIT}@$BRANCH)"
	fi

	if [ -z $COUNT ]; then
		COUNT="0";
	fi;

	#
	# helper variables
	local SUFFIX=".$COUNT ($COMMIT)"
	local SUFFIX_BRANCH=".$COUNT ($COMMIT@$BRANCH_NAME)"
	[[ -z $VER ]] && VER="$BRANCH_NAME$SUFFIX"

	#
	# git-flow aware branches
	if echo $BRANCH | grep -q "\<master\>"
	then
		[[ -z $TAG ]] && VER="" || VER="$TAG-"
		VER=$VER"rel$SUFFIX"
	elif echo $BRANCH | grep -q "\<develop\>"
	then
		[[ -z $TAG ]] && VER="" || VER="$TAG-"
		VER=$VER"alpha$SUFFIX"
	elif echo $BRANCH | grep -q "\<release/"
	then
		[[ -z $TAG ]] && VER="" || VER="$TAG-"
		VER=$VER"rc$SUFFIX_BRANCH"
	elif echo $BRANCH | grep -q "\<hotfix/"
	then
		[[ -z $TAG ]] && VER="" || VER="$TAG-"
		VER=$VER"fix$SUFFIX_BRANCH"
	elif echo $BRANCH | grep -q "\<feature\/"
	then
		[[ -z $TAG ]] && VER="" || VER="$TAG-"
		VER=$VER"wip$SUFFIX_BRANCH"
	fi

	echo $VER
}

function __log() {
	local __COUNT=$1
	local __GIT_MIN_VERSION=1.8.3
	local __GIT_VERSION=$(git --version | awk '{print $3}')

	if [ $(awk 'BEGIN{ print "'$__GIT_VERSION'"<"'$__GIT_MIN_VERSION'" }') -eq 1 ]; then
		git log --pretty=format:"%C(yellow)%h%C(reset) ||%C(cyan)%d%C(reset) %s || %C(blue)%an%C(reset) on %C(green)%ad%C(reset)%C(red)(%ar)%C(reset)" --graph --date=short --decorate -n${__COUNT}
	else
		git log --pretty=format:"%C(auto)%h ||%C(auto)%d %s || %C(blue)%an%C(reset) on %C(green)%ad%C(reset)%C(red)(%ar)%C(reset)" --graph --date=short --decorate -n${__COUNT}
	fi
}

# -- git commands
alias b='git branch -vv'
alias l='__log 10'
alias l2='__log'
alias st='git status .'
alias d='git diff'
alias a='git add .'
alias ma='git checkout master'
alias dev='git checkout develop'
alias v='__version'
alias c='git checkout'
alias p='git pull'
alias ref='git reflog'
alias t='git tag -l -n1'
alias ft='git fetch'
alias show='git show --name-only'

# -- git completion
if [ -f /etc/bash_completion.d/git-flow-completion.bash ]; then
	source /etc/bash_completion.d/git-flow-completion.bash
fi

# -- git prompt
# -- Downloaded URL: https://github.com/magicmonty/bash-git-prompt.git
if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then
	GIT_PROMPT_ONLY_IN_REPO=1
	# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
	GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
	GIT_PROMPT_SHOW_UNTRACKED_FILES=all # can be no, normal or all; determines counting of untracked files
	# GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files
	# GIT_PROMPT_THEME=Custom # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
	# GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
	GIT_PROMPT_THEME=TruncatedPwd_WindowTitle # use theme optimized for solarized color scheme
	source ~/.bash-git-prompt/gitprompt.sh
fi

# -- lxc
alias llc='sudo lxc-console -n'
alias lls='sudo lxc-ls -f'


# -- projects
alias hub='cd /home/rp/code/github'

screenfetch

#####################################################################
