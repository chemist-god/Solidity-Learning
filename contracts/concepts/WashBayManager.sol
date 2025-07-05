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

    function requestService(ServiceType _serviceType) external payable returns (uint256) {
        require(msg.value > 0, "Fee must be greater than 0");

        services[serviceCount] = Service({
            customer: msg.sender,
            worker: address(0),
            serviceType: _serviceType,
            fee: msg.value,
            status: Status.Requested,
            timestamp: block.timestamp
        });

        emit ServiceRequested(serviceCount, msg.sender, _serviceType, msg.value);
        return serviceCount++;
    }

    function assignWorker(uint256 _serviceId, address _worker) external onlyOwner {
        Service storage s = services[_serviceId];
        require(s.status == Status.Requested, "Service already assigned");
        s.worker = _worker;
        s.status = Status.InProgress;

        emit WorkerAssigned(_serviceId, _worker);
    }

    function markCompleted(uint256 _serviceId) external {
        Service storage s = services[_serviceId];
        require(msg.sender == s.worker, "Only assigned worker can complete");
        require(s.status == Status.InProgress, "Invalid status");

        s.status = Status.Completed;
        payable(s.worker).transfer(s.fee);

        emit ServiceCompleted(_serviceId);
    }

    
}
