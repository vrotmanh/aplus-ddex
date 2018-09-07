pragma solidity 0.4.24;


import "node_modules/openzeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./LinniaUsers.sol";
import "./LinniaRecords.sol";
import "./LinniaPermissions.sol";


contract LinniaHub is Ownable, Destructible {
    LinniaUsers public usersContract;
    LinniaRecords public recordsContract;
    LinniaPermissions public permissionsContract;

    event LogUsersContractSet(address from, address to);
    event LogRecordsContractSet(address from, address to);
    event LogPermissionsContractSet(address from, address to);

    constructor() public { }

    function () public { }

    function setUsersContract(LinniaUsers _usersContract)
        onlyOwner
        external
        returns (bool)
    {
        address prev = address(usersContract);
        usersContract = _usersContract;
        emit LogUsersContractSet(prev, _usersContract);
        return true;
    }

    function setRecordsContract(LinniaRecords _recordsContract)
        onlyOwner
        external
        returns (bool)
    {
        address prev = address(recordsContract);
        recordsContract = _recordsContract;
        emit LogRecordsContractSet(prev, _recordsContract);
        return true;
    }

    function setPermissionsContract(LinniaPermissions _permissionsContract)
        onlyOwner
        external
        returns (bool)
    {
        address prev = address(permissionsContract);
        permissionsContract = _permissionsContract;
        emit LogPermissionsContractSet(prev, _permissionsContract);
        return true;
    }
}
