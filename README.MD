## ERROR

Error: proposal failed (err: bad proposal response 500: access denied for [JoinChain][verificationchannel]: [Failed verifying that proposal's creator satisfies local MSP principal during channelless check policy with policy [Admins]: [The identity is not an admin under this MSP [Org1MSP]: The identity does not contain OU [ADMIN], MSP: [Org1MSP]]])


## RESULT
add this environment 
-e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" 