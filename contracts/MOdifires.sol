
// pragma solidity ^0.8.9;

// contract PausableToken {
//     address public owner;
//     bool public paused;
//     mapping(address => uint) public balances;

//     constructor() {
//         owner = msg.sender;
//         paused = false;
//         balances[owner] = 100;
//     }
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract PausableToken {
    address public owner;
    bool public paused;
    mapping(address => uint) public balances;

    // Constructor function to initialize the contract
    constructor() {
        owner = msg.sender; // Set the owner to the person who deploys the contract
        paused = false; // Start with the contract not paused
        balances[owner] = 1000; // Give the owner 1000 coins to start with
    }

    // Function to pause the contract (only the owner can do this)
    function pause() public {
        require(msg.sender == owner, "Only the owner can pause the contract.");
        paused = true; // Flip the switch to pause the contract
    }

    // Function to unpause the contract (only the owner can do this)
    function unpause() public {
        require(msg.sender == owner, "Only the owner can unpause the contract.");
        paused = false; // Flip the switch to unpause the contract
    }

    // Function to send coins to another address
    function transfer(address to, uint amount) public {
        require(!paused, "The contract is paused. Transfers are not allowed.");
        require(balances[msg.sender] >= amount, "Not enough balance."); // Check if sender has enough coins

        balances[msg.sender] -= amount; // Subtract the amount from the sender's balance
        balances[to] += amount; // Add the amount to the recipient's balance
    }
}
