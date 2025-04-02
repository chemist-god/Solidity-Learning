

// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// this defines the FoodDelivery contract
contract FoodDelivery {
    // Enum to represent the status of an order
    enum OrderStatus { Pending, Accepted, Delivered, Canceled }

    // Struct to represent an order
    struct Order {
        uint256 id;                // Unique identifier for the order
        address customer;          // Address of the customer who placed the order
        string foodItem;          // Description of the food item ordered
        uint256 price;            // Price of the order in wei (smallest unit of Ether)
        OrderStatus status;       // Current status of the order
        uint256 timestamp;        // Time when the order was placed
    }

}