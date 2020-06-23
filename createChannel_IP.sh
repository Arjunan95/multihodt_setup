export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt

# export CHANNEL_NAME=verificationchannel
export VERIFICATION_CHANNEL="verificationchannel"
export CERTIFICATE_CHANNEL="certificatechannel"

setGlobalsForOrderer(){
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp
    
}

setGlobalsForPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
}

setGlobalsForPeer0Org3(){
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=peer0.Org3.example.com:8051
}

setGlobalsForPeer0Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
    
}

setGlobalsForPeer1Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=peer1.org2.example.com:10051
    
}

createVerificationChannel(){
    # rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Org1
    ./bin/peer channel create -o orderer.example.com:7050 -c $VERIFICATION_CHANNEL \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./channel-artifacts/${VERIFICATION_CHANNEL}.tx --outputBlock ./channel-artifacts/${VERIFICATION_CHANNEL}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

createCertificateChannel(){
    setGlobalsForPeer0Org3
    ./bin/peer channel create -o orderer.example.com:7050 -c $CERTIFICATE_CHANNEL \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./channel-artifacts/${CERTIFICATE_CHANNEL}.tx --outputBlock ./channel-artifacts/${CERTIFICATE_CHANNEL}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}



joinChannel(){
    echo "===================== peer0.Org1 joinChannel $VERIFICATION_CHANNEL ====================="
    setGlobalsForPeer0Org1
    ./bin/peer channel join -b ./channel-artifacts/$VERIFICATION_CHANNEL.block

    echo "===================== peer0.Org2 joinChannel  $VERIFICATION_CHANNEL ====================="
    setGlobalsForPeer0Org2
    ./bin/peer channel join -b ./channel-artifacts/$VERIFICATION_CHANNEL.block
    
    echo "===================== peer1.Org2 joinChannel $VERIFICATION_CHANNEL ====================="
    setGlobalsForPeer1Org2
    ./bin/peer channel join -b ./channel-artifacts/$VERIFICATION_CHANNEL.block

    echo "===================== peer0.Org2 joinChannel  $CERTIFICATE_CHANNEL ====================="
    setGlobalsForPeer0Org2
    ./bin/peer channel join -b ./channel-artifacts/$CERTIFICATE_CHANNEL.block
    
    echo "===================== peer1.Org2 joinChannel $CERTIFICATE_CHANNEL ====================="
    setGlobalsForPeer1Org2
    ./bin/peer channel join -b ./channel-artifacts/$CERTIFICATE_CHANNEL.block

    echo "===================== peer0.Org3 joinChannel $CERTIFICATE_CHANNEL ====================="
    setGlobalsForPeer0Org3
    ./bin/peer channel join -b ./channel-artifacts/$CERTIFICATE_CHANNEL.block   
}

updateAnchorPeers(){
    echo "===================== peer0.Org1 updateAnchorPeers $VERIFICATION_CHANNEL ====================="
    setGlobalsForPeer0Org1
    ./bin/peer channel update -o peer0.org1.example.com:7050 --ordererTLSHostnameOverride orderer.example.com \
    -c $VERIFICATION_CHANNEL -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA
    
    echo "===================== peer0.Org2 updateAnchorPeers $VERIFICATION_CHANNEL====================="
    setGlobalsForPeer0Org2
    ./bin/peer channel update -o peer0.org2.example.com:7050 --ordererTLSHostnameOverride orderer.example.com \
    -c $VERIFICATION_CHANNEL -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA
    
    echo "===================== peer0.Org3 updateAnchorPeers $CERTIFICATE_CHANNEL====================="
    setGlobalsForPeer0Org3
    ./bin/peer channel update -o peer0.org3.example.com:7050 --ordererTLSHostnameOverride orderer.example.com \
    -c $CERTIFICATE_CHANNEL -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA
    
}

createVerificationChannel
createCertificateChannel
joinChannel
updateAnchorPeers