# QRL.CO.IN Instructions and development Notes


- The site is hosted out of Github sites. 
- DNS points to cloudflare which points to github sites with 
- QRL.CO.IN is the directory with the goods

## Chain Data

The chain data is served from a link out of digital ocean https://cloud.digitalocean.com/spaces/qrl-chain and hosted on https://qrl.co.in/chain for the public to download.


This data is uploaded form a server running the QRL node software. The node is stopped, state files `rsync` over to a backup directory where they are `tar`'d up, the hashsums are taken and node stats recorded, then all files are sent up to the cloud CDN for content serving to the community.



## Web Configuration 

Point the web to these files for serving. 

> There are custom COORS settings that allow this to be served from the site without cross origin issues. See the settings in the digital ocean spaces dashboard for more.

### Mainnet

**Mainnet State checksums**
- Origin https://qrl-chain.fra1.digitaloceanspaces.com/mainnet/Mainnet_State_Checksums.txt
- edge https://qrl-chain.fra1.cdn.digitaloceanspaces.com/mainnet/Mainnet_State_Checksums.txt
- subdomain https://cdn.qrl.co.in/mainnet/Mainnet_State_Checksums.txt

**Mainnet State**
- Origin https://qrl-chain.fra1.digitaloceanspaces.com/mainnet/QRL_Mainnet_State.tar.gz
- Edge https://qrl-chain.fra1.cdn.digitaloceanspaces.com/mainnet/QRL_Mainnet_State.tar.gz
- subdomain https://cdn.qrl.co.in/mainnet/QRL_Mainnet_State.tar.gz

**Mainnet Node Stats**
- Origin https://qrl-chain.fra1.digitaloceanspaces.com/mainnet/QRL_Node_Stats.json
- Edge https://qrl-chain.fra1.cdn.digitaloceanspaces.com/mainnet/QRL_Node_Stats.json
- Subdomain https://cdn.qrl.co.in/mainnet/QRL_Node_Stats.json

### Testnet

**Testnet State checksums**
- Origin https://qrl-chain.fra1.digitaloceanspaces.com/testnet/Testnet_State_Checksums.txt
- edge https://qrl-chain.fra1.cdn.digitaloceanspaces.com/testnet/Testnet_State_Checksums.txt
- subdomain https://cdn.qrl.co.in/testnet/Testnet_State_Checksums.txt

**Testnet State**
- Origin https://qrl-chain.fra1.digitaloceanspaces.com/testnet/QRL_Testnet_State.tar.gz
- Edge https://qrl-chain.fra1.cdn.digitaloceanspaces.com/testnet/QRL_Testnet_State.tar.gz
- subdomain https://cdn.qrl.co.in/testnet/QRL_Testnet_State.tar.gz

**Testnet Node Stats**
- Origin https://qrl-chain.fra1.digitaloceanspaces.com/testnet/QRL_Testnet_Node_Stats.json
- Edge https://qrl-chain.fra1.cdn.digitaloceanspaces.com/testnet/QRL_Testnet_Node_Stats.json
- Subdomain https://cdn.qrl.co.in/testnet/QRL_Testnet_Node_Stats.json



## Uploading files

Setup the s3cmd following this guide:

https://docs.digitalocean.com/products/spaces/resources/s3cmd/

After successful configuration test, you can upload files using this guide https://docs.digitalocean.com/products/spaces/resources/s3cmd-usage/

```bash
s3cmd put file.txt s3://spacename/path/
```

Will use the endpoint, and credentials setup during the configuration.


### Upload Script

The scripts here for gathering the blockchain data and uploading can be [found in the script directory](/scripts) and ran from crontab. 

Both mainnet and testnet scripts are provided. 

#### Configure

These require some configuration to work, and need to be tailored to individual installs. 

```bash 
# Directory for final tar files to upload
uploadDir=/home/$USER/chainstate/upload/ 
# Where to send the copied chain files to prior to compressing
stateDir=/home/$USER/chainstate/statesync/ 
# User running the commands
user="fr1t2"
```


#### Run the Scripts

`./script/mainnet_chainstate.sh`

This takes awhile to run and upload mainnet files. Currently running once a week on Sunday. 


#### Crontab Entries

 ```
 #crontab entry to sync the chainstate

 0 0 * * 6  /home/$USER/chainState/script/testnet_chainstate.sh
 0 0 * * 7  /home/$USER/chainState/script/mainnet_chainstate.sh
```

```
# Optional crontab to restart the node on reboot

@reboot /home/$USER/chainState/script/start_qrl.sh
@reboot /home/$USER/chainState/script/start_qrl-testnet.sh
```

