# gpg-key-gen

generate ggp key file .

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
# ./index.sh -h
# {{{helpmsg}}}
```

- [x] get version (ps:`./index.sh -v`)
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
./index.sh key add -n="zero" -e="zero@gmail.com" --nc="ymc-github" -p="password"
./index.sh var lst -fname="hello"

./index.sh key cnf -p=""
./index.sh key lst -p=""
./index.sh uid lst -p=""
./index.sh key del -p=""
./index.sh key add -p=""

```


## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>||

## License
MIT
