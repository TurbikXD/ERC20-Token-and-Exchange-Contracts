// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Mgs.sol";

contract MGSToken is MGS {
    constructor(address initialOwner)
        MGS("MGS", "MGS", 18)
        Ownable(initialOwner) 
    {
        _mint(msg.sender, 1000000 * 10 ** uint256(18));
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }
}
