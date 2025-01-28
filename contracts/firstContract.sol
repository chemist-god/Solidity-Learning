
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Inbox {
    string public message;

    // Constructor
    constructor(string memory initialMessage) {
        message = initialMessage;
    }

    // Function to set a new message
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }

    // The getMessage function is not needed since `message` is public
    // function getMessage() public view returns (string memory) {
    //     return message;
    // }
}