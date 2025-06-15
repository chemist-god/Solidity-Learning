// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract WorkAndPayCarRental {
    struct Car {
        uint id;
        string model;
        uint salesPrice;
        uint paidAmount;
        uint paymentFrequency; // in days (e.g., 7 for weekly)
        address payable owner;
        address payable driver;
        bool isCompleted;
    }

    uint public carCount;
    mapping(uint => Car) public cars;

    event CarRegistered(uint carId, string model, uint salesPrice, address owner);
    event DriverAssigned(uint carId, address driver, uint paymentFrequency);
    event PaymentMade(uint carId, address driver, uint amount, uint remainingBalance);
    event OwnershipTransferred(uint carId, address newOwner);

   
}
