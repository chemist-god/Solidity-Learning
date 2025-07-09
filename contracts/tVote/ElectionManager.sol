// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ElectionManager {
    address public owner;

    struct Election {
        string name;
        string description;
        uint256 startDate;
        uint256 endDate;
        string bannerUrl;
        bool exists;
    }

    mapping(bytes32 => Election) public elections;

    event ElectionCreated(
        bytes32 indexed electionId,
        string name,
        uint256 startDate,
        uint256 endDate,
        address createdBy
    );

    constructor() {
        owner = msg.sender;
    }

    
}
