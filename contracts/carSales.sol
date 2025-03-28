// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CarLeasingAndSales {
    struct Car {
        address owner;
        uint256 price;
        uint256 deposit;
        uint256 leaseTerm;
        uint256 leaseEnd;
        bool isLeased;
    }

    mapping(address => Car) public cars;
    uint256 public carCount;

    event CarRegistered(address indexed owner, uint256 price, uint256 deposit, uint256 leaseTerm);
    event CarLeased(address indexed lessee, uint256 leaseEnd);
    event CarBought(address indexed buyer, uint256 price);

    constructor() {
        carCount = 0;
    }

    modifier onlyOwner(address _carOwner) {
        require(msg.sender == cars[_carOwner].owner, "Only the car owner can call this function.");
        _;
    }

    function registerCar(uint256 _price, uint256 _deposit, uint256 _leaseTerm) public {
        require(_price > 0, "Price must be greater than zero.");
        require(_deposit > 0, "Deposit must be greater than zero.");
        require(_leaseTerm > 0, "Lease term must be greater than zero.");

        Car memory car = Car(msg.sender, _price, _deposit, _leaseTerm, 0, false);

        cars[msg.sender] = car;
        carCount++;

        emit CarRegistered(msg.sender, _price, _deposit, _leaseTerm);
    }

    
}