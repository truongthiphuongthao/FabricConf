# ------------------- THAO AUTOMATA SCRIPT --------------------------
# |----- Release date: 29-3-2019 ------------------------------------
# |------------------------------------------------------------------
# |------------------------------------------------------------------
# Usage:
# ./automate.sh path/to/folder/containing/chaincode/ chaincode_name chaincode_version

path=$1
name=$2
version=$3 

export FABRIC_CFG_PATH=$PWD/../config/
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

# use javascript
peer lifecycle chaincode package $name.tar.gz --path $path --lang node --label ${name}_${version}
. scripts/envVar.sh
setGlobals 1
peer lifecycle chaincode install $name.tar.gz
setGlobals 2
peer lifecycle chaincode install $name.tar.gz

queryInstalled() {
  ORG=$1
  setGlobals $ORG
  set -x
  peer lifecycle chaincode queryinstalled >&log.txt
  res=$?
  set +x
  cat log.txt
	export PACKAGE_ID=$(sed -n "/${name}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
  verifyResult $res "Query installed on peer0.org${ORG} has failed"
  echo PackageID is ${PACKAGE_ID}
  echo "===================== Query installed successful on peer0.org${ORG} on channel ===================== "
  echo
}

queryInstalled 1
./approve.sh $name $PACKAGE_ID $version

setGlobals 1
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls true --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n $name --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --isInit -c '{"function":"initLedger","Args":[]}'
