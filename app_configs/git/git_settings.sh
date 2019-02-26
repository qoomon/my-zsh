#!/bin/bash
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

# see $HOME/.gitconfig

# git global config
git config --global color.ui 'auto'
git config --global merge.ff false
# ensures to convert CRLF to LF when writing to database
git config --global core.autocrlf input
git config --global pull.rebase 'preserve'
git config --global rebase.autoStash true
git config --global push.followTags true
git config --global tag.sort 'version:refname'
git config --global core.editor '$EDITOR'
git config --global core.pager 'less -R -M'
# git config --global commit.template ~/git_commit_template.txt
if [ "$(uname)" = "Darwin" ]; then
  git config --global credential.helper osxkeychain
fi


# list all alias
git config --global alias.alias $'!git config --get-regexp \'^alias.\' | sed \'s/^alias\.//\' | sort | sed -E -e "s|^([^ ]*)( .*)|$(printf \'\\e[34m\')\\1$(printf \'\\e[39m\')\\2|"'

# amend to last commit
git config --global alias.amend $'commit --amend --no-edit'

# amend spesific commit
git config --global alias.fixup $'!f() { TARGET=$(git rev-parse "$1"); git commit --fixup=$TARGET ${@:2} && EDITOR=true git rebase -i --autostash --autosquash $TARGET^; }; f'

# undo last commmit
git config --global alias.retract $'reset HEAD^'

# reset to upstream state
git config --global alias.rewind $'reset --hard @{upstream}'

# force push with lease
git config --global alias.push-force $'push --force-with-lease'

# open ignore file with $EDITOR
git config --global alias.ignore $'!f() { IGNORE_PATH="$1"; if [ -n "$IGNORE_PATH" ]; then if !(grep -s "^${IGNORE_PATH}$" .gitignore >/dev/null); then echo "$IGNORE_PATH" >> .gitignore; fi; else ${EDITOR:-vi} .gitignore; fi; if [ -e .gitignore ]; then git add .gitignore; fi; }; f'

# ignore changes of tracked file(s)   
git config --global alias.ignore-change $'update-index --skip-worktree'

# colorized log graph
git config --global alias.graph $'log --color=always --graph --date=format:\'%a %Y-%m-%d %H:%M\' \
--pretty=tformat:\' %C(white)%s%C(reset)%C(auto)%d%C(reset)
 %C(dim white)•%C(reset) %C(dim blue)%h%C(reset) %C(dim cyan)%ad%C(reset) %C(dim green)%ar%C(reset) %C(dim white)%an%C(reset)\' -m'

# get commit hash for HEAD by default   or Branch or Tag
git config --global alias.hash $'!f() { REV=${1:-HEAD}; git rev-parse $REV; }; f'

# git init with empty root commit
git config --global alias.bootstrap $'!git init && git commit -m \'root\' --allow-empty'

# short status
git config --global alias.situation $'status --short --branch'

# execute for all git sub folders
git config --global alias.workspace $'!f() { WORKSPACE=$PWD; CMD="$@"; for repo in */; do ( cd $repo 2>/dev/null && git status >/dev/null 2>&1 && printf "\\e[34m${PWD#$WORKSPACE/}:\\e[39m\\n" && eval git $CMD && echo); true; done; }; f'

git config --global merge.tool 'vimdiff'
git config --global diff.tool 'vimdiff'
git config --global merge.conflictstyle 'diff3'
git config --global mergetool.prompt false

# if [ $commands[idea] ] >/dev/null; then
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
