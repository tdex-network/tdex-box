# tdex-box
Docker Compose for running TDex Daemon in production environments

 
## Configure

1. Clone this repository and enter in the folder

```sh
$ git clone https://github.com/TDex-network/tdex-box
$ cd tdex-box
```

2. Edit [feederd/config.json](https://github.com/TDex-network/tdex-feeder#config-file) file if you wish. By default it defines a market with LBTC-USDt and uses Kraken as price feed.


3. Export ENV variable for Esplora REST endpoint

```sh
# if left blank will default https://blockstream.info/liquid/api 
$ export EXPLORER=zzz
```

4. **OPTIONAL** TLS or Onion

#### TLS

Uncomment in the compose file (`docker-compose.yml`) the TLS related stuff and export ENV with the asbolute path to the SSL Certificate and Key to be used.

```sh
$ export SSL_CERT_PATH=/path/to/fullchain.pem
$ export SSL_KEY_PATH=/path/to/privatekey.pem
```

#### Onion

Add this compose service at the bottom of the compose file (either `docker-compose.yml`)

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

Export your Onion service V3 private key or leave it blank to create a new one

```sh
$ export ONION_KEY=base64_Onion_V3_Private_Key
```

## Run 

```sh
$ docker-compose up -d
```

Check the Logs

```
$ docker logs tdexd --tail 20
$ docker logs feederd --tail 20
```


**Onion-only** Check the onion endpoint

```sh
$ docker exec tor onions
```

## **New** Auto-unlock

#### Unlocker

Starting from tdexd v0.5.0 and above, the image comes with a new `unlockerd` embedded binary useful to automatize the unlocking of the daemon's wallet once (re)started and initialized.

The unlocker supports different ways to source the password from a certain _provider_ (file, AWS KMS, Kubernetes, Hashicorp Vault).  
At the moment, the only available option is providing a file containing the plaintext password to unlock the daemon's wallet.

Create the password file (you can name whatever you want), like for example:

```sh
$ echo "mypassword" > path/to/pwd.txt
```

Them, uncomment in the compose file the [volume](docker-compose.yml#L35) related to the Unlocker service and export ENV with the path to the newly created file:

```sh
$ export PWD_PATH=path/to/pwd.txt
```

After starting up the daemon, you can execute the unlocker binary:

```sh
$ alias unlockerd="docker exec -it tdexd unlockerd"

$ unlockerd --password_path /pwd.txt --rpcserver 0.0.0.0:9000
```



