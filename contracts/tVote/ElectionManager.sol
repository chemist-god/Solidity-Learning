// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ElectionManager {
    address public immutable owner;

    struct Election {
        string name;
        string description;
        uint256 startDate;
        uint256 endDate;
        string bannerUrl;
    }

    mapping(bytes32 => Election) public elections;
    bytes32[] public electionIds;

    event ElectionCreated(
        bytes32 indexed electionId,
        string name,
        uint256 startDate,
        uint256 endDate,
        address createdBy
    );

    error Unauthorized();
    error InvalidTimeline();
    error ElectionAlreadyExists();

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createElection(
        string memory _name,
        string memory _description,
        string memory _bannerUrl,
        uint256 _startDate,
        uint256 _endDate
    ) external onlyOwner returns (bytes32 electionId) {
        if (_startDate >= _endDate) revert InvalidTimeline();
        
        electionId = keccak256(abi.encodePacked(_name, _startDate, block.prevrandao, block.timestamp));
        if (elections[electionId].endDate != 0) revert ElectionAlreadyExists();

        elections[electionId] = Election(_name, _description, _startDate, _endDate, _bannerUrl);
        electionIds.push(electionId);
        
        emit ElectionCreated(electionId, _name, _startDate, _endDate, msg.sender);
    }

    function getElection(bytes32 _electionId) external view returns (Election memory) {
        return elections[_electionId];
    }

    function getAllElectionIds() external view returns (bytes32[] memory) {
        return electionIds;
    }
}