# gpg-key-gen

scripts to generate gpg key

## features
- [x] gpg key gen
- [x] support custom topic,email and date 

## in plans

- gpg key del,lst through topic,email,date command

## Download

find the best way for you:

- [x] get this script from github repo with git clone (recommend)
```bash
# speed up git clone in china
GC_PROXY="https://ghproxy.com/"
GC_URL="https://github.com/YMC-GitHub/gpg-key-gen"
GC_URL="${GC_PROXY}${GC_URL}"
git clone -b main "$GC_URL"
```

- [ ] get this script (only the index.sh file )
```bash
GC_PROXY="https://ghproxy.com/"
GC_REPO_URL_RAW=https://raw.githubusercontent.com/ymc-github/gpg-key-gen
url=${GC_PROXY}${GC_REPO_URL_RAW}/main/index.sh
# echo $url
# curl -sfL $url | sh
curl -sfLO $url 
```

- [ ] download but not saving script to file and gen key .

```bash
GC_PROXY="https://ghproxy.com/"
GC_REPO_URL_RAW=https://raw.githubusercontent.com/ymc-github/gpg-key-gen
url=${GC_PROXY}${GC_REPO_URL_RAW}/main/index.sh
echo $url
# curl -sfL $url | sh
```


## Usage

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

- [x] get this script help (ps:`./index.sh -h`)

- [x] get this script version (ps:`./index.sh -v`)

- [x] get the config to gen gpg key
```bash
./index.sh key cnf -p=""
```

- [x] list key files
```bash
./index.sh key lst -p=""
```

- [x] add key
```bash
./index.sh key add -n="zero" -e="zero@gmail.com" --nc="ymc-github" -p="password"
```

- [x] list uid list with email
```bash
./index.sh uid lst
```


## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>|the code author|

## License
MIT
