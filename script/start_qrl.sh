#!/bin/bash
#
## Start QRL node and all related functions in screen sessions to run the tipbot
## Need to start the node first, then run qrl_walletd, then the proxy
#
## Run this script from crontab on @reboot
#
#
source "/home/$USER/.profile"

# uncomment hte next line for testnet,
#screen -Sdm qrl start_qrl --network-type testnet
screen -Sdm qrl start_qrl
# let the node get started and connect before we start the proxy
sleep 5
# start the qrl_walletd and proxy services
cd "/home/$USER/go/src/github.com/theQRL/walletd-rest-proxy/"
qrl_walletd
screen -Sdm walletd ./walletd-rest-proxy -serverIPPort 127.0.0.1:5359 -walletServiceEndpoint 127.0.0.1:19010
