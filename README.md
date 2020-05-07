generic
=======

tl;dr
-----
my dotfiles :)

why should i install?
---------------------
i use a lot of custom alias-es and custom prompts in my daily life. like all dotfiles, i add my customization into the dotfiles (.bashrc, .vimrc, init.el, etc) & this is repo is used by me to setup my linux system. if you like my customizations feel free to use it

installation
------------
```
$> git clone https://github.com/meetrp/generic.git
$> cd generic
$> sh install.sh
```

post installation
-----------------
- a new directory (.dotfiles) is created inside the $HOME directory
- all the customization related files are copied into .dotfiles
- .bashrc & .vimrc is appended to import these files

history
-------
this started as a temporary storage for all my unclassified work including code. much like /tmp in linux systems.

slowly this evolved into my main store for all my configuration pieces like my bashrcs, vimrcs, etc...
though the remnant files from the original purpose of this repo is still around, i have moved my usage away and to where it is today. eventually i will/might remove the stale code.

structure
---------
the primary files of interest would be the following:

| file | purpose |
| --- | --- |
| [install.sh](install.sh) | Installation to avoid manual steps |
| [bashrc](bashrc) | A directory that contains all the bash configuration with useful prompts and aliases |
| [git-commit-template.txt](git-commit-template.txt) | template to make git commits useful |
| [my.vimrc](my.vimrc) |  vim configuration with useful statusline, colors & smart-tab |
| [my.emacs](my.emacs) | emacs configuration (similar to vimrc) |


remnant of past
---------------
| file | purpose |
| --- | --- |
| [eclipse/c_formatter_KnR.xml](eclipse/c_formatter_KnR.xml) | eclipse c/c++ formatter |
| [nat.sh](nat.sh) | convert regular laptop/desktop/vm linux into router |
