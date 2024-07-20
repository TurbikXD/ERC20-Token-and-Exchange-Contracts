// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// MGSExchange contract for exchanging and purchasing tokens
contract MGSExchange is Ownable {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public rate; // Exchange rate (1 tokenA = 1 tokenB)

    event TokensExchanged(address indexed user, address indexed tokenFrom, address indexed tokenTo, uint256 amount);
    event TokensPurchased(address indexed user, uint256 amount, uint256 etherSpent);

    constructor(IERC20 _tokenA, IERC20 _tokenB, uint256 _rate, address initialOwner) Ownable(initialOwner) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        rate = _rate;
    }

    // Function to exchange tokens
    /**  
        Tokens Origin: The fromToken is transferred from the user (msg.sender).
        Tokens Destination: The toToken is transferred to the user (msg.sender).
        msg.sender: The user calling the function, initiating the token exchange.
    */
    function exchangeTokens(IERC20 fromToken, IERC20 toToken, uint256 amount) external {
        require(fromToken == tokenA || fromToken == tokenB, "Invalid from token");
        require(toToken == tokenA || toToken == tokenB, "Invalid to token");
        require(fromToken != toToken, "From token and to token cannot be the same");

        uint256 allowance = fromToken.allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        fromToken.transferFrom(msg.sender, address(this), amount);
        toToken.transfer(msg.sender, amount * rate);

        emit TokensExchanged(msg.sender, address(fromToken), address(toToken), amount);
    }

    // Function to buy tokens with Ether
    /**  
        Tokens Origin: The tokens are transferred from the contract's balance (address(this)).
        Tokens Destination: The tokens are transferred to the user (msg.sender).
        msg.sender: The user calling the function, purchasing tokens with Ether.
    */
    function buyTokenWithEther(IERC20 token, uint256 amount) external payable {
        require(token == tokenA || token == tokenB, "Invalid token");
        uint256 etherAmount = msg.value;
        require(etherAmount >= amount, "Not enough Ether sent");
        require(token.balanceOf(address(this)) >= amount, "Not enough tokens in contract");

        token.transfer(msg.sender, amount);

        emit TokensPurchased(msg.sender, amount, etherAmount);
    }

    // Function to deposit tokens into the contract
    /**  
        Tokens Origin: The tokens are transferred from the owner's balance (msg.sender).
        Tokens Destination: The tokens are transferred to the contract's balance (address(this)).
        msg.sender: The owner calling the function, depositing tokens into the contract.
    */
    function depositTokens(IERC20 token, uint256 amount) external onlyOwner {
        require(token == tokenA || token == tokenB, "Invalid token");

        token.transferFrom(msg.sender, address(this), amount);
    }

    // Function to withdraw Ether from the contract
    /**
        Ether Origin: The Ether is transferred from the contract's balance (address(this)).
        Ether Destination: The Ether is transferred to the owner's balance (owner()).
        msg.sender: The owner calling the function, withdrawing Ether from the contract.
    */
    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // Function to set a new exchange rate
    function setRate(uint256 newRate) external onlyOwner {
        rate = newRate;
    }

    // Fallback function to receive Ether
    receive() external payable {}
}
