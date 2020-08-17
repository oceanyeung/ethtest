pragma solidity 0.5.12;

import './Ownable.sol';
import './SafeMath.sol';

contract ERC20 is Ownable {
    using SafeMath for uint256;

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
    
    // I changed it from mint to approve since that's what's in the ERC-20 specifications
    function approve(address account, uint256 amount) public onlyOwner returns (bool) {
        require (account != address(0));
        _balances[account] = _balances[account].add(amount);
        _totalSupply = _totalSupply.add(amount);
        emit Approval(owner, account, amount);
    }
    
    function transfer(address to, uint256 amount) public returns (bool) {
        address sender = msg.sender;
        require (to != address(0), "Invalid to address");
        require (_balances[sender] >= amount, "Insufficient balance in address");
        
        _balances[sender] = _balances[sender].sub(amount);
        _balances[to] = _balances[to].add(amount);
        
        emit Transfer(sender, to, amount);
        return true;
    }
    
    function allowance(address _owner, address spender) public view returns (uint256) {
        require(_owner == owner, "Invalid owner");
        require(spender != address(0), "Invalid address");
        return 0; // TODO: Not implemented yet
    }
}