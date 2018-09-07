pragma solidity 0.4.24;

import "./linnia-contracts/LinniaHub.sol";
import "./linnia-contracts/LinniaRecords.sol";
import "./linnia-contracts/LinniaUsers.sol";
import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./AplusListings.sol";

contract AplusEscrows {
    LinniaHub public linniaHub;
    using SafeMath for uint;

    struct Escrow {
        address buyer;
        address seller;
        bool paid;
        bool fulfilled;
        bool tokensClaimed;
        bytes32 listingID;
        string publicEncKey;
    }

    // dataHash => buyer => escrow
    mapping(bytes32 => mapping(address => Escrow)) public escrows;

    // buyer => array of datahashes
    mapping(address => bytes32[]) public dataHashesByBuyer;

    // seller => array of datahashes
    mapping(address => bytes32[]) public dataHashesBySeller;

    // dataHash => array of buyers
    mapping(bytes32 => address[]) public buyersByDataHash;

    AplusListings aplusListings;

    constructor(AplusListings _aplusListings, LinniaHub _linniaHub) public {
        aplusListings = _aplusListings;
        linniaHub = _linniaHub;
    }

    function doesPermissionExists(bytes32 dataHash, address viewer) 
        internal
        view
        returns (bool)
    {
        //Get LinniaPermissions
        LinniaPermissions permissions = linniaHub.permissionsContract();
        (bool canAccess, ) = permissions.permissions(dataHash, viewer);
        return canAccess;
        
    }

    function createEscrow(bytes32 dataHash, string publicEncKey) public payable {
        (uint price, address owner) = aplusListings.getListing(dataHash);

        require((msg.value == price), "You didn't send the right amount with your transaction.");

        escrows[dataHash][msg.sender] = Escrow({
            paid: true,
            fulfilled: false,
            tokensClaimed: false,
            buyer: msg.sender,
            seller: owner,
            listingID: dataHash,
            publicEncKey: publicEncKey
        });

        buyersByDataHash[dataHash].push(msg.sender);
        dataHashesBySeller[owner].push(dataHash);
        dataHashesByBuyer[msg.sender].push(dataHash);
    }

    function revokeEscrow(bytes32 dataHash) public {
        require((!doesPermissionExists(dataHash, msg.sender)), "Data was already shared");
        delete escrows[dataHash][msg.sender];
    }

    function claimMoney(bytes32 dataHash, address viewer) public {
        require((doesPermissionExists(dataHash, viewer)), "You haven't shared the data");
        require((!escrows[dataHash][viewer].fulfilled), "You already claimed your money");

        (uint price, ) = aplusListings.getListing(dataHash);
        require((escrows[dataHash][viewer].seller == msg.sender), "You are not the seller");

        escrows[dataHash][viewer].fulfilled = true;

        msg.sender.transfer(price);
    }

    function tokensAlreadyClaimed(bytes32 dataHash, address buyer) public view returns(bool) {
        return escrows[dataHash][buyer].tokensClaimed;
    }

    function claimTokens(bytes32 dataHash, address buyer) public {
        require((!escrows[dataHash][buyer].tokensClaimed), "You already claimed your tokens");
        require((escrows[dataHash][buyer].buyer == msg.sender), "You are not the buyer");

        escrows[dataHash][buyer].tokensClaimed = true;
    }

    function getEscrowDataHashesByBuyer(address buyer) public view returns (bytes32[]) {
        return dataHashesByBuyer[buyer];
    }

    function getEscrowDataHashesBySeller(address seller) public view returns (bytes32[]) {
        return dataHashesBySeller[seller];
    }

    function getEscrowForBuyer(bytes32 dataHash, address buyer) public view 
    returns (
        address,
        address,
        bool,
        bool,
        bool,
        bytes32,
        string)
    {
        Escrow storage escrow = escrows[dataHash][buyer];
        return (escrow.buyer, escrow.seller, escrow.paid, escrow.fulfilled, escrow.tokensClaimed, escrow.listingID, escrow.publicEncKey);
    }

    function getBuyersForDataHash(bytes32 dataHash) public view 
    returns (address[])
    {
        return buyersByDataHash[dataHash];
    }

}