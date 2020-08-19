pragma solidity 0.5.12;

import './Ownable.sol';

contract ERC20 is Ownable {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    
    mapping (address => uint256) private _balances;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    constructor(string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    
    function name() public view returns (string memory) {
        return _name;
    }

    function symbols() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
    
    function totalSuppy() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
    
    function mint(address account, uint256 amount) public onlyOwner returns (bool) {
        require (account != address(0));
        _balances[account] += amount;
        _totalSupply += amount;
    }
    
    function transfer(address to, uint256 amount) public returns (bool) {
        address sender = msg.sender;
        require (to != address(0), "Invalid to address");
        require (_balances[sender] >= amount, "Insufficient balance in address");
        
        uint256 senderBalance_before = _balances[sender];
        _balances[sender] -= amount;
        uint256 senderBalance_after = _balances[sender];
        
        uint256 toBalance_before = _balances[to];
        _balances[to] += amount;
        uint256 toBalance_after = _balances[to];
        
        assert (senderBalance_before - amount == senderBalance_after && toBalance_after - amount == toBalance_before);
        
        emit Transfer(sender, to, amount);
        return true;
    }
    
    function allowance(address _owner, address spender) public view returns (uint256) {
        require(_owner == owner, "Invalid owner");
        require(spender != address(0), "Invalid address");
        return 0; // TODO: Not implemented yet
    }
}