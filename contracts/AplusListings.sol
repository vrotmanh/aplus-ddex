pragma solidity 0.4.24;

import "./linnia-contracts/LinniaHub.sol";
import "./linnia-contracts/LinniaRecords.sol";
import "./linnia-contracts/LinniaUsers.sol";
import "./AplusEscrows.sol";

contract AplusListings {
    LinniaHub public linniaHub;
    AplusEscrows public aplusEscrows;

    struct Listing {
        uint price;
        address owner;
    }

    // mapping [dataHash] -> Listing
    mapping(bytes32 => Listing) public listings;

    // array of listed dataHashes
    bytes32[] public listedDataHashes;

    function () public { }
    constructor(LinniaHub _linniaHub) public {
        linniaHub = _linniaHub;
    }

    function setupEscrowContract(AplusEscrows _aplusEscrows) public {
        aplusEscrows = _aplusEscrows;
    }

    function getAndVerifyOwner(bytes32 dataHash) 
        internal
        view
        returns (address)
    {
        //Get LinniaRecords
        LinniaRecords records = linniaHub.recordsContract();

        //Get the owner of the dataHash
        address owner = records.recordOwnerOf(dataHash);
        
        //Check that the datahash exists in the Linnia Records
        require((owner != address(0)), "Record not found");

        //Check that msg.sender is the owner of the record
        require((msg.sender == owner), "You don't own that data");

        return owner;
        
    }

    function createListing(bytes32 dataHash, uint price)
        external
        returns (bool)
    {
        address owner = getAndVerifyOwner(dataHash);

        //Add the dataHash to the listed array if does not exists
        if(listings[dataHash].owner == address(0)){
            listedDataHashes.push(dataHash);
        }

        //Create the listing
        listings[dataHash] = Listing({
            price: price,
            owner: owner
        });

        return true;
    }

    function removeListing(bytes32 dataHash)
        external
        returns (bool)
    {
        //address owner = getAndVerifyOwner(dataHash);
        //TODO check that the listing has no open escows in the escrow contract

        //Remove the listing
        delete listings[dataHash];
        return true;
    }

    function getListing(bytes32 dataHash) public view returns(uint, address)
    {
        return (listings[dataHash].price, listings[dataHash].owner);
    }

    function getListedDataHashes() public view returns(bytes32[])
    {
        return listedDataHashes;
    }
}