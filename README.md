# tdex-box
Docker Compose for running TDex Daemon with TLS along with the TDex Feeder. 

## Usage 


1. Clone this repository and enter in the folder

```sh
$ git clone https://github.com/TDex-network/tdex-box
$ cd tdex-box
```

2. Edit [feederd/config.json](https://github.com/TDex-network/tdex-feeder#config-file) file if you wish. By default it defines a market with LBTC-USDt and uses Kraken as price feed.



3. Export ENV variable for the either Esplora or Elements with rpc user:password

### With Elements


```sh
$ export ELEMENTS_RPC_USER=xxx
$ export ELEMENTS_RPC_PASS=yyy
```

### With Esplora

```sh
# if left blank will default https://blockstream.info/liquid/api 
$ export EXPLORER=zzz
```

4. **OPTIONAL** TLS termination


Uncomment the in the `docker-compose.yml` file the TLS related stuff and export ENV with the asbolute path to the SSL Certificate and Key to be used.

```sh
$ export SSL_CERT_PATH=/path/to/fullchain.pem
$ export SSL_KEY_PATH=/path/to/privatekey.pem
```

5. **OPTIONAL** Onion service

TBD


### Run 


### With Elements

Run the elements node alone first and wait for intitial block download to complete, It can up to a whole day to finish

```sh
$ docker-compose up -d elementsd
```

You can check the progress with the `elements-cli`

```
$ docker exec elementsd elements-cli -rpcuser=xxx -rpcpassword=yyy getblockchaininfo
```

After initial block download is completed

```
$ docker-compose up -d tdexd feederd
```


Check the Logs

```
$ docker logs elementsd --tail 20
$ docker logs tdexd --tail 20
$ docker logs feederd --tail 20
```


### With Esplora

```sh
$ docker-compose -f docker-compose-esplora.yml up -d
```

Check the Logs

```
$ docker logs tdexd --tail 20
$ docker logs feederd --tail 20
```

