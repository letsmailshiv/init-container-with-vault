#/bin/bash

# vars 
#
vaultToken=${TOKEN}
vaultUrl=${VAULTURL}
vaultkey="secret/${ENVNAME}/certs"
certDirs="/caa/.certs"

if [ -z ${TOKEN} ] || [ -z ${VAULTURL} ] || [ -z ${ENVNAME} ]; then
    echo "ERROR: TOKEN variable not set"
    echo "ERROR: OR "
    echo "ERROR: VAULTURL variable not set"
    echo "ERROR: OR "
    echo "ERROR: ENVNAME variable not set"
    exit 1
else
    vaultToken=${TOKEN}
    vaultUrl=${VAULTURL}
    vaultkey="secret/${ENVNAME}/certs"
    certDirs="/caa/.certs"
fi

# Login to Vault
#
vault login -address=${vaultUrl} ${vaultToken} 2> /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Vault not accessible"
    exit 1
fi
# Download certs
#
for i in `vault kv list -address=${vaultUrl} ${vaultkey}|grep -v Keys|grep -v "\-\-\-"`
do
    vaultkey="secret/nonprod/certs/${i}"
    mkdir -p ${certDirs}/${vaultkey}
    for k in `vault kv list -address=${vaultUrl} ${vaultkey}|grep -v Keys|grep -v "\-\-\-"`
    do
        vault kv get --field=value -address=${vaultUrl} ${vaultkey}/${k} > ${certDirs}/${vaultkey}/${k}
    done
done 
