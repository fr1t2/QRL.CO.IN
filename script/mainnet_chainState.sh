#!/bin/bash

# Script grabs the current state files, tar's them up, hashes the tar file and
# uploads to a digital ocean spaces bucket for serving to the public

# FIX-ME

# This script requires 
# - a fully synced node
# - s3cmd setup for the digital ocean spaces
# 
## Change these settings for your setup!
epochNow=`date +%s`
uploadDir=/media/fr1t2/5BFFAC385E084F02/crypto/qrl/chainState/upload/
stateDir=/media/fr1t2/5BFFAC385E084F02/crypto/qrl/chainState/mainnet-statesync/
fileName="QRL_Mainnet_State.tar.gz"
checkSumFileName="Mainnet_State_Checksums.txt"
statsFileName="QRL_Node_Stats.json"
user="fr1t2"
spaces='qrl-chain'
bucketName="mainnet"

mkdir $stateDir -p 

chainState=$(sudo -H -u $user /home/$user/.local/bin/qrl --json state)
chainSize=$(du -hs /media/fr1t2/5BFFAC385E084F02/crypto/qrl/.qrl/data/state | awk '{print $1}')

# stop the network prior to tar
screenSession=$(sudo -u fr1t2 screen -ls |grep mainnet |cut -f1 -d\.)
sudo -u fr1t2 screen -XS $screenSession quit
echo "Stopping node... ${screenSession}"
echo "Sleeping for 5 sec"
sleep 5
echo "Awake, rsync things around"


# copy the files over
rsync -a /media/fr1t2/5BFFAC385E084F02/crypto/qrl/.qrl/data/state $stateDir

# restart the node
sudo -u fr1t2 screen -Sdm qrl-mainnet-node /home/fr1t2/.local/bin/start_qrl -d /media/fr1t2/5BFFAC385E084F02/crypto/qrl/.qrl/
echo "Sleeping for 30sec"
sleep 30
echo "Awake, tar it up"


# zip them up a little
#tar -czvf $uploadDir/$fileName --directory=$stateDir $stateDir/*

cd $stateDir
tar -czvf $uploadDir/$fileName state

tarFileSize=$(du -hs $uploadDir/$fileName | awk '{print $1}')
sha3512=`openssl dgst -sha3-512 ${uploadDir}/${fileName} | awk '{print $2}'`
sha3256=`openssl dgst -sha3-256 ${uploadDir}/${fileName} | awk '{print $2}'`
sha256sum=`sha256sum ${uploadDir}/${fileName} | awk '{print $1}'`
md5sum=`md5sum  ${uploadDir}/${fileName} | awk '{print $1}'`

# get the sha and md5 sums into a file
echo "******************************" > ${uploadDir}/${checkSumFileName}
echo -e "\t QRL State Checksums" >> ${uploadDir}/${checkSumFileName}
echo "******************************"  >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName}
echo "Verification for file: ${fileName}" >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName}

echo "-------- SHA3-512 Sum --------" >> ${uploadDir}/${checkSumFileName}
echo $sha3512 >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName} 
echo "Verify from linux cli with:" >> ${uploadDir}/${checkSumFileName}
echo "openssl dgst -sha3-512 ${fileName}" >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName}

echo "-------- SHA3-256 Sum --------" >> ${uploadDir}/${checkSumFileName}
echo $sha3256 >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName} 
echo "Verify from linux cli with:" >> ${uploadDir}/${checkSumFileName}
echo "openssl dgst -sha3-256 ${fileName}" >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName}

echo "-------- SHA-256 Sum --------" >> ${uploadDir}/${checkSumFileName}
echo $sha256sum >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName} 
echo "Verify from linux cli with:" >> ${uploadDir}/${checkSumFileName}
echo "sha256sum ${fileName}" >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName}

echo "-------- MD5 Sum --------" >> ${uploadDir}/${checkSumFileName}
echo $md5sum >> ${uploadDir}/${checkSumFileName}
echo "" >> ${uploadDir}/${checkSumFileName}
echo "Verify from linux cli with:" >> ${uploadDir}/${checkSumFileName}
echo "md5sum ${fileName}" >> ${uploadDir}/${checkSumFileName}


# Write the STATS File for consumption by the server for data
timestampJson="{ \"Unix_Timestamp\": \"$epochNow\" }"
chainSizeJson="{ \"Uncompressed_Chain_Size\": \"$chainSize\" }"
tarFileSizeJson="{ \"Tar_FileSize\": \"$tarFileSize\" }"

echo "[" > ${uploadDir}/${statsFileName}
echo $chainState "," >> ${uploadDir}/${statsFileName}

echo $timestampJson "," >> ${uploadDir}/${statsFileName}
echo $chainSizeJson "," >> ${uploadDir}/${statsFileName}
echo $tarFileSizeJson >> ${uploadDir}/${statsFileName}
echo "]" >> ${uploadDir}/${statsFileName}
echo "" > ${uploadDir}/index.html


# add upload to digitalocean spaces here
# upload the tar file
s3cmd put ${uploadDir}/${fileName} s3://${spaces}/${bucketName}/  -P
## upload the stats data
s3cmd put ${uploadDir}/${statsFileName} s3://${spaces}/${bucketName}/ -P
# Upload the checksum file
s3cmd put ${uploadDir}/${checkSumFileName} s3://${spaces}/${bucketName}/ -P
