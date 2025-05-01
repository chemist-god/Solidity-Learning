// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract TodoList {
    // Step 1: Create a Todo Status Enum
    enum Status { Pending, InProgress, Completed }

    // Step 2: Create a Todo Struct
    struct Todo {
        uint id;
        string content;
        Status status;
    }

    // Step 3: Use a Mapping and Array
    mapping(uint => Todo) public todos;
    uint[] public todoIds;
    uint public nextId = 1;

    // Step 5: Define the event
    event TodoAdded(uint id, string content);
}