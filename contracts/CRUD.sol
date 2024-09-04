// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleCRUD {
    // Item structure
    struct Item {
        uint id;
        string name;
        string description;
    }

    // Mapping from item ID to Item struct
    mapping(uint => Item) public items;
    
    // Counter for the next item ID
    uint public nextId;

    // Function to create a new item
    function createItem(string memory name, string memory description) public {
        items[nextId] = Item(nextId, name, description);
        nextId++;
    }

    // Function to read an item by ID
    function readItem(uint id) public view returns (Item memory) {
        return items[id];
    }

    // Function to update an existing item by ID
    function updateItem(uint id, string memory name, string memory description) public {
        require(id < nextId, "Item does not exist.");
        items[id] = Item(id, name, description);
    }

    // Function to delete an item by ID
    function deleteItem(uint id) public {
        require(id < nextId, "Item does not exist.");
        delete items[id];
    }
}
