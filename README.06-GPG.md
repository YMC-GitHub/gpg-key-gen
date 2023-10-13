## add gpg key

## upload gpg key to github repo


## tell git about your signing key

- [x] unset this configuration so the default format of openpgp will be used
```bash
git config --global --unset gpg.format
```


- [x]  list the long form of the GPG keys for which you have both a public and private key:
```bash
gpg --list-secret-keys --keyid-format=long | grep sec | cut -d "/" -f 2 | sed -E "s/ +.*//g"
```

- [x] To set your primary GPG signing key in Git
```bash
# git config --global user.signingkey ****************
```


- [x] Telling Git about your SSH key
```bash
# git config --global gpg.format ssh
# git config --global user.signingkey /PATH/TO/.SSH/KEY.PUB
```

[telling-git-about-your-signing-key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)


## signing commits
- [x] To configure your Git client to sign commits by default for a local repository

```bash
git config commit.gpgsign true
git config --global commit.gpgsign true
```

- [x] add the -S flag to the git commit command, when committing changes in your local branch:

```bash
git commit -S -m "YOUR_COMMIT_MESSAGE"
```


[signing-commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)



## signing tags
- [x] sign a tag, add -s to your git tag command.
```bash
# sign a tag
# git tag -s MYTAG

# Verify your signed tag
# git tag -v [tag-name]

```

[signing-tags](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-tags)