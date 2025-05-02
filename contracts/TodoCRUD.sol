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

    // Create a new task
    function createTask(string memory _content) public {
        tasks[nextId] = Task(nextId, _content, false);
        emit TaskCreated(nextId, _content);
        nextId++;
    }

    // Read a task by id
    function getTask(uint _id) public view returns (uint, string memory, bool) {
        require(tasks[_id].id != 0, "Task not found");
        Task storage task = tasks[_id];
        return (task.id, task.content, task.completed);
    }

    // Update a task by id
    function updateTask(uint _id, string memory _content, bool _completed) public {
        require(tasks[_id].id != 0, "Task not found");
        Task storage task = tasks[_id];
        task.content = _content;
        task.completed = _completed;
        emit TaskUpdated(_id, _content, _completed);
    }

    // Delete a task by id
    function deleteTask(uint _id) public {
        require(tasks[_id].id != 0, "Task not found");
        delete tasks[_id];
        emit TaskDeleted(_id);
    }
}
