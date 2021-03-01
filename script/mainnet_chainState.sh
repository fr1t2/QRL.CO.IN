#!/bin/bash

# Script grabs the curent state files, tar's them up, hashes the tar file and notarises 
# it on the QRL blockchain through a message_tx.

# FIX-ME

# This script requires 
# - a fully synced node
# - a QRL wallet with funds enough for the TX fee
# - 
# 

epochNow=`date +%s`
uploadDir=/var/www/html/qrl.co.in/assets/state
stateDir=/var/www/html/qrl/mainnet_state
fileName="QRL_Mainnet_State.tar.gz"
checkSumFileName="Mainnet_State_Checksums.txt"
statsFileName="QRL_Node_Stats.json"
user="fr1t2"

accessKey_pub=""
accessKey_sec=""
host_bucket=""

mkdir $stateDir -p 

# copy the files over
rsync -a /home/$user/.qrl/data/state $stateDir

# zip them up a little
#tar -czvf $uploadDir/$fileName --directory=$stateDir $stateDir/*
cd $stateDir
tar -czvf $uploadDir/$fileName state

chainState=$(sudo -H -u $user /home/$user/.local/bin/qrl --json state)
chainSize=$(du -hs /home/$user/.qrl/data/state/ | awk '{print $1}')
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
s3cmd put ${uploadDir}/${fileName} s3://${fileName} --host-bucket $host_bucket --access_key $accessKey_pub --secret_key $accessKey_sec -P
# upload the stats data
s3cmd put ${uploadDir}/${statsFileName} s3://${statsFileName} --host-bucket $host_bucket --access_key $accessKey_pub --secret_key $accessKey_sec -P
# Upload the checksum file
s3cmd put ${uploadDir}/${checkSumFileName} s3://${checkSumFileName} --host-bucket $host_bucket --access_key $accessKey_pub --secret_key $accessKey_sec -P


# make sure you own the folder or are a part of the www-data group
sudo chown www-data:www-data $uploadDir -R
