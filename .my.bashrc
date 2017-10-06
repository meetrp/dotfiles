#####################################################################
# My Changes

# -- Common
PS1="\[\033[36m\][ \d \t ] \[\033[32m\]\u@\H:\[\033[33m\]\w\n\[\033[00m\]$> "

alias s='source ~/.bashrc'

alias ..='cd ..'
alias grep='grep --color'                     # show differences in colour
alias g='grep -rIi'
alias f='find . -iname'

alias ls='ls -hF --color=tty'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..

#alias vim='gvim'
alias vi='vim'

# -- Code and related
alias ct='find | grep "\.c$\|\.h$\|.sh$" | grep -v 'test' > ./cscope.files; cscope -b; ctags -L cscope.files'
alias cs='find | grep "\.c$\|\.h$\|.sh$" | grep -v 'test' > ./cscope.files; cscope -b; ctags -L cscope.files; cscope'
export CSCOPE_EDITOR="vim"

alias mc='make clean'
alias mcm='make clean; make'

# -- git and related
alias b='git branch -vv'
#alias l='git log --graph --decorate --oneline -n10'
alias l='git log --pretty=format:"%C(auto)%h ||%C(auto)%d %s || %C(blue)%an%C(reset) on %C(green)%ad%C(reset)%C(red)(%ar)%C(reset)" --graph --date=short --decorate -n10'
alias st='git status .'
alias d='git diff'
alias a='git add .'
alias ma='git checkout master'
alias c='git checkout'
alias p='git pull'
alias ref='git reflog'
alias t='git tag -l -n1'
alias ft='git fetch'
alias r='git review -l'

#
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


# -- projects
alias hub='cd /home/rp/code/github'

screenfetch

#####################################################################