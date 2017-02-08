SELF_DIR="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
cd "$SELF_DIR"

# install vim-plug plugin manager
if [ ! -e "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

cp -i .vimrc $HOME/.vimrc

vim +PlugInstall +qall
