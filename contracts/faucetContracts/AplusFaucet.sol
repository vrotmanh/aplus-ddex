pragma solidity ^0.4.20;

////
contract ERC20 {
    function transfer(address _to, uint256 _value) public returns (bool success);
}

contract AplusEscrows {
function claimTokens(bytes32 dataHash, address buyer) public; 

function tokensAlreadyClaimed(bytes32 dataHash, address buyer) public view returns(bool);
}

contract AplusFaucet {
    event withdrawlEvent(address indexed _sender, uint256 _value, bytes32 hash);
    
    function withdrawl(address addr, address addrDdex, bytes32 hash) public {
         ERC20 token = ERC20(addr);
         AplusEscrows ae = AplusEscrows(addrDdex);
         
         require(!ae.tokensAlreadyClaimed(hash, msg.sender));
         ae.claimTokens(hash, msg.sender);
         
         uint256 reward = 10 ether;
         token.transfer(msg.sender, reward);
         emit withdrawlEvent(msg.sender, reward, hash);
    }
}
