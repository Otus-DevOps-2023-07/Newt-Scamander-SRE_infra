# Newt-Scamander-SRE_infra
Newt-Scamander-SRE Infra repository

## Usefule notes:

1. check ssh connection to github (should return 'exit status 1')

``` sh
ssh -vT git@github.com
```

2. add tag to remote repositor:
```
git tag -a HW_XX_
```

3. If you used mount dir with NTFS FS - you could have trouble with pre-commit
