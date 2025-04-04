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
    struct MenuItem{
        string name;
        uint256 price;
        bool isAvailable;
    }
}