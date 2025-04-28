// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;



contract SimpleBank {
    address public owner;
    uint public totalBalance;

    event Deposited(address indexed sender, uint amount);
    event Withdrawn(address indexed receiver, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    
}