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

    function createElection(
        string memory _name,
        string memory _description,
        string memory _bannerUrl,
        uint256 _startDate,
        uint256 _endDate
    ) public returns (bytes32) {
        require(msg.sender == owner, "Only admin can create elections");
        require(_startDate < _endDate, "Invalid timeline");

        bytes32 electionId = keccak256(abi.encodePacked(_name, _startDate, msg.sender, block.timestamp));

        require(!elections[electionId].exists, "Election already exists");

        elections[electionId] = Election({
            name: _name,
            description: _description,
            bannerUrl: _bannerUrl,
            startDate: _startDate,
            endDate: _endDate,
            exists: true
        });

        emit ElectionCreated(electionId, _name, _startDate, _endDate, msg.sender);
        return electionId;
    }

    function getElection(bytes32 _electionId) external view returns (Election memory) {
        require(elections[_electionId].exists, "Election does not exist");
        return elections[_electionId];
    }
}
