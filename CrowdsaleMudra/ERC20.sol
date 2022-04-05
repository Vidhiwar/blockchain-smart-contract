pragma solidity >=0.4.24;

abstract contract ERC20 {
    uint public totalSupply;
    function balanceOf(address _owner) public view virtual returns (uint balance);
    function transfer(address _to, uint _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public virtual returns (bool success);
    function approve(address _sender, uint _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public view virtual returns (uint remaining);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

}