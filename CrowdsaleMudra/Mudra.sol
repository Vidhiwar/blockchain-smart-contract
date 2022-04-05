pragma solidity >=0.4.0;

import "./Ownable.sol";

contract Mudra is Ownable {
    
    // enum AccountType {MudraHolder, Admin, Owner}

    // struct AccountDetails {
    //     address account;
    //     string firstName;
    //     string lastName;
    //     AccountType accountType;
    // }

    mapping (address => uint) public mudraBalance;
    mapping (address => mapping (address => uint)) public allowance;
    mapping (address => bool) public frozenAccount;
    // mapping (address => AccountDetails) public registeredAccount;

    address public ownerAddress;
    uint public constant maxTransactionAmount = 10000;

    address nullAccount = address(0x0);

    event Transfer(address indexed from, address indexed to, uint value);
    event FrozenAccount(address target, bool frozen);

    // modifier onlyOwner {
    //     // require(msg.sender == ownerAddress);
    //     if (msg.sender != ownerAddress){
    //         revert();
    //     }
    //     _;
    // }

    constructor(uint _initialSupply) public {
        ownerAddress = msg.sender;
        mintToken(ownerAddress, _initialSupply);
        // mudraBalance[msg.sender] = _initialSupply;
    }

    function transfer(address _to ,uint _amount) public {
        require(_to != nullAccount);
        require(mudraBalance[msg.sender] > _amount);
        require(mudraBalance[_to] + _amount >= mudraBalance[_to]);

        mudraBalance[msg.sender] -= _amount;
        mudraBalance[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }
    
    function transferFrom(address _from, address _to ,uint _amount) public returns (bool success) {
        require(_to != nullAccount);
        require(mudraBalance[_from] > _amount);
        require(mudraBalance[_to] + _amount >= mudraBalance[_to]);
        require(_amount <= allowance[_from][msg.sender]);


        mudraBalance[_from] -= _amount;
        mudraBalance[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;
        emit Transfer(_from, _to, _amount);
        return true;

    }



    function authorize(address _authorizedAccount, uint _allowance) public returns (bool success) {
        allowance[msg.sender][_authorizedAccount] = _allowance;
        return true;
    }

    function checkTransactionLimit(uint _amount) private pure returns (bool) {
        if (_amount >= maxTransactionAmount){
            return true;
        }
        return false;
    }

    function validateAccount(address _account) internal view returns (bool) {
        if (frozenAccount[_account] && mudraBalance[_account] > 0){
            return true;
        }
        return false;
    }

    function mintToken(address _recipient, uint _mintedAmount) onlyOwner public {
        mudraBalance[_recipient] += _mintedAmount;
        emit Transfer(ownerAddress, _recipient, _mintedAmount);
    }

    function freezeAccount(address targetAddress, bool freeze) onlyOwner public {
        frozenAccount[targetAddress] = freeze;
        emit FrozenAccount(targetAddress,freeze);
    }

}