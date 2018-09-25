#####################################################################
# My Changes

# -- variables
__OS=""

# -- common functions
function __find_os_type() {
	case "$OSTYPE" in
		darwin*) __OS="MAC" ;;
		linux*) __OS="LINUX" ;;
	esac
}

function __prompt() {
	local __MACHINE_TYPE=""
	local __DATE_TIME=""
	local __HOST_NAME=""
	local __LOGIN=""
	local __PATH=""
	local __PROMPT=""
	local __USER=""

	__USER=$(echo $SUDO_USER)
	if [ -z $__USER ]; then
		__USER="$(logname 2> /dev/null)"
		if [ -z $__USER ]; then
			__USER="\u"
		fi
	fi

	local __SYS_TYPE=$(systemd-detect-virt 2> /dev/null)
	if [ ! -z $__SYS_TYPE ]; then

		if [ $__SYS_TYPE != "none" ]; then

			local __BLINK="\e[5m"
			local __BOLD="\e[1m"
			local __TYPE="$__SYS_TYPE"

			case $__SYS_TYPE in
				"oracle" )
					__TYPE="VirtualBox"
					;;
				"vmware" )
					__TYPE="VMware"
					;;
				"qemu" )
					__TYPE="~ QEMU ~"
					;;
				"kvm" )
					__TYPE="~ KVM ~"
					;;
				"xen" )
					__TYPE="~ XEN ~"
					;;
				"docker" )
					__TYPE="DOCKER"
					;;
				"lxc" )
					__TYPE="~ LXC ~"
					;;
			esac

			__MACHINE_TYPE="$__BOLD\[\033[047m\]\[\033[030m\] $__TYPE \e[0m "
		else
				__MACHINE_TYPE=""
		fi
	fi

	if [ $(id -u) -eq 0 ]; then
		# root
		__LOGIN=" \[\033[32m\]\[\e[30;43m\]$__USER\[\e[m\]@\H"
		__PATH="\[\033[33m\]\$PWD"
		__PROMPT="\[\033[31m\]ROOT# \[\033[00m\]"
	else
		__LOGIN=" \[\033[32m\]$__USER@\H"
		__PATH="\[\033[33m\]\w"
		__PROMPT="\[\033[00m\]$> "
	fi

	__DATE_TIME="\[\033[36m\][ \d \t ]"
	echo "$__MACHINE_TYPE$__DATE_TIME$__LOGIN:$__PATH\n$__PROMPT"
}

# -- git and related
function __git_version() {
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

function __git_log() {
	local __COUNT=$1
	local __GIT_MIN_VERSION=1.8.3
	local __GIT_VERSION=$(git --version | awk '{print $3}')

	local __AWK=""
	case "$__OS" in
		"MAC") __AWK="gawk" ;;
		"LINUX") __AWK="awk" ;;
	esac

	if [ $(${__AWK} 'BEGIN{ print "'$__GIT_VERSION'"<"'$__GIT_MIN_VERSION'" }') -eq 1 ]; then
		git log --pretty=format:"%C(yellow)%h%C(reset) ||%C(cyan)%d%C(reset) %s || %C(blue)%an%C(reset) on %C(green)%ad%C(reset)%C(red)(%ar)%C(reset)" --graph --date=short --decorate -n${__COUNT}
	else
		git log --pretty=format:"%C(auto)%h ||%C(auto)%d %s || %C(blue)%an%C(reset) on %C(green)%ad%C(reset)%C(red)(%ar)%C(reset)" --graph --date=short --decorate -n${__COUNT}
	fi
}

# -- set functions
function __set_prompt() {
	PS1=$(__prompt)
}

function __set_generic_aliases() {
	if [ -f ~/.bashrc ]; then
		alias s='source ~/.bashrc'
	fi

	alias ..='cd ..'
	alias grep='grep --color'                     # show differences in colour
	alias g='grep -rIin'
	alias f='find . -iname'

	alias pg='ping -c 5 www.google.com'
}

function __set_generic_options() {
	set completion-ignore-case On

	export EDITOR='vi'

	export GIT_EDITOR='vi'
	export HISTCONTROL=ignoredups
}

function __set_ls_aliases() {
	case "$__OS" in
		"MAC") alias ls='ls -hF -G' ;;
		"LINUX") alias ls='ls -hF --color=tty' ;;
	esac
	alias ll='ls -l'                              # long list
	alias la='ls -A'                              # all but . and ..
	alias lt='ll -tr'                             # long list in reverse order
}

function __set_editor_aliases() {
	$(gvim -h > /dev/null 2> /dev/null) 
	if [ $? -eq 0 ]; then
		alias vim='gvim'
	fi

	$(vim -h > /dev/null 2> /dev/null) 
	if [ $? -eq 0 ]; then
		alias vi='vim'
	fi

	$(emacs --version > /dev/null 2> /dev/null) 
	if [ $? -eq 0 ]; then
		alias e='emacs'
	fi
}

# -- Code and related
function __set_clang_aliases() {
	ctags --version > /dev/null 2> /dev/null
	if [ $? -ne 0 ]; then
		return
	fi

	cscope --version > /dev/null 2> /dev/null
	if [ $? -ne 0 ]; then
		return
	fi

	case "$__OS" in
		"MAC")
			alias ctags="`brew --prefix`/bin/ctags"
			alias ct='find . | grep -e "\.c$" -e "\.h$" -e "\.sh$" | grep -v 'test' > ./cscope.files; cscope -b; ctags -L cscope.files'
			alias cs='find . | grep -e "\.c$" -e "\.h$" -e "\.sh$" | grep -v 'test' > ./cscope.files; cscope -b; ctags -L cscope.files; cscope'
			;;
		"LINUX")
			alias ct='find | grep "\.c$\|\.h$\|.sh$" | grep -v 'test' > ./cscope.files; cscope -b; ctags -L cscope.files'
			alias cs='find | grep "\.c$\|\.h$\|.sh$" | grep -v 'test' > ./cscope.files; cscope -b; ctags -L cscope.files; cscope'
			;;
	esac
	export CSCOPE_EDITOR="vim"

	alias mc='make clean'
	alias mcm='make clean; make'
}

function __set_git_aliases() {
	alias b='git branch -vv'
	alias l='__git_log 10'
	alias l2='__git_log'
	alias st='git status .'
	alias d='git diff'
	alias a='git add .'
	alias ma='git checkout master'
	alias dev='git checkout develop'
	alias v='__git_version'
	alias c='git checkout'
	alias p='git pull'
	alias ref='git reflog'
	alias t='git tag -l -n1'
	alias ft='git fetch'
	alias show='git show --name-status'
}

function __set_git_flow_completion() {
	# -- git completion
	if [ -f /etc/bash_completion.d/git-flow-completion.bash ]; then
		source /etc/bash_completion.d/git-flow-completion.bash
	fi
}

function __set_git_prompt() {
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
}

function __set_container_aliases() {
	case "$__OS" in
		"LINUX")
			alias llc='sudo lxc-console -n'
			alias lls='sudo lxc-ls -f'
			;;
	esac
}

# -- projects
function __set_project_aliases() {
	alias hub='cd /home/rp/code/github'
}

##################### -- final section
__find_os_type

# generic prefs
__set_prompt
__set_generic_aliases
__set_generic_options
__set_ls_aliases


# language prefs
__set_editor_aliases
__set_clang_aliases

# source control prefs
__set_git_aliases
__set_git_flow_completion
__set_git_prompt

# advanced prefs
__set_container_aliases
__set_project_aliases

# All the last ;-)
screenfetch

#####################################################################
