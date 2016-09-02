# git global config
git config --global merge.ff false
git config --global pull.rebase true
git config --global push.followTags true
git config --global tag.sort version:refname

if type atom >/dev/null; then
  git config --global core.editor "atom --wait"
fi

if type idea >/dev/null; then
  git config --global mergetool.intellij.cmd 'idea merge $(cd $(dirname "$LOCAL") && pwd)/$(basename "$LOCAL") $(cd $(dirname "$REMOTE") && pwd)/$(basename "$REMOTE") $(cd $(dirname "$BASE") && pwd)/$(basename "$BASE") $(cd $(dirname "$MERGED") && pwd)/$(basename "$MERGED")'
  git config --global mergetool.intellij.trustExitCode false
  git config --global merge.tool intellij

  git config --global difftool.intellij.cmd 'idea diff $(cd $(dirname "$LOCAL") && pwd)/$(basename "$LOCAL") $(cd $(dirname "$REMOTE") && pwd)/$(basename "$REMOTE")'
  git config --global difftool.intellij.trustExitCode false
  git config --global diff.tool intellij
fi

# find template in files folder
# git config --global commit.template ~/git_commit_template.txt


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

