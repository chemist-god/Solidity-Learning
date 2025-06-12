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

    function registerCar(string memory _model, uint _rentalPrice) public {
        carCount++;
        cars[carCount] = Car(carCount, _model, _rentalPrice, true, payable(msg.sender));
        emit CarRegistered(carCount, _model, _rentalPrice, msg.sender);
    }

    function rentCar(uint _carId, uint _duration) public payable {
        Car storage car = cars[_carId];
        require(car.isAvailable, "Car not available");
        require(msg.value >= car.rentalPrice * _duration, "Insufficient payment");

        car.isAvailable = false;
        rentals[msg.sender] = Rental(_carId, msg.sender, block.timestamp, block.timestamp + _duration, true);
        car.owner.transfer(msg.value);
        
        emit CarRented(_carId, msg.sender, block.timestamp, block.timestamp + _duration);
    }

    function returnCar(uint _carId) public {
        Rental storage rental = rentals[msg.sender];
        require(rental.carId == _carId, "Not rented by user");
        require(rental.isActive, "Rental already ended");

        cars[_carId].isAvailable = true;
        rental.isActive = false;

        emit CarReturned(_carId, msg.sender);
    }
}
