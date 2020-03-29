# Additional readme file

Simple step to install dependencies, network bringing up and deploy:

At the very first step, we need:
```
cd /path/to/this/FabricConf/
``` 
Ofcourse,
1. Install dependencies and path:

- Install go: 
```
sudo ./install_go.sh
```

- Run init_config, which will set $GOPATH and install nvm, then install node v12.15, script should also install git and fabric-samples 
```
sudo ./init_config.sh
```

The two script will automatically set correct path
2. Bring up network:

```
sudo ./network.sh up
```

Sometime, the `organizations` folder does not have correct permission letting other program such as peer to read it, so we need to set permission, in this case I would do:
```
sudo chmod -R 777 organizations
```
3. Create the channel, which should be `mychannel`(only for testing purposes):

```
sudo ./network.sh createChannel -c mychannel
```
4. Package and deploy the chaincode:

'initLedger' will be automatically called
```
./automate.sh <path/to/folder/containing/chaincode> <chaincode_name> <chaincode_version>
```
example:

```
./automate.sh ../chaincode/fabcar/javascript fabcar 1
```


5. Query chaincode, finish, now we should move to 'application', where examples about chaincode 'minging' is going to be elaborated:

With node as chaincode example (either go, typescript, python are accepted), we could try something like

```
peer chaincode query -C mychannel -n fabcar -c '{"Args":["queryAllCars"]}'
```
