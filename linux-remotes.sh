#! /bin/sh


# TODO: check if a remote with that url exists, skip
# TODO: check if a remote with that name exists, ask to update url if different

git remote add torvalds https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
git remote add me       https://github.com/jmesmon/linux.git
git remote add stable   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
