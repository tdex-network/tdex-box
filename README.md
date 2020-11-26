# tdex-box
Docker Compose for running TDex Daemon with TLS along with the TDex Feeder. 

## Usage

1. Clone this repository.

```
$ git clone https://github.com/TDex-network/tdex-box/
```

2. Create [config.json](https://github.com/TDex-network/tdex-feeder#config-file) file.

3. Add the export ENV command for the path to be used.

```
$ export CONFIG_PATH=./config.json
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