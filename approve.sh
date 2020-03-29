# Do not use this script alone

. scripts/envVar.sh
CC_PACKAGE_NAME=$1
CC_PACKAGE_ID=$2
CC_PACKAGE_VERSION=$3

setGlobals 1 # use org 1

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name $CC_PACKAGE_NAME --version ${CC_PACKAGE_VERSION}.0 --init-required --package-id $CC_PACKAGE_ID --sequence ${CC_PACKAGE_VERSION} --tls true --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

setGlobals 2 # use org 2

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name $CC_PACKAGE_NAME --version ${CC_PACKAGE_VERSION}.0 --init-required --package-id $CC_PACKAGE_ID --sequence ${CC_PACKAGE_VERSION} --tls true --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Then query and test if contract is onchained and approved
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name $CC_PACKAGE_NAME --version ${CC_PACKAGE_VERSION}.0 --init-required --sequence ${CC_PACKAGE_VERSION} --tls true --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json

peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name $CC_PACKAGE_NAME --version ${CC_PACKAGE_VERSION}.0 --sequence ${CC_PACKAGE_VERSION} --init-required --tls true --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

peer lifecycle chaincode querycommitted --channelID mychannel --name $CC_PACKAGE_NAME --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
