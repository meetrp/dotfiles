#####################################################################
# My Changes

# -- Common
alias s='source ~/.bashrc'

alias ..='cd ..'
alias grep='grep --color'                     # show differences in colour
alias g='grep -rIi'
alias f='find . -iname'

alias ls='ls -hF --color=tty'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..

alias vim='gvim'
alias vi='vim'

# -- Code and related
alias cc='find | grep "\.c$\|\.h$\|.sh$" | grep -v 'test' > ./cscope.files; cscope -b'
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

# -- projects
alias hub='cd /home/rp/code/github'

screenfetch

#####################################################################
