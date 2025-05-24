// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/dynamic/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintableToken is IERC20Metadata, Ownable {
    constructor() ERC20("Mint Token", "MT") {}

    // Initialize total supply on deployment
    function initializeSupply(uint256 initialAmount) external onlyOwner {
        _totalSupply = initialAmount;
        emit Transfer(address(0), msg.sender, initialAmount);
    }

    // Mint function: updates the `_totalSupply` and emits a transfer event.
    function mint(address to, uint256 amount) external override onlyOwner returns (bool success){
        require(amount > 0,"Minting less than one token is not allowed.");
        
        _mint(to,amount);

        emit Transfer(msg.sender,to,amount);
        return true;
    }
}