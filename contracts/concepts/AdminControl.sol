// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdminControl {
    address public owner;

    constructor() {
        owner = msg.sender; // Sets contract creator as owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner"); // Restricts access
        _;
    }

    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner; // Only owner can change ownership
    }
}
