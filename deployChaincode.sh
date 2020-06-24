export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json

# export CHANNEL_NAME=verificationchannel

export VERIFICATION_CHANNEL="verificationchannel"
export CERTIFICATE_CHANNEL="certificatechannel"

# CHANNEL_NAME="verificationchannel"
CC_RUNTIME_LANGUAGE="node"
VERSION="1"
CC_SRC_PATH="/etc/hyperledger/channel/chanincode/javascript/"
CC_NAME="fabcar"



packageChaincode() {
    echo "===================== packageChaincode on peer0.org1 ===================== "
    # rm -rf ${CC_NAME}.tar.gz
    # setGlobalsForPeer0Org1
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
     peer0.org1.example.com  peer lifecycle chaincode package fabcar.tar.gz \
        --path "/etc/hyperledger/channel/chanincode/javascript/" --lang node \
        --label fabcar_1
}
# packageChaincode

installCadvChaincode() {
    echo "===================== installCadvChaincode peer0.org1 ===================== "
     docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    peer0.org1.example.com peer lifecycle chaincode install fabcar.tar.gz
}

# installCadvChaincode

installTnegaChaincode(){
 echo "===================== installChaincode peer0.org2 ===================== "
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer0.org2.example.com peer lifecycle chaincode install fabcar.tar.gz
    
    echo "===================== installChaincode peer1.org2 ===================== "
     docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer1.org2.example.com peer lifecycle chaincode install fabcar.tar.gz
}

installSedChaincode(){
 echo "===================== installChaincode peer0.org3 ===================== " 
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
     peer0.org3.example.com peer lifecycle chaincode install fabcar.tar.gz
}


# installChaincode


queryInstalled() {
    echo "===================== Query install on peer0.org1 on channel ===================== "

    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    peer0.org1.example.com peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/fabcar_1/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "


    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer0.org2.example.com peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/fabcar_1/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}


    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
    peer0.org3.example.com peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/fabcar_1/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    
}

# fabcar_1:f14a2d6cec8c12eb85fb99d2937366ccc552fae2ec0e92b62050c3855b710d78
# fabcar_1:f14a2d6cec8c12eb85fb99d2937366ccc552fae2ec0e92b62050c3855b710d78
# f14a2d6cec8c12eb85fb99d2937366ccc552fae2ec0e92b62050c3855b710d78




queryInstalled
# /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
approveForMyOrg1() {
     echo "===================== chaincode approved from org 1 $VERIFICATION_CHANNEL ===================== "

     docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    peer0.org1.example.com peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID verificationchannel --name fabcar --version 1 \
    --init-required --package-id ${PACKAGE_ID} \
    --sequence 1 --tls \
    --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem 
   
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer0.org2.example.com peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID certificatechannel --name fabcar --version 1 \
    --init-required --package-id fabcar_1:f14a2d6cec8c12eb85fb99d2937366ccc552fae2ec0e92b62050c3855b710d78 \
    --sequence 1 --tls \
    --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem 
   

   
    # setGlobalsForPeer0Org1
    # set -x
    # ./bin/peer lifecycle chaincode approveformyorg -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com --tls \
    #     --cafile $ORDERER_CA --channelID $VERIFICATION_CHANNEL --name ${CC_NAME} --version ${VERSION} \
    #     --init-required --package-id ${PACKAGE_ID} \
    #     --sequence ${VERSION}
    # set +x
}
approveForMyOrg1

approveForMyOrg2() {
    echo "===================== chaincode approve from org 2 $VERIFICATION_CHANNEL===================== "
    setGlobalsForPeer0Org2
    ./bin/peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $VERIFICATION_CHANNEL --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

     echo "===================== chaincode approve from org 2 $CERTIFICATE_CHANNEL===================== "
    setGlobalsForPeer0Org2
    ./bin/peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CERTIFICATE_CHANNEL --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${CERTIFICATE_PACKAGE_ID} \
        --sequence ${VERSION}
}

# approveForMyOrg2

approveForMyOrg3() {
    # echo "===================== chaincode approve from org 3 ===================== "
    # setGlobalsForPeer0Org3
    # ./bin/peer lifecycle chaincode approveformyorg -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA --channelID $CERTIFICATE_CHANNEL --name ${CC_NAME} \
    #     --version ${VERSION} --init-required --package-id ${CERTIFICATE_PACKAGE_ID} \
    #     --sequence ${VERSION}

    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
    peer0.org3.example.com peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID certificatechannel --name fabcar --version 1 \
    --init-required --package-id fabcar_1:f14a2d6cec8c12eb85fb99d2937366ccc552fae2ec0e92b62050c3855b710d78 \
    --sequence 1 --tls \
    --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \

}

# approveForMyOrg3
checkCommitReadyness() {
     echo "===================== checking commit readyness from org 1 $VERIFICATION_CHANNEL===================== "
    setGlobalsForPeer0Org1

     docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    peer0.org1.example.com peer lifecycle chaincode checkcommitreadiness \
        --channelID=verificationchannel --name=fabcar --version=1 \
        --sequence=1 --output json --init-required
   
    echo "===================== checking commit readyness from org 3 $CERTIFICATE_CHANNEL ===================== "
    setGlobalsForPeer0Org3
    ./bin/peer lifecycle chaincode checkcommitreadiness \
        --channelID $CERTIFICATE_CHANNEL --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    
}
# checkCommitReadyness


checkCommitReadyness() {

    setGlobalsForPeer0Org1
    ./bin/peer lifecycle chaincode checkcommitreadiness --channelID $VERIFICATION_CHANNEL \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "

    setGlobalsForPeer0Org3
    ./bin/peer lifecycle chaincode checkcommitreadiness --channelID $CERTIFICATE_CHANNEL \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 3 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0Org1
     docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    peer0.org3.example.com peer lifecycle chaincode commit -o orderer.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $VERIFICATION_CHANNEL --name ${CC_NAME} \
        --peerAddresses peer1.org2.example.com:7051\
        --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses peer0.org2.example.com:9051 \
        --tlsRootCertFiles $PEER0_ORG2_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required

    setGlobalsForPeer0Org3
    ./bin/peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CERTIFICATE_CHANNEL --name ${CC_NAME} \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required

}

# commitChaincodeDefination

queryCommitted() {

    echo "######### queryCommitted Peer0Org1 $VERIFICATION_CHANNEL ########"
    setGlobalsForPeer0Org1
    ./bin/peer lifecycle chaincode querycommitted --channelID $VERIFICATION_CHANNEL --name ${CC_NAME}

    echo "######### queryCommitted Peer0Org3 $CERTIFICATE_CHANNEL ########"
     setGlobalsForPeer0Org3
    ./bin/peer lifecycle chaincode querycommitted --channelID $CERTIFICATE_CHANNEL --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    echo "########## Peer0Org0 chaincodeInvokeInit $VERIFICATION_CHANNEL ###########"
    setGlobalsForPeer0Org1
    ./bin/peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $VERIFICATION_CHANNEL -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --isInit -c '{"Args":[]}'

    echo "##########Peer0Org3  chaincodeInvokeInit $CERTIFICATE_CHANNEL ###########"
    setGlobalsForPeer0Org3
    ./bin/peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CERTIFICATE_CHANNEL -n ${CC_NAME} \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --isInit -c '{"Args":[]}'
}

# chaincodeInvokeInit

chaincodeInvoke() {
    echo "########### setGlobalsForPeer0Org1 $VERIFICATION_CHANNEL ########"
    setGlobalsForPeer0Org1
    ## Create Car
    ./bin/peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $VERIFICATION_CHANNEL -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA   \
        -c '{"function": "createCar","Args":["Car-11", "Audi", "R8", "Red", "Pavan"]}'

    echo "########### setGlobalsForPeer0Org3 $CERTIFICATE_CHANNEL ########"
    setGlobalsForPeer0Org3
    ## Create Car
    ./bin/peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CERTIFICATE_CHANNEL -n ${CC_NAME}  \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA   \
        -c '{"function": "createCar","Args":["Car-11", "Audi", "R8", "Red", "Pavan"]}'

}

# chaincodeInvoke

chaincodeQuery() {
    echo "######### chaincodeQuery Peer0Org1 $VERIFICATION_CHANNEL ############"
    setGlobalsForPeer0Org1
    ./bin/peer chaincode query -C $VERIFICATION_CHANNEL -n ${CC_NAME} -c '{"function": "queryCar","Args":["Car-11"]}'

    echo "######### chaincodeQuery Peer0Org3 $CERTIFICATE_CHANNEL ############"
     setGlobalsForPeer0Org3
    ./bin/peer chaincode query -C $CERTIFICATE_CHANNEL -n ${CC_NAME} -c '{"function": "queryCar","Args":["Car-11"]}'
   }

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
# presetup

# packageChaincode
# installChaincode
# queryInstalled
# approveForMyOrg1
# checkCommitReadyness
# approveForMyOrg2
# approveForMyOrg3
# checkCommitReadyness
# commitChaincodeDefination
# queryCommitted
# sleep 5
# chaincodeInvokeInit
# sleep 5
# chaincodeInvoke
# sleep 8
# chaincodeQuery
