SELF_DIR="${0:A:h}"
cd "$SELF_DIR"

# see $HOME/.gitconfig

# git global config
git config --global color.ui true
git config --global merge.ff false
git config --global pull.rebase true
git config --global rebase.autoStash true
git config --global push.followTags true
git config --global tag.sort version:refname
git config --global core.editor "$EDITOR"
# git config --global commit.template ~/git_commit_template.txt
if [ "$(uname)" == "Darwin" ]; then
  git config --global credential.helper osxkeychain
fi

# list all alias
git config --global alias.alias "\!git config --get-regexp alias | sort | sed -E -e 's|^alias\.||' | grep -v -e '^alias' | sort | sed -E -e 's|^([^ ]*)( .*)|${fg_bold[blue]}\1###${fg[white]}\2$reset_color|' | column -s '###' -t"

# open ignore file with $EDITOR
git config --global alias.ignore $'!sh -c "if [ -n \'$1\' ]; then echo \'$1\' >> .gitignore; else $EDITOR .gitignore; fi; if [ -e .gitignore ]; then git add .gitignore; fi;"'

# colorized log
git config --global alias.logx $'!git log --color=always --graph --all --date=format:\'%a %Y-%m-%d %H:%M\' --pretty=tformat:\' %C(blue bold)%h%C(reset) %C(white bold)%s%C(reset) %C(dim white)%an%C(reset)%n ↪  %C(dim green)%ar%C(reset) %C(dim cyan)%ad%C(reset)%C(auto)%d%C(reset)\' -m'

# get commit hash for HEAD by default or Branch or Tag
git config --global alias.hash '!git rev-parse ${1:-HEAD}'

# ignore changes of tracked file(s)
git config --global alias.assume-unchanged 'update-index --assume-unchanged'
git config --global alias.skip-worktree 'update-index --skip-worktree'


if type idea >/dev/null; then
  git config --global mergetool.intellij.cmd 'idea merge $(cd $(dirname "$LOCAL") && pwd)/$(basename "$LOCAL") $(cd $(dirname "$REMOTE") && pwd)/$(basename "$REMOTE") $(cd $(dirname "$BASE") && pwd)/$(basename "$BASE") $(cd $(dirname "$MERGED") && pwd)/$(basename "$MERGED")'
  git config --global mergetool.intellij.trustExitCode false
  git config --global merge.tool intellij

  git config --global difftool.intellij.cmd 'idea diff $(cd $(dirname "$LOCAL") && pwd)/$(basename "$LOCAL") $(cd $(dirname "$REMOTE") && pwd)/$(basename "$REMOTE")'
  git config --global difftool.intellij.trustExitCode false
  git config --global diff.tool intellij
fi


## seach for changes
# git log --follow -G'<SEARCH_STRING>' --patch [ -- <FILE_PATH> ]
## show file in spesific version
# git show <COMMIT>:<FILE_PATH>

# npm install --global commitizen
# npm install --global cz-conventional-changelog
# echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
# npm install --global conventional-changelog-cli
# npm install --global conventional-recommended-bump

#################
### sourcetree
#################

## Diff Command      Arguments
# /usr/local/bin/idea diff $LOCAL $PWD/$REMOTE
## Merge Tool        Arguments
# /usr/local/bin/idea merge $LOCAL $PWD/$REMOTE $PWD/$BASE $MERGED
