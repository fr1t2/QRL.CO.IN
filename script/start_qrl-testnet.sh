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
screen -Sdm testnet-qrl start_qrl --network-type testnet
#screen -Sdm qrl start_qrl
