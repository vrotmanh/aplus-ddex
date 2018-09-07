# Aplus



# AplusListings
address: 0xae73ddac98cb901defe802904172495396b486ce
url: https://ropsten.etherscan.io/address/0xae73ddac98cb901defe802904172495396b486ce



## Interface
mapping(bytes32 => Listing) public listings

function createListing(bytes32 dataHash, uint price) external returns (bool)

function removeListing(bytes32 dataHash) external returns (bool)

function getListing(bytes32 dataHash) public view returns(uint, address)

function getListedDataHashes() public view returns(bytes32[])





# AplusEscrows
address: 0x1f1298f6b99034fbee1db00ddadd06258bb6b368
url: https://ropsten.etherscan.io/address/0x1f1298f6b99034fbee1db00ddadd06258bb6b368



## Interface
mapping(bytes32 => mapping(address => Escrow)) public escrows

mapping(address => bytes32[]) public acquiredDataHashes

createEscrow(bytes32 dataHash, string publicEncKey) public payable

revokeEscrow(bytes32 dataHash) public

claimMoney(bytes32 dataHash, address viewer) public

getEscrowDataHashesByBuyer(address buyer) public view returns (bytes32[])

getEscrowDataHashesBySeller(address seller) public view returns (bytes32[])

getEscrowForBuyer(bytes32 dataHash, address buyer) public view returns (address, address, bool, bool, bool, bytes32, string)

getBuyersForDataHash(bytes32 dataHash) public view returns (address[])

tokensAlreadyClaimed(bytes32 dataHash, address buyer) public view returns(bool)

claimTokens(bytes32 dataHash, address buyer) public