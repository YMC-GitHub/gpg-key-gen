- [x] gen ssh public key and private key

```bash
# step: gen ssh public key and private key
# ps:
./ssh.keygen.sh -t "gh,ge,gl" -e "yemiancheng1993@126.com,hualei03042013@163.com,hualei03042013@126.com,ymc.github@gmail.com"
```

- [x] add public key to github
```bash
# step: add public key to github
ls ~/.ssh/ymc.github@gmail.com/20230726
# clip public key to clipboad
clip < ~/.ssh/ymc.github@gmail.com/20230726/gh.pub

# ...
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
```

- [ ] add public key to github with gh cli (to try)
```bash
gh auth login
# then
gh ssh-key add ~/.ssh/ymc.github@gmail.com/20230726/gh.pub --title "20230726"

```

- [x] add private key to ssh-agent
```bash
# step: add private key to ssh-agent
# ps:
eval $(ssh-agent -s)
ssh-add ~/.ssh/ymc.github@gmail.com/20230726/gh

```

- [x] check connecting to github
```bash
# step: check connecting to github
# ps:
ssh -T git@github.com
```


- [x] fix `ssh: connect to host github.com port 22: Connection timed out`
```bash
# fix `ssh: connect to host github.com port 22: Connection timed out` ?
# dbg:
# ssh -Tv git@github.com
# def-txt
txt=$(cat << EOF
Host github.com
  User git
  Hostname ssh.github.com
  # Hostname github.com
  Port 443
  IdentityFile ~/.ssh/ymc.github@gmail.com/20230726/gh
EOF
)

# del-txt-in-file
# ...
# dbg:
# sed "/Host github.com/,/IdentityFile/d" ~/.ssh/config
sed -i "/Host github.com/,/IdentityFile/d" ~/.ssh/config

# add-txt-to-file
echo "$txt" >>  ~/.ssh/config

# check
cat  ~/.ssh/config

ssh -T git@github.com
```