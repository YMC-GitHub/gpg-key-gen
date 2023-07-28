%echo Generating a basic OpenPGP key
Key-Type: {GPG_KEY_TYPE}
Key-Length: {GPG_KEY_LENGTH}
Subkey-Type: {GPG_KEY_TYPE}
Subkey-Length: {GPG_KEY_LENGTH}
Name-Real: {GPG_USER_NAME}
Name-Email: {GPG_USER_EMAIL}
Expire-Date: {GPG_KEY_EXP}
Passphrase: {GPG_PASSPHRASE}
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done