// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;



contract SimpleSmartAccount {
    address public owner;

    // Event to log deposits
    event Deposited(address indexed sender, uint amount);

    // Event to log withdrawals
    event Withdrawn(address indexed to, uint amount);

    // Modifier to restrict access to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    
}

