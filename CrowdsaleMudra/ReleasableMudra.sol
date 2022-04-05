pragma solidity >= 0.4.18;

import "./Mudra.sol";
import "./Pausable.sol";
import "./Destructible.sol";
// import "./Ownable.sol";

contract ReleasableMudra is Mudra, Pausable, Destructible {
    bool public released = false;
    

    modifier isReleased() {
        if (!released){
            revert();
        }
        _;
    }

    constructor(uint _initialSupply) Mudra(_initialSupply) public {}

    
    function release() onlyOwner public {
        released = true;
    }

    function transfer(address _to, uint _amount) isReleased whenNotPaused override(Mudra) public {
        super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint _amount) isReleased whenNotPaused override(Mudra) public returns (bool) {
        super.transferFrom(_from, _to, _amount);
    }

}