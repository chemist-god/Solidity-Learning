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

    // Step 4: Implement Basic Functions

    // Function to add a new todo
    function addTodo(string memory _content) public {
        todos[nextId] = Todo(nextId, _content, Status.Pending);
        todoIds.push(nextId);
        emit TodoAdded(nextId, _content);
        nextId++;
    }

    // Function to update the status of a todo
    function updateStatus(uint _id, Status _status) public {
        require(bytes(todos[_id].content).length > 0, "Todo does not exist.");
        todos[_id].status = _status;
    }

    // Function to get a specific todo
    function getTodo(uint _id) public view returns (uint, string memory, Status) {
        require(bytes(todos[_id].content).length > 0, "Todo does not exist.");
        Todo memory todo = todos[_id];
        return (todo.id, todo.content, todo.status);
    }
}