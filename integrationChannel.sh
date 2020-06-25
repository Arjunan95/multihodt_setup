
# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
# VERIFICATION_CHANNEL="verificationchannel"
# CERTIFICATE_CHANNEL="certificatechannel"

# echo $VERIFICATION_CHANNEL
# echo $CERTIFICATE_CHANNEL
# echo $SYS_CHANNEL

#step 1:createing the crypto-config folder
echo "==============Generate crypto-config folder==========="
./bin/cryptogen generate --config=./crypto-config.yaml
#./bin/configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


#step:2:Change the path
echo "=======Path changed========="
export FABRIC_CFG_PATH=$PWD

#step 3:Creating a genesis block
echo "=========Generating genesis block"
./bin/configtxgen -profile ThreeOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
#./bin/configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./channel-artifacts/genesis.block

#step:4 Create a verfication channel
echo "====Generating verfication channel tx file"
./bin/configtxgen -profile VerificationChannel -outputCreateChannelTx ./channel-artifacts/VerificationChannel.tx -channelID VerificationChannel

#./bin/configtxgen -profile VerificationChannel -configPath . \
#-outputCreateChannelTx ./verificationchannel.tx -channelID $VERIFICATION_CHANNEL

#step:5:Create a certificate channel
echo "============Generating Cerficate channel tx file"
./bin/configtxgen -profile CertificateChannel -outputCreateChannelTx ./channel-artifacts/CertificateChannel.tx -channelID CertificateChannel

#./bin/configtxgen -profile CertificateChannel -configPath . \
#-outputCreateChannelTx ./certificatechannel.tx -channelID $CERTIFICATE_CHANNEL


#anchor peers
# echo "#######    Generating anchor peer update for Org1MSP  ##########"
# ../../bin/configtxgen -profile VerificationChannel -configPath . \
# -outputAnchorPeersUpdate ./Org1MSPanchors.tx -channelID $VERIFICATION_CHANNEL -asOrg Org1MSP

# echo "#######    Generating anchor peer update for Org2MSP  ##########"
# ../../bin/configtxgen -profile VerificationChannel -configPath . \
# -outputAnchorPeersUpdate ./Org2MSPanchors.tx -channelID $VERIFICATION_CHANNEL -asOrg Org2MSP

# echo "#######    Generating anchor peer update for Org3MSP  ##########"
# ../../bin/configtxgen -profile CertificateChannel -configPath . \
# -outputAnchorPeersUpdate ./Org3MSPanchors.tx -channelID $CERTIFICATE_CHANNEL -asOrg Org3MSP
