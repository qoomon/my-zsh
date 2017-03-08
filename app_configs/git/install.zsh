#!/bin/zsh
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

# see $HOME/.gitconfig

# git global config
git config --global color.ui true
git config --global merge.ff false
git config --global pull.rebase 'preserve'
git config --global rebase.autoStash true
git config --global push.followTags true
git config --global tag.sort version:refname
git config --global core.editor "$EDITOR"
# git config --global commit.template ~/git_commit_template.txt
if [ "$(uname)" = "Darwin" ]; then
  git config --global credential.helper osxkeychain
fi


# list all alias
git config --global alias.alias "\!git config --get-regexp alias | sort | sed -E -e 's|^alias\.||' | grep -v -e '^alias' | sort | sed -E -e 's|^([^ ]*)( .*)|${fg_bold[blue]}\1###${fg[white]}\2$reset_color|' | column -s '###' -t"

# amend last commit
git config --global alias.commend 'commit --amend --no-edit'

git config --global alias.uncommit 'reset HEAD^'

git config --global alias.punch 'push --force-with-lease'

# open ignore file with $EDITOR
git config --global alias.ignore $'!sh -c "if [ -n \'$1\' ]; then echo \'$1\' >> .gitignore; else $EDITOR .gitignore; fi; if [ -e .gitignore ]; then git add .gitignore; fi;"'

# ignore changes of tracked file(s)
git config --global alias.ignore-change = 'update-index --assume-unchanged'

# colorized log
git config --global alias.graph $'!git log --color=always --graph --all --date=format:\'%a %Y-%m-%d %H:%M\' --pretty=tformat:\' %C(blue bold)%h%C(reset) %C(white bold)%s%C(reset) %C(dim white)%an%C(reset)%n ↪  %C(dim green)%ar%C(reset) %C(dim cyan)%ad%C(reset)%C(auto)%d%C(reset)\' -m'

# get commit hash for HEAD by default or Branch or Tag
git config --global alias.hash $'!sh -c "git rev-parse ${1:-HEAD}"'

# git init with empty root commit
git config --global alias.bootstrap '!git init && git commit -m "root" --allow-empty'

# short status
git config --global alias.situation 'status --short --branch'

git config --global alias.skip-worktree 'update-index --skip-worktree'


git config --global merge.tool 'vimdiff'
git config --global diff.tool 'vimdiff'
git config --global merge.conflictstyle 'diff3'
git config --global mergetool.prompt false

# if type idea >/dev/null; then
#   git config --global mergetool.idea.cmd 'idea merge $(cd $(dirname "$LOCAL") && pwd)/$(basename "$LOCAL") $(cd $(dirname "$REMOTE") && pwd)/$(basename "$REMOTE") $(cd $(dirname "$BASE") && pwd)/$(basename "$BASE") $(cd $(dirname "$MERGED") && pwd)/$(basename "$MERGED")'
#   git config --global mergetool.idea.trustExitCode true
#   git config --global merge.tool idea
#
#   git config --global difftool.idea.cmd 'idea diff $(cd $(dirname "$LOCAL") && pwd)/$(basename "$LOCAL") $(cd $(dirname "$REMOTE") && pwd)/$(basename "$REMOTE")'
#   git config --global diff.tool idea
# fi


## seach for changes
# git log --follow -G'<SEARCH_STRING>' --patch [ -- <FILE_PATH> ]
## show file in spesific version
# git show <COMMIT>:<FILE_PATH>

#################
### sourcetree
#################

## Diff Command      Arguments
# /usr/local/bin/idea diff $LOCAL $PWD/$REMOTE
## Merge Tool        Arguments
# /usr/local/bin/idea merge $LOCAL $PWD/$REMOTE $PWD/$BASE $MERGED
