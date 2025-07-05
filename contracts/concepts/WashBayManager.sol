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

   
}
