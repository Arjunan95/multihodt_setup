export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# export CHANNEL_NAME=verificationchannel
export VERIFICATION_CHANNEL="verificationchannel"
export CERTIFICATE_CHANNEL="certificatechannel"


createVerificationChannel(){
    # rm -rf ./channel-artifacts/*
    # setGlobalsForPeer0Org1
    peer channel create -o orderer.example.com:7050 -c $VERIFICATION_CHANNEL \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./channel-artifacts/${VERIFICATION_CHANNEL}.tx --outputBlock ./channel-artifacts/${VERIFICATION_CHANNEL}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

createCertificateChannel(){
    # setGlobalsForPeer0Org3
    peer channel create -o orderer.example.com:7050 -c $CERTIFICATE_CHANNEL \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./channel-artifacts/${CERTIFICATE_CHANNEL}.tx --outputBlock ./channel-artifacts/${CERTIFICATE_CHANNEL}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}



joinVerificationChannel(){
    echo "===================== joinChannel $VERIFICATION_CHANNEL ====================="
    peer channel join -b ./channel-artifacts/$VERIFICATION_CHANNEL.block
}

joinCertificateChannel(){
    echo "===================== joinChannel  $CERTIFICATE_CHANNEL ====================="
    peer channel join -b ./channel-artifacts/$CERTIFICATE_CHANNEL.block
}

updateAnchorPeers(){
    echo "===================== peer0.Org1 updateAnchorPeers $VERIFICATION_CHANNEL ====================="
    setGlobalsForPeer0Org1
    peer channel update -o peer0.org1.example.com:7050 --ordererTLSHostnameOverride orderer.example.com \
    -c $VERIFICATION_CHANNEL -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA
    
    echo "===================== peer0.Org2 updateAnchorPeers $VERIFICATION_CHANNEL====================="
    setGlobalsForPeer0Org2
    peer channel update -o peer0.org2.example.com:7050 --ordererTLSHostnameOverride orderer.example.com \
    -c $VERIFICATION_CHANNEL -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA
    
    echo "===================== peer0.Org3 updateAnchorPeers $CERTIFICATE_CHANNEL====================="
    setGlobalsForPeer0Org3
    peer channel update -o peer0.org3.example.com:7050 --ordererTLSHostnameOverride orderer.example.com \
    -c $CERTIFICATE_CHANNEL -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA
    
}

# if["$1"=="join"]
createVerificationChannel
# createCertificateChannel
# joinChannel
# updateAnchorPeers