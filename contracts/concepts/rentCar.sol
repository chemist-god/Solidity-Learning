// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract CarRental {
    struct Car {
        uint id;
        string model;
        uint rentalPrice;
        bool isAvailable;
        address payable owner;
    }

    struct Rental {
        uint carId;
        address renter;
        uint startTime;
        uint endTime;
        bool isActive;
    }

    uint public carCount;
    mapping(uint => Car) public cars;
    mapping(address => Rental) public rentals;

    event CarRegistered(uint carId, string model, uint rentalPrice, address owner);
    event CarRented(uint carId, address renter, uint startTime, uint endTime);
    event CarReturned(uint carId, address renter);

    
}
