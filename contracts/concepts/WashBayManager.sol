// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract WashBayManager {
    enum ServiceType { CarWash, OilChange, Vacuum }
    enum Status { Requested, InProgress, Completed, Cancelled }

    struct Service {
        address customer;
        address worker;
        ServiceType serviceType;
        uint256 fee;
        Status status;
        uint256 timestamp;
    }

    address public owner;
    uint256 public serviceCount;
    mapping(uint256 => Service) public services;

    event ServiceRequested(uint256 serviceId, address indexed customer, ServiceType serviceType, uint256 fee);
    event WorkerAssigned(uint256 serviceId, address indexed worker);
    event ServiceCompleted(uint256 serviceId);
    event ServiceCancelled(uint256 serviceId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier onlyCustomer(uint256 serviceId) {
        require(msg.sender == services[serviceId].customer, "Not the customer");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    
}
