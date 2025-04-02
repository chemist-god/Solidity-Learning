

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

    // State variable to keep track of the total number of orders
    uint256 public orderCount;

    // Mapping to store orders by their unique ID
    mapping(uint256 => Order) public orders;

    // Events to log important actions
    event OrderPlaced(uint256 indexed orderId, address indexed customer, string foodItem, uint256 price);
    event OrderAccepted(uint256 indexed orderId);
    event OrderDelivered(uint256 indexed orderId);
    event OrderCanceled(uint256 indexed orderId);

    // Modifier to ensure that only the customer can call certain functions
    modifier onlyCustomer(uint256 orderId) {
        require(msg.sender == orders[orderId].customer, "Not the customer");
        _; // Continue execution of the function
    }

    // Modifier to ensure that the order is still pending
    modifier onlyPending(uint256 orderId) {
        require(orders[orderId].status == OrderStatus.Pending, "Order not pending");
        _; // Continue execution of the function
    }
}