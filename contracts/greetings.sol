// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract NightOfCode {
    string private message;

    constructor(string memory initializeMessage) {
        message = initializeMessage;
    }
    
    function getMessage() public view returns (string memory) {
        return message;
    }

    // Corrected the setMessage function to accept a parameter
    function setMessage(string memory newMessage) public {
        message = newMessage; 
    }
}