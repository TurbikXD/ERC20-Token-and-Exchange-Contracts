# Solidity Contracts for ERC20 Tokens and Exchange

This repository contains Solidity contracts for creating and managing ERC20 tokens, as well as a contract for exchanging these tokens and purchasing them with Ether. The project includes two implementations of the ERC20 token: one custom implementation and one using OpenZeppelin's libraries.

## Contracts

### 1. Mgs.sol
This contract defines the abstract base contract MGS, which implements the IERC20 interface and additional functionalities such as pausing, blocklisting, and ownership management.

**Key Features:**
- **IERC20 implementation:** Standard ERC20 functions including transfer, approve, transferFrom, balanceOf, and totalSupply.
- **Ownership:** Managed using Ownable from OpenZeppelin.
- **Pausing:** Ability to pause all token transfers.
- **Blocklist:** Ability to blocklist specific addresses from transferring or receiving tokens.
- **Minting and Burning:** Internal functions for minting and burning tokens.

### 2. MgsToken.sol
This contract implements the MGS contract to create the MGSToken.

**Key Features:**
- **Initial Mint:** Mints an initial supply of 1,000,000 tokens to the contract deployer.
- **Minting and Burning:** Functions to mint and burn tokens, restricted to the owner.

### 3. MgsOz.sol
This contract uses OpenZeppelin's implementation of the ERC20 standard to create the MGSopenzeppelin token.

**Key Features:**
- **ERC20 Standard:** Uses OpenZeppelin's ERC20, ERC20Burnable, Ownable, and ERC20Permit extensions.
- **Initial Mint:** Mints an initial supply of 1,000,000 tokens to the contract deployer.
- **Minting:** Function to mint additional tokens, restricted to the owner.

### 4. MgsExchange.sol
This contract facilitates the exchange of MGSToken and MGSopenzeppelin tokens, as well as their purchase with Ether.

**Key Features:**
- **Token Exchange:** Exchange between tokenA and tokenB at a defined rate.
- **Token Purchase:** Buy tokens with Ether.
- **Deposit and Withdraw:** Deposit tokens into the contract and withdraw Ether by the owner.
- **Exchange Rate Management:** Set and update the exchange rate.

## Usage

- **Exchanging Tokens:** Use the `exchangeTokens` function to exchange tokenA for tokenB and vice versa.
- **Buying Tokens with Ether:** Use the `buyTokenWithEther` function to buy tokens by sending Ether to the contract.
- **Depositing Tokens:** Use the `depositTokens` function to deposit tokens into the contract.
- **Withdrawing Ether:** Use the `withdrawEther` function to withdraw Ether from the contract.

## Contributing
Contributions are welcome! Please create an issue or open a pull request with your changes.

## License
This project is licensed under the MIT License.
