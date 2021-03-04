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

#### With Elements


```sh
$ export ELEMENTS_RPC_USER=xxx
$ export ELEMENTS_RPC_PASS=yyy
```

#### With Esplora

```sh
# if left blank will default https://blockstream.info/liquid/api 
$ export EXPLORER=zzz
```

4. **OPTIONAL** TLS or Onion

#### TLS

Uncomment the in the `docker-compose.yml` file the TLS related stuff and export ENV with the asbolute path to the SSL Certificate and Key to be used.

```sh
$ export SSL_CERT_PATH=/path/to/fullchain.pem
$ export SSL_KEY_PATH=/path/to/privatekey.pem
```

#### Onion

Add this compose service at the bottom of the compose (either `docker-compose-elements.yml` or `docker-compose-esplora.yml`)

```yml
  # Tor Onion Hidden service
  tor:
    container_name: "tor"
    image: goldy/tor-hidden-service:latest
    restart: unless-stopped
    depends_on:
      - tdexd
    environment:
      # Set version 3 on TDEX
      TDEX_TOR_SERVICE_HOSTS: "80:tdexd:9945"
      TDEX_TOR_SERVICE_VERSION: "3"
      TDEX_TOR_SERVICE_KEY: ${ONION_KEY}
    # Keep keys in volumes
    volumes:
      - ./tor:/var/lib/tor/hidden_service/
```



```sh
# if not given a new one will be created 
$ export ONION_KEY=base64_Onion_V3_Private_Key
```

### Run 


#### With Elements

Run the elements node alone first and wait for intitial block download to complete, It can up to a whole day to finish

```sh
$ docker-compose -f docker-compose-elements.yml up -d elementsd
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


#### With Esplora 

```sh
$ docker-compose -f docker-compose-esplora.yml up -d
```

Check the Logs

```
$ docker logs tdexd --tail 20
$ docker logs feederd --tail 20
```


