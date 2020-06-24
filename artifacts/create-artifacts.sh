
chmod -R 0755 ./crypto-config
# Delete existing artifacts
rm -rf ./crypto-config
rm -rf ../crypto-config
# rm genesis.block verificationchannel.tx  certificatechannel.tx
rm -rf ../channel-artifacts/*

echo "####    Generate Crypto artifactes for organizations    ####"
../bin/cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/

# System channel
SYS_CHANNEL="sys-channel"

VERIFICATION_CHANNEL="verificationchannel"
CERTIFICATE_CHANNEL="certificatechannel"

echo $VERIFICATION_CHANNEL
echo $CERTIFICATE_CHANNEL
echo $SYS_CHANNEL

echo "#######   Generate System Genesis block   #########"
../bin/configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  \
-outputBlock ../channel-artifacts/genesis.block


echo "####### Generate VerificationChannel configuration block #######"
../bin/configtxgen -profile VerificationChannel -configPath . \
-outputCreateChannelTx ../channel-artifacts/verificationchannel.tx -channelID $VERIFICATION_CHANNEL

echo "####### Generate CertificateChannel configuration block #######"
../bin/configtxgen -profile CertificateChannel -configPath . \
-outputCreateChannelTx ../channel-artifacts/certificatechannel.tx -channelID $CERTIFICATE_CHANNEL

echo "#######    Generating anchor peer update for Org1MSP  ##########"
../bin/configtxgen -profile VerificationChannel -configPath . \
-outputAnchorPeersUpdate ../channel-artifacts/Org1MSPanchors.tx -channelID $VERIFICATION_CHANNEL -asOrg Org1MSP

echo "#######    Generating anchor peer update for Org2MSP  ##########"
../bin/configtxgen -profile VerificationChannel -configPath . \
-outputAnchorPeersUpdate ../channel-artifacts/Org2MSPanchors.tx -channelID $VERIFICATION_CHANNEL -asOrg Org2MSP

echo "#######    Generating anchor peer update for Org3MSP  ##########"
../bin/configtxgen -profile CertificateChannel -configPath . \
-outputAnchorPeersUpdate ../channel-artifacts/Org3MSPanchors.tx -channelID $CERTIFICATE_CHANNEL -asOrg Org3MSP



# Delete existing artifacts
cp -r ./crypto-config ../crypto-config
chmod -R 0755 ./crypto-config
rm -rf ./crypto-config