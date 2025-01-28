// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Inbox {
    string public message;

    // Event to emit when the message is updated
    event MessageUpdated(string newMessage);

    // Constructor to initialize the message
    constructor(string memory initialMessage) {
        message = initialMessage;
    }

    // Function to set a new message
    function setMessage(string memory newMessage) public {
        message = newMessage;
        emit MessageUpdated(newMessage); // Emit the event when the message is updated
    }
}