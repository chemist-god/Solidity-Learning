// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Inbox {
    string public message;
    address public owner;
    string[] public messageHistory;

    event MessageUpdated(string newMessage);
    event ContractCreated(string initialMessage);

    constructor(string memory initialMessage) {
        require(bytes(initialMessage).length > 0, "Initial message cannot be empty");
        owner = msg.sender;
        message = initialMessage;
        emit ContractCreated(initialMessage);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can set the message");
        _;
    }

    function setMessage(string memory newMessage) public onlyOwner {
        require(bytes(newMessage).length > 0, "Message cannot be empty");
        messageHistory.push(message); // Store the old message
        message = newMessage;
        emit MessageUpdated(newMessage);
    }

    function getMessageHistory() public view returns (string[] memory) {
        return messageHistory;
    }

    receive() external payable {
        // Handle received Ether
    }
}