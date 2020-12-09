#!/bin/bash

# FIX-ME

TEST_STATE='qrl --json --port_pub 19010 --host 127.0.0.1 state'
NODE_STATE='qrl --json --port_pub 19009 --host 127.0.0.1 state'

echo -e "testnet: \n`$TEST_STATE`" && echo -e "mainnet: \n`$NODE_STATE`"