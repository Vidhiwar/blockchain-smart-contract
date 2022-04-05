pragma solidity >=0.4.24;
import "./Ownable.sol";

contract Destructible is Ownable {

    constructor() payable public {}

    function destroyAndSend(address _recipient) onlyOwner public {
        selfdestruct(payable(_recipient));
    }

}