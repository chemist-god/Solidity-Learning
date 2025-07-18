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

    // Events
    event ElectionCreated(
        uint indexed id,
        string name,
        string description,
        uint startDate,
        uint endDate,
        string bannerUrl,
        address indexed createdBy
    );

    event ElectionEnded(uint indexed id);
    event ContractDeployed(bytes32 indexed version, address indexed deployer);

    // Constructor
    constructor() {
        deployer = msg.sender;
        emit ContractDeployed(contractVersion, deployer);
    }
    
    // Create a new election
    function createElection(
        string memory _name,
        string memory _description,
        uint _startDate,
        uint _endDate,
        string memory _bannerUrl
    ) public onlyOwner {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_startDate < _endDate, "Start date must be before end date");
        require(_startDate > block.timestamp, "Start date must be in the future");

        electionCount++;
        uint newElectionId = electionCount;

        elections[newElectionId] = Election({
            id: newElectionId,
            name: _name,
            description: _description,
            startDate: _startDate,
            endDate: _endDate,
            bannerUrl: _bannerUrl,
            createdBy: msg.sender,
            isActive: true
        });

        emit ElectionCreated(
            newElectionId,
            _name,
            _description,
            _startDate,
            _endDate,
            _bannerUrl,
            msg.sender
        );
    }

    // End an election (archive or cancel)
    function endElection(uint _electionId) public {
        Election storage election = elections[_electionId];
        require(election.id != 0, "Election does not exist");
        require(election.createdBy == msg.sender || owner() == msg.sender, "Not authorized");
        require(election.isActive, "Election already ended");

        election.isActive = false;
        emit ElectionEnded(_electionId);
    }

    // Helper: Check if election is active
    function isElectionActive(uint _electionId) public view returns (bool) {
        Election storage election = elections[_electionId];
        return (
            election.isActive &&
            block.timestamp >= election.startDate &&
            block.timestamp <= election.endDate
        );
    }

    // Helper: Get list of all election IDs
    function getAllElectionIds() public view returns (uint[] memory) {
        uint[] memory ids = new uint[](electionCount);
        for (uint i = 0; i < electionCount; i++) {
            ids[i] = i + 1;
        }
        return ids;
    }

    // Get contract version
    function getVersion() public view returns (bytes32) {
        return contractVersion;
    }
}