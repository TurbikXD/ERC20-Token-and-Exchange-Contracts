// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

// Abstract contract MGS implementing IERC20, Ownable, and Pausable functionalities
abstract contract MGS is IERC20, Ownable, Pausable {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _blocklist;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    // Function to get the token name
    function name() public view returns (string memory) {
        return _name;
    }

    // Function to get the token symbol
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    // Function to get the token decimals
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    // Function to get the total supply of the token
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // Function to get the balance of a specific account
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    // Function to transfer tokens from the sender to a recipient
    function transfer(address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    // Function to get the allowance of a spender for a specific owner
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    // Function to approve a spender to spend a specific amount of tokens
    function approve(address spender, uint256 amount) public override whenNotPaused returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    // Function to transfer tokens from a sender to a recipient using an allowance
    /**
        Tokens Origin: The sender address.
        Tokens Destination: The recipient address.
        msg.sender: The caller of the transferFrom function, typically an approved spender.
    */
    function transferFrom(address sender, address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);
        _transfer(sender, recipient, amount);
        return true;
    }

    // Function to add an account to the blocklist
    function addToBlocklist(address account) public onlyOwner {
        _blocklist[account] = true;
    }

    // Function to remove an account from the blocklist
    function removeFromBlocklist(address account) public onlyOwner {
        _blocklist[account] = false;
    }

    // Function to check if an account is blocked
    function isBlocked(address account) public view returns (bool) {
        return _blocklist[account];
    }

    // Internal function to transfer tokens
    /**
        Tokens Origin: The sender address.
        Tokens Destination: The recipient address.
        msg.sender: The caller of the transfer function, typically the owner of the tokens.
    */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        require(!_blocklist[sender], "ERC20: sender is blacklisted");
        require(!_blocklist[recipient], "ERC20: recipient is blacklisted");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] -= amount; 
        _balances[recipient] += amount; 

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    // Internal function to approve a spender
    /**
        Tokens Origin: None (just sets an allowance).
        Tokens Destination: None (just sets an allowance).
        msg.sender: The caller of the approve function, typically the owner of the tokens.
    */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        require(!_blocklist[owner], "ERC20: owner is blacklisted");
        require(!_blocklist[spender], "ERC20: spender is blacklisted");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    // Internal function to mint new tokens
    /**
        Tokens Origin: The contract itself (newly minted tokens).
        Tokens Destination: The account address.
        msg.sender: The caller of the _mint function, typically an internal function.
    */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        require(!_blocklist[account], "ERC20: account is blacklisted");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    // Internal function to burn tokens
    /** 
        Tokens Origin: The account address.
        Tokens Destination: The contract itself (tokens are burned).
        msg.sender: The caller of the _burn function, typically an internal function.
    */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");
        require(_balances[account] >= amount, "ERC20: burn amount exceeds balance");
        require(!_blocklist[account], "ERC20: account is blacklisted");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    // Function to pause the contract
    function pause() public onlyOwner {
        _pause();
    }

    // Function to unpause the contract
    function unpause() public onlyOwner {
        _unpause();
    }

    // Hook to be called before any token transfer
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }

    // Hook to be called after any token transfer
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
