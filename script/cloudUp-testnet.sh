#!/bin/bash

# 
## CloudUp.sh
#
# Script uploads all files to the cloud at Digital Ocean.

## Requires
# - State files bootstrapped using the tools from https://github.com/0xFF0/QRL_bootstrap
# - s3cmd setup for the digital ocean spaces upload
# jq installed
user="fr1t2"
DO_SPACE='qrl-chain' # Digital Ocean Space
DO_BUCKET="testnet" # Digital Ocean Bucket name

BACKUP_PATH=/home/$user/qrl_bootstrap
NET_NAME=Testnet

BOOTSTRAP_FILE=$BACKUP_PATH/$NET_NAME/QRL_"$NET_NAME"_State.tar.gz
STATS_FILE=$BACKUP_PATH/$NET_NAME/QRL_"$NET_NAME"_Node_Stats.json
CHECKSUM_FILE=$BACKUP_PATH/$NET_NAME/"$NET_NAME"_State_Checksums.txt

VERSION="v1.0"
BOOTSTRAP_LOGS=$BACKUP_PATH/qrl_bootstrap.logs

echo "----------------------------------------------" | tee -a $BOOTSTRAP_LOGS 
echo "Upload QRL $NET_NAME bootstrap to Cloud" | tee -a $BOOTSTRAP_LOGS  
echo "----------------------------------------------" | tee -a $BOOTSTRAP_LOGS  


CHAIN_STATE=$(sudo -H -u $user /home/$user/.local/bin/qrl --port_pub 19019 --json state)

echo "["`date -u`"] QRL $NET_NAME Chain State:" |tee -a $BOOTSTRAP_LOGS

HEIGHT=$(echo $CHAIN_STATE |jq .info.blockHeight)
LAST_HASH=$(echo $CHAIN_STATE |jq .info.blockLastHash)
NETWWORK_ID=$(echo $CHAIN_STATE |jq .info.networkId)
NUM_CONNECT=$(echo $CHAIN_STATE |jq .info.numConnections)
NUM_PEERS=$(echo $CHAIN_STATE |jq .info.numKnownPeers)
STATE=$(echo $CHAIN_STATE |jq .info.state)
UP=$(echo $CHAIN_STATE |jq .info.uptime)
VER=$(echo $CHAIN_STATE |jq .info.version)

cat << EoF > $STATS_FILE
[
    {"info":
        { 
            "blockHeight": $HEIGHT, 
            "blockLastHash": $LAST_HASH,
            "networkId": $NETWWORK_ID,
            "numConnections": $NUM_CONNECT, 
            "numKnownPeers": $NUM_PEERS, 
            "state": $STATE, 
            "uptime": $UP, 
            "version": $VER 
        } 
    },
    { "Unix_Timestamp": "$(date +%s)" },
    { "Uncompressed_Chain_Size": "$(du -hs $BACKUP_PATH/$NET_NAME/state | awk '{print $1}')" },
    { "Tar_FileSize": "$(stat -c%s "$BOOTSTRAP_FILE" | numfmt --to iec)" }
]
EoF



# add upload to Digital Ocean spaces here
# upload the tar file
echo "["`date -u`"] Upload Bootstrap TAR file:" |tee -a $BOOTSTRAP_LOGS
s3cmd put $BOOTSTRAP_FILE s3://${DO_SPACE}/${DO_BUCKET}/  -P
## upload the stats data
echo "["`date -u`"] Upload Stats JSON file:" |tee -a $BOOTSTRAP_LOGS
s3cmd put $STATS_FILE s3://${DO_SPACE}/${DO_BUCKET}/ -P
# Upload the checksum file
echo "["`date -u`"] Upload Bootstrap Checksums file:" |tee -a $BOOTSTRAP_LOGS
s3cmd put $CHECKSUM_FILE s3://${DO_SPACE}/${DO_BUCKET}/ -P
echo "["`date -u`"] Upload Complete:" |tee -a $BOOTSTRAP_LOGS
