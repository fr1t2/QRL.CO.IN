# QRL.CO.IN Instructions and development Notes


- The site is hosted out of Github sites. 
- DNS points to cloudflare which points to github sites with 
- QRL.CO.IN is the directory with the goods

## Chain Data

The chain data is served from a link out of digital ocean https://cloud.digitalocean.com/spaces/qrl-chain and hosted on https://qrl.co.in/chain for the public to download.


This data is uploaded form a server running the QRL node software. The node is stopped, state files `rsync` over to a backup directory where they are `tar`'d up, the hash sums are taken and node stats recorded, then all files are sent up to the cloud CDN for content serving to the community.



## Web Configuration 

This is a Jekyll site, running in Github pages. Update this Repo to update the site.

> Development setup is simple, follow Jekyll instructions to bundle your way into a running live site.


## Chain State Files

Point links for mainnet and testnet chain files to these links for serving. 

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

The chain state and related information is created through a number of scripts.

#### Mainnet Scripts

| Script | Link | Use |
| --- | --- | --- |
| CreateQRLBootstrap.sh | [script/QRL_bootstrap/CreateQRLBootstrap.sh](script/QRL_bootstrap/CreateQRLBootstrap.sh) | Creates a backup of the chain state files (blockchain) |
| notarize-mainnet.sh | [script/notarize-mainnet.sh](script/notarize-mainnet.sh) | Notarizes the checksums file |
| cloudUp-mainnet.sh | [script/cloudUp-mainnet.sh](script/cloudUp-mainnet.sh) | Uploads all of the files to the cloud location to serve |
| mainnet-chain.sh | []() | Combination script pulling all functions together into one. |

#### Testnet Scripts

| Script | Link | Use |
| --- | --- | --- |
| CreateQRLBootstrap_testnet.sh | [script/QRL_bootstrap/CreateQRLBootstrap_testnet.sh](script/QRL_bootstrap/CreateQRLBootstrap_testnet.sh) | Creates a backup of the chain state files (blockchain) |
| notarize-testnet.sh | [script/notarize-testnet.sh](script/notarize-testnet.sh) | Notarizes the checksums file |
| cloudUp-testnet.sh | [script/cloudUp-testnet.sh](script/cloudUp-testnet.sh) | Uploads all of the files to the cloud location to serve |
| testnet-chain.sh | []() | Combination script pulling all functions together into one. |

Setup the s3cmd following this guide:

https://docs.digitalocean.com/products/spaces/resources/s3cmd/

After successful configuration test, you can upload files using this guide https://docs.digitalocean.com/products/spaces/resources/s3cmd-usage/

```bash
s3cmd put file.txt s3://spacename/path/
```

Will use the endpoint, and credentials setup during the configuration.

### bootstrap

cd into the bootstrap submodule at `script/QRL_bootstrap` and run the following

```bash
git submodule init
git submodule update 
```

#### Mainnet 

```bash
./script/QRL_bootstrap/CreateQRLBootstrap.sh
```
#### Testnet 

```bash
./script/QRL_bootstrap/CreateQRLBootstrap-testnet.sh
```

### Notarize

Notarize the checksums on the chain

If node is installed through nvn, use the following to symlink the executable into your path where expected.

```bash
sudo ln -s "$(which node)" /usr/bin/node
sudo ln -s "$(which npm)" /usr/bin/npm
```

#### Mainnet 

```bash
./script/notarize-mainnet.sh
```

#### Testnet 

```bash
./script/notarize-testnet.sh
```


### Upload Script

Using the s3cmd upload the files to the cloud

#### Mainnet 

```bash
./script/cloudUp-mainnet.sh
```

#### Testnet

```bash
./script/cloudUp-testnet.sh
```



#### Crontab Entries

Using the combined script, compress, notarize and upload all of the files at once



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

