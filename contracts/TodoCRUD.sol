// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract TodoCRUD {
    uint public nextId = 1;

    struct Task {
        uint id;
        string content;
        bool completed;
    }

    mapping(uint => Task) public tasks;

    event TaskCreated(uint id, string content);
    event TaskUpdated(uint id, string content, bool completed);
    event TaskDeleted(uint id);

    
}
