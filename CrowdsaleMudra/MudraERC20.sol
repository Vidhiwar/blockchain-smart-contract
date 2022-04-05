pragma solidity >=0.4.24;

import "./Ownable.sol";
import "./ERC20.sol";

contract Mudra is Ownable, ERC20 {

    mapping (address => uint ) internal mudraBalance;
    mapping (address => mapping (address => uint)) internal allowances;
    mapping (address => bool ) public frozenAccount;

    // event Transfer(address indexed from, address indexed to, uint value);
    // event Approval(address indexed authorizer, address indexed authorized, uint value);
    event FrozenAccount(address target, bool frozen);

    constructor (uint _initialSupply) public {
        owner = msg.sender;

        mint(owner, _initialSupply);
    }

    function balanceOf(address _account) public view override(ERC20) returns (uint balance) {

        return mudraBalance[_account];
    }

    function transfer(address _to, uint _amount) public override(ERC20) returns (bool) {
        require(_to != address(0x0));
        require(mudraBalance[msg.sender] > _amount);
        require(mudraBalance[_to] + _amount > mudraBalance[_to]);
        
        mudraBalance[msg.sender] -= _amount;
        mudraBalance[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _authorizedAccount, uint _allowance) public override(ERC20) returns (bool success) {
        allowances[msg.sender][_authorizedAccount] = _allowance;

        emit Approval(msg.sender, _authorizedAccount, _allowance);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _amount) public override(ERC20) returns (bool success) {
        require(_to != address(0x0));
        require(mudraBalance[_from] > _amount); 
        require(mudraBalance[_to] + _amount >= mudraBalance[_to]);
        require(_amount <= allowances[_from][_to]);

        mudraBalance[_from] -= _amount;
        mudraBalance[_to] += _amount;
        allowances[_from][_to] -= _amount;

        emit Transfer(_from, _to, _amount);
        return true;
    }

    function allowance(address _authorizer, address _authorizedAccount) public override(ERC20) view returns (uint) {
        return allowances[_authorizer][_authorizedAccount];
    }

    function mint(address _recipient, uint _mintedAmount) onlyOwner public {
        mudraBalance[_recipient] += _mintedAmount;
        emit Transfer(owner, _recipient, _mintedAmount);
    }

    function freezeAccount(address target, bool freeze) onlyOwner public {

        frozenAccount[target] = freeze;
        emit FrozenAccount(target, freeze);
    }
    

}