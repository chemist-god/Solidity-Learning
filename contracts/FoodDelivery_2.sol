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
        bool status;
        address restaurant;
        uint256 timestamp; 
    }
}