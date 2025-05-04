// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// the Base contract for ownership control
contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
}

// Voting System contract inheriting from Ownable
contract VotingSystem is Ownable {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Mappings to store candidates and track voters
    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;
    uint public candidateCount;

    // Function to add a candidate, only callable by the contract owner
    function addCandidate(string calldata name) external onlyOwner {
        candidates[candidateCount] = Candidate(candidateCount, name, 0);
        candidateCount++;
    }

    // Function for voting, ensuring one vote per address
    function vote(uint candidateId) external {
        require(!voters[msg.sender], "You have already voted");
        require(candidates[candidateId].id == candidateId, "wronng candidate ID");

        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
    }

    // Function to get candidate details
    function getCandidate(uint candidateId) public view returns (string memory name, uint voteCount) {
        Candidate memory candidate = candidates[candidateId];
        return (candidate.name, candidate.voteCount);
    }

    // Function to get the total number of candidates
    function getTotalCandidates() public view returns (uint) {
        return candidateCount;
    }
}
