// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract FoodDelivery {
    //structs
    struct Restaurant {
        string name;
        string location;
        uint256 registrationTime;
        bool isRegistered;
    }

    // Restaurant menu items
    struct MenuItem{
        string name;
        uint256 price;
        bool isAvailable;
    }

    //Order
    struct Order {
        uint256 OrderId;
        address customer;
        uint256 totalAmount;
        uint256[] itemsIds;
        OrderStatus status;
        address restaurant;
        uint256 timestamp; 
    }
    enum OrderStatus {
        Placed,
        Preparing,
        OutForDelivery,
        Delivered
    }

    // state variables  to keep track of order
    uint256 public  nextOrder = 1;
    mapping(address => Restaurant) public restaurants;
    mapping(address => mapping(uint256 => MenuItem)) public menus;
    mapping(uint256 => Order) public orders;
    mapping(address => uint256[]) public customerOrders;
    
    //Events
    event RestaurantRegistered(address indexed restaurant, string name);
    event MenuItemAdded(address indexed restaurant, uint256 itemId, string itemName, uint256 price);
    event OrderPlaced(uint256 indexed orderId, address indexed customer, address indexed restaurant, uint256 totalAmount);
    event OrderStatusUpdated(uint256 indexed orderId, OrderStatus newStatus);
}