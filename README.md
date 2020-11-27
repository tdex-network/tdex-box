# tdex-box
Docker Compose for running TDex Daemon with TLS along with the TDex Feeder. 

## Usage

1. Clone this repository and enter in the folder

```
$ git clone https://github.com/TDex-network/tdex-box
$ cd tdex-box
```

2. Edit [config.json](https://github.com/TDex-network/tdex-feeder#config-file) file.

3. Export ENV variable for the path of the config to be used.

```
$ export CONFIG_PATH=`pwd`/config.json
```

4. Export ENV for the path of the SSL Certificate and Key to be used.

```
$ export SSL_CERT_PATH=/path/to/cert.pem
$ export SSL_KEY_PATH=/path/to/key.pem
```

5. Export the ENV variable for the TDex Daemon datadir

```
$ export TDEX_PATH=`pwd`/tdexd
```

### Run

```
$ docker-compose up -d
```

### Check the Logs

```
$ docker logs tdexd
$ docker logs feederd
```
