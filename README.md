# test-archive-branches

Hi, welcome ! This is a small repo to test an archiving script for merged git branches :3

The idea behind this is to help us clean out a lot of repositories having many branches, but we still want to be able to get branches back if needed so an archiving system would help.

## How to run it ?

### Archive branches

```bash
/bin/bash archive_branches.sh
```

### Restore a branch

```bash
git checkout -b branch-name archive/branch-name
```
