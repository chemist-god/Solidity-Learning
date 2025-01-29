// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Inbox {
    string public  message; 
    constructor(string memory firstMessage) {
        message = firstMessage;
    }

    function setMessage(string memory newMessage) public  {
        message = newMessage;
    }
}