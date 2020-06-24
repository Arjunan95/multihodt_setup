export ORDERER_CA=/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# export CHANNEL_NAME=verificationchannel
export VERIFICATION_CHANNEL="verificationchannel"
export CERTIFICATE_CHANNEL="certificatechannel"


createVerificationChannel(){
    # peer channel create -o orderer.example.com:7050 -c $VERIFICATION_CHANNEL \
    # --ordererTLSHostnameOverride orderer.example.com \
    # -f ./channel-artifacts/${VERIFICATION_CHANNEL}.tx --outputBlock ./channel-artifacts/${VERIFICATION_CHANNEL}.block \
    # --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c \
    verificationchannel -f /etc/hyperledger/channel/channel-artifacts/verificationchannel.tx \
    --tls --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem 

    docker cp peer0.org1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/verificationchannel.block .


}

createCertificateChannel(){
    # peer channel create -o orderer.example.com:7050 -c $CERTIFICATE_CHANNEL \
    # --ordererTLSHostnameOverride orderer.example.com \
    # -f ./channel-artifacts/${CERTIFICATE_CHANNEL}.tx --outputBlock ./channel-artifacts/${CERTIFICATE_CHANNEL}.block \
    # --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

        docker exec -e \
        "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
        peer0.org3.example.com peer channel create -o orderer.example.com:7050 \
        -c certificatechannel -f /etc/hyperledger/channel/channel-artifacts/certificatechannel.tx \
        --tls --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem 

docker cp peer0.org3.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/certificatechannel.block .
}



joinCadv(){
    echo "===================== joinVerificationChannelCadv $VERIFICATION_CHANNEL ====================="
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    peer0.org1.example.com peer channel join \
    -b /opt/gopath/src/github.com/hyperledger/fabric/peer/verificationchannel.block
}

joinChannelTnega(){
    echo "===================== joinChannelTnega peer0.Org2  $VERIFICATION_CHANNEL ====================="
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer0.org2.example.com peer channel join \
    -b /opt/gopath/src/github.com/hyperledger/fabric/peer/verificationchannel.block

    echo "===================== joinChannelTnega peer1.Org2  $VERIFICATION_CHANNEL ====================="
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer1.org2.example.com peer channel join \
    -b /opt/gopath/src/github.com/hyperledger/fabric/peer/verificationchannel.block

    echo "===================== joinChannelTnega peer0.Org2  $CERTIFICATE_CHANNEL ====================="
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer0.org2.example.com peer channel join \
    -b /opt/gopath/src/github.com/hyperledger/fabric/peer/certificatechannel.block

    echo "===================== joinChannelTnega peer1.Org2  $CERTIFICATE_CHANNEL ====================="
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer1.org2.example.com peer channel join \
    -b /opt/gopath/src/github.com/hyperledger/fabric/peer/certificatechannel.block
}

joinChannelSed(){
    echo "===================== joinChannelTnega peer0.Org3  $CERTIFICATE_CHANNEL ====================="
    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
    peer0.org3.example.com peer channel join \
    -b /opt/gopath/src/github.com/hyperledger/fabric/peer/certificatechannel.block
}

updateAnchorPeers(){
    echo "===================== peer0.Org1 updateAnchorPeers $VERIFICATION_CHANNEL ====================="
    # setGlobalsForPeer0Org1
     docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    peer0.org1.example.com peer channel update -o peer0.org1.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    -c verificationchannel \
    -f /etc/hyperledger/channel/channel-artifacts/Org1MSPanchors.tx \
    --tls true \
    --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    
    echo "===================== peer0.Org2 updateAnchorPeers $VERIFICATION_CHANNEL====================="
    # setGlobalsForPeer0Org2
    # peer channel update -o peer0.org2.example.com:7050 --ordererTLSHostnameOverride orderer.example.com \
    # -c $VERIFICATION_CHANNEL -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED \
    # --cafile $ORDERER_CA
    
     docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    peer0.org2.example.com peer channel update -o orderer.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    -c verificationchannel \
    -f /etc/hyperledger/channel/channel-artifacts/Org2MSPanchors.tx \
    --tls true \
    --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    

    echo "===================== peer0.Org3 updateAnchorPeers $CERTIFICATE_CHANNEL====================="
    # setGlobalsForPeer0Org3
    # peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
    # -c $CERTIFICATE_CHANNEL -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED \
    # --cafile $ORDERER_CA

    docker exec -e \
    "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
    peer0.org3.example.com peer channel update -o orderer.example.com:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    -c certificatechannel \
    -f /etc/hyperledger/channel/channel-artifacts/Org3MSPanchors.tx \
    --tls true \
    --cafile /etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    
    
}

# 
createVerificationChannel
createCertificateChannel
joinChannel
# updateAnchorPeers

# if [[ $1 == "cadv" ]]
# then
#    echo "CADV INIT"
# elif [[ $1 == "tnega" ]]
# then
#    echo "TNEGA INIT"
# elif [[ $1 == "sed" ]]
# then
#    echo "SED INIT"
# else
#    echo "./createchannel cadv"
# fi