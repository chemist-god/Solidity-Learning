// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ElectionFactory is Ownable(msg.sender) {
    // Struct to store election data
    struct Election {
        uint id;
        string name;
        string description;
        uint startDate;
        uint endDate;
        string bannerUrl;
        address createdBy;
        bool isActive;
    }

    // State variables
    uint public electionCount;
    bytes32 public immutable contractVersion = keccak256("TRUSTVOTE_V1");
    address public immutable deployer;

    // Mapping from election ID to Election struct
    mapping(uint => Election) public elections;

    
}