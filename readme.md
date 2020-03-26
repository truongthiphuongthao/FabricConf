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
4. Package and deploy the chaincode
```
./automate <path/to/folder/containing/chaincode> <chaincode/package>
```
if we would like to install ./fabcar, which is written in javascript for example, we should:
```
./automate.sh ./fabcar fabcar
```

After running the script, we should see something be like:
```
Chaincode code package identifier: fabcar_1:6855a6a6462c259b63356fe39258ebc6b929fc2c5f762e105d3e6a5dae3aebec
```
You may want to copy the id ```fabcar_1:6855a6a6462c259b63356fe39258ebc6b929fc2c5f762e105d3e6a5dae3aebec``` (not this id, actual id after your deploy instead)

6. Approve chaincode on every org, then autocommit:
```
./approve.sh <id>
```
For example:	

```
./approve.sh fabcar_1:6855a6a6462c259b63356fe39258ebc6b929fc2c5f762e105d3e6a5dae3aebec
```

8. Query chaincode, finish, now we should move to 'application', where examples about chaincode 'minging' is going to be elaborated:

With node as chaincode example (either go, typescript, python are accepted), we could try something like

```
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls true --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n fabcar --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --isInit -c '{"function":"initLedger","Args":[]}'
```
Then 
```
peer chaincode query -C mychannel -n fabcar -c '{"Args":["queryAllCars"]}'
```
