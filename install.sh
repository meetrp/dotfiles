##
# Install script
#
#
# @author       Rp <rp@meetrp.com>
# @category     Shell script
# @package      bashrc
# @date         6/May/2020
# @license      <<Check LICENSE file for details>>
##

# Default file paths
HOME_BASHRC="${HOME}/.bashrc"
HOME_VIMRC="${HOME}/.vimrc"
HOME_BASHPROFILE="${HOME}/.bash_profile"

# My paths
BASHRC_DIR="bashrc"
REPO_BASHRC_DIR="${PWD}/${BASHRC_DIR}"
HOME_DOTFILES_DIR="${HOME}/.dotfiles"
MY_BASHRC="${HOME_DOTFILES_DIR}/${BASHRC_DIR}/my.bashrc"
MY_VIMRC="${HOME_DOTFILES_DIR}/my.vimrc"

# cleanup dotfiles
echo "Cleaning up dotfiles: ${HOME_DOTFILES_DIR}"
rm -rf ${HOME_DOTFILES_DIR}/${BASHRC_DIR}
rm -rf ${HOME_DOTFILES_DIR}/my.vimrc
rm -rf ${HOME_DOTFILES_DIR}/my.emacs
rm -rf ${HOME_DOTFILES_DIR}/git-commit-template.txt

# install dotfiles
echo "Installing dotfiles: ${HOME_DOTFILES_DIR}"
mkdir -p ${HOME_DOTFILES_DIR}
cp -R ${REPO_BASHRC_DIR} ${HOME_DOTFILES_DIR}/
cp -R ${PWD}/my.vimrc ${HOME_DOTFILES_DIR}/
cp -R ${PWD}/my.emacs ${HOME_DOTFILES_DIR}/
cp -R ${PWD}/git-commit-template.txt ${HOME_DOTFILES_DIR}/

# install bashrc
echo "Updating .bashrc"
[[ -f ${HOME_BASHRC} ]] && grep -q "HOME_DOTFILES_DIR" ${HOME_BASHRC} || echo 'export HOME_DOTFILES_DIR="${HOME}/.dotfiles/bashrc/"' >> ${HOME_BASHRC}
[[ -f ${HOME_BASHRC} ]] && grep -q ${MY_BASHRC} ${HOME_BASHRC} || echo ". ${MY_BASHRC}" >> ${HOME_BASHRC}

# if MAC then additionally install bashprofile
if [[ ${OSTYPE} = darwin* ]]; then
    echo "Updaing .bash_profile"
    [[ -f ${HOME_BASHPROFILE} ]] && grep -q ${HOME_BASHRC} ${HOME_BASHPROFILE} || echo ". ${HOME_BASHRC}" >> ${HOME_BASHPROFILE}
fi

# install vimrc
echo "Updating .vimrc"
[ -f ${HOME_VIMRC} ] && grep -q ${MY_VIMRC} ${HOME_VIMRC} || echo "source ${MY_VIMRC}" >> ${HOME_VIMRC}
