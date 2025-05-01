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
}