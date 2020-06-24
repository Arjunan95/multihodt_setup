## ERROR

Error: proposal failed (err: bad proposal response 500: access denied for [JoinChain][verificationchannel]: [Failed verifying that proposal's creator satisfies local MSP principal during channelless check policy with policy [Admins]: [The identity is not an admin under this MSP [Org1MSP]: The identity does not contain OU [ADMIN], MSP: [Org1MSP]]])


## RESULT
add this environment 
-e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" 






docker cp peer0.org1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/fabcar.tar.gz .


docker cp fabcar.tar.gz peer0.org2.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer
docker cp fabcar.tar.gz peer1.org2.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer

docker cp fabcar.tar.gz peer0.org3.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer





















15.206.202.68
52.66.219.163

peer channel list

export VERIFICATION_CHANNEL="verificationchannel"
export CERTIFICATE_CHANNEL="certificatechannel"

byfn.sh up -l javascript

ssh -i TNeGA-Blockchain.pem ubuntu@15.206.237.145
ssh -i TNeGA-Blockchain.pem ubuntu@3.7.65.250	
ssh -i TNeGA-Blockchain.pem ubuntu@13.235.67.188

docker rm -f $(docker ps -aq)
docker-compose -f docker-compose-cadv.yaml up -d
docker-compose -f docker-compose-tnega.yaml up -d
docker-compose -f docker-compose-sed.yaml up -d

docker rm -f $(docker ps -aq)
sudo lsof -i -P -n | grep LISTEN


tar cf BasicNetwork-2.0.tar .

docker swarm init --advertise-addr 15.206.202.68

scp -i TNeGA-Blockchain.pem ubuntu@15.206.202.68:/home/ubuntu/BasicNetwork-2.0.tar .

docker rm -f $(docker ps -aq)

docker-compose -f docker-compose-cadv.yaml up -d
docker-compose -f docker-compose-tnega.yaml up -d
docker-compose -f docker-compose-sed.yaml up -d

docker cp peer0.org1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/verificationchannel.block .
docker cp peer0.org3.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/certificatechannel.block .

docker cp verificationchannel.block peer0.org1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer
docker cp certificatechannel.block peer0.org1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer

docker cp verificationchannel.block peer0.org2.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer
docker cp certificatechannel.block peer0.org2.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer

docker cp verificationchannel.block peer1.org2.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer
docker cp certificatechannel.block peer1.org2.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer

docker cp verificationchannel.block peer0.org3.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer
docker cp certificatechannel.block peer0.org3.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer

docker cp peer0.org1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/fabcar.tar.gz .

docker cp fabcar.tar.gz peer0.org2.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer
docker cp fabcar.tar.gz peer1.org2.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer

docker cp fabcar.tar.gz peer0.org3.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer


docker exec -ti peer0.org1.example.com sh
docker exec -ti peer0.org2.example.com sh
cd /etc/hyperledger/channel/


CC_RUNTIME_LANGUAGE="node"
VERSION="1"
CC_SRC_PATH="/etc/hyperledger/channel/chanincode/javascript/"
CC_NAME="fabcar"
export VERIFICATION_CHANNEL="verificationchannel"
export CERTIFICATE_CHANNEL="certificatechannel"



docker rm -f $(docker ps -aq)
docker-compose -f docker-compose-cadv.yaml up -d
docker-compose -f docker-compose-tnega.yaml up -d
docker-compose -f docker-compose-sed.yaml up -d