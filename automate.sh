
path=$1
name=$2
export FABRIC_CFG_PATH=$PWD/../config/
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
# use javascript

peer lifecycle chaincode package $name.tar.gz --path $path --lang node --label fabcar_1

. scripts/envVar.sh

setGlobals 1
peer lifecycle chaincode install fabcar.tar.gz

setGlobals 2
peer lifecycle chaincode install fabcar.tar.gz
