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

    function registerCar(string memory _model, uint _salesPrice, uint _paymentFrequency) public {
        carCount++;
        cars[carCount] = Car(carCount, _model, _salesPrice, 0, _paymentFrequency, payable(msg.sender), payable(address(0)), false);
        emit CarRegistered(carCount, _model, _salesPrice, msg.sender);
    }

    function assignDriver(uint _carId, address _driver) public {
        require(cars[_carId].owner == msg.sender, "Only the owner can assign a driver");
        require(cars[_carId].driver == address(0), "Driver already assigned");

        cars[_carId].driver = payable(_driver);
        emit DriverAssigned(_carId, _driver, cars[_carId].paymentFrequency);
    }

    function makePayment(uint _carId) public payable {
        Car storage car = cars[_carId];
        require(car.driver == msg.sender, "Only assigned driver can pay");
        require(car.isCompleted == false, "Car already fully paid");

        car.paidAmount += msg.value;
        car.owner.transfer(msg.value);
        emit PaymentMade(_carId, msg.sender, msg.value, car.salesPrice - car.paidAmount);

        if (car.paidAmount >= car.salesPrice) {
            car.isCompleted = true;
            car.owner = car.driver; // Transfer ownership
            emit OwnershipTransferred(_carId, car.driver);
        }
    }
}
