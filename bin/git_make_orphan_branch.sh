#!/bin/bash

function git_make_orphan_branch() {
  if [ $# -lt 2 ] ;then
    echo 'usage: git_make_orphan_branch <commit> <new-orphan-branch>'
    exit 1
  else
    hash=$1
    branch=$2

    # 1. Create a dummy commit to replace the old ones
    git checkout --orphan git_make_orphan_branch_temp
    git commit --allow-empty -m "Remove previous history"

    # 2. Replace the old commit with the dummy commit
    git replace ${hash} git_make_orphan_branch_temp

    # 3. Filter the branch to rewrite the history
    git filter-branch -- --all

    # 4. Remove the replace ref and the temporary branch
    git replace -d ${hash}

    # 5. Remove unreferenced files and perform garbage collection
    git reflog expire --expire=now --all
    git gc --prune=now --aggressive

    # 6. Remove temporary branch
    git checkout ${branch}
    git branch -D git_make_orphan_branch_temp

    # 7. (Optional) Force push the changes to remote
    # git push origin --force --all
    # git push origin --force --tags
  fi
}


git_make_orphan_branch $@
