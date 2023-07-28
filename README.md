# gpg-key-gen

generate ggpgog key file .

## features
- [x] gpg key gen
- [x] support custom topic,email and date 

## in plans

- gpg key del,lst through topic,email,date command

## Download


```bash
# speed up git clone in china
GC_PROXY="https://ghproxy.com/"
GC_URL="https://github.com/YMC-GitHub/gpg-key-gen"
GC_URL="${GC_PROXY}${GC_URL}"
git clone -b main "$GC_URL"
```

## Usage
- [x] get help (ps:`./index.sh -h`)

```bash
# ./gpg.keygen.sh -h
# {{{helpmsg}}}
```

- [x] get version (ps:`./gpg.keygen.sh -v`)
- [ ] download but not saving script to file and gen key .

```bash
GC_PROXY="https://ghproxy.com/"
GC_REPO_URL_RAW=https://raw.githubusercontent.com/ymc-github/gpg-key-gen
url=${GC_PROXY}${GC_REPO_URL_RAW}/main/index.sh
echo $url
# curl -sfL $url | sh
```

```bash
# demo:
./index.sh var lst -n="zero" -e="zero@gmail.com" --nc="ymc-github" -p="password"
./index.sh key cnf -n="zero" -e="zero@gmail.com" --nc="ymc-github" -p="password"
./index.sh key gen -n="zero" -e="zero@gmail.com" --nc="ymc-github" -p="password"
./index.sh var lst -fname="hello"
```


## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>||

## License
MIT
