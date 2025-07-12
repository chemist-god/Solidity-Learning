// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract VotingSystem {
    // Reference to ElectionFactory
    address public immutable electionFactory;

    // Struct for tracking votes in an election
    struct ElectionVotes {
        mapping(address => bool) hasVoted;       // Track voters
        mapping(uint => uint) voteCount;         // Votes per candidate index
        uint totalVotes;
        uint candidateCount;
    }

    // Mapping from election ID to its vote data
    mapping(uint => ElectionVotes) private electionVotes;

    // List of candidate names per election
    mapping(uint => string[]) public candidatesByElection;

    // Events
    event Voted(
        uint indexed electionId,
        address indexed voter,
        uint candidateIndex
    );

    event CandidatesRegistered(uint indexed electionId, string[] candidates);

    // Errors
    error ElectionDoesNotExist();
    error ElectionNotActive();
    error VoterAlreadyVoted();
    error InvalidCandidateIndex();
    error CallerNotOwner();

    // Modifier to check if sender is owner of ElectionFactory
    modifier onlyFactoryOwner() {
        require(
            msg.sender == Ownable(electionFactory).owner(),
            "Caller is not the factory owner"
        );
        _;
    }

    // Constructor takes ElectionFactory address
    constructor(address _electionFactory) {
        electionFactory = _electionFactory;
    }

    
    function registerCandidates(uint electionId, string[] memory _candidates) external onlyFactoryOwner {
        require(_candidates.length > 0, "At least one candidate required");

        // Clear previous candidates (if any)
        delete candidatesByElection[electionId];

        // Set new candidates
        candidatesByElection[electionId] = _candidates;

        electionVotes[electionId].candidateCount = _candidates.length;

        emit CandidatesRegistered(electionId, _candidates);
    }

    /**
     * @dev Cast a vote for a candidate in a specific election
     */
    function vote(uint electionId, uint candidateIndex) external {
        ElectionVotes storage ev = electionVotes[electionId];
        require(candidateIndex < ev.candidateCount, "Invalid candidate index");
        require(!ev.hasVoted[msg.sender], "You already voted in this election");

        // Get election info from ElectionFactory
        (bool success, bytes memory data) = electionFactory.staticcall(
            abi.encodePacked(
                bytes4(keccak256("isElectionActive(uint256)")),
                abi.encode(electionId)
            )
        );
        require(success, "Call to ElectionFactory failed");
        require(abi.decode(data, (bool)), "Election is not active");

        // Mark voter as having voted
        ev.hasVoted[msg.sender] = true;

        // Record vote
        ev.voteCount[candidateIndex] += 1;
        ev.totalVotes += 1;

        emit Voted(electionId, msg.sender, candidateIndex);
    }

    /**
     * @dev Get number of votes a candidate received in an election
     */
    function getVoteCount(uint electionId, uint candidateIndex) external view returns (uint) {
        return electionVotes[electionId].voteCount[candidateIndex];
    }

    /**
     * @dev Check if a user has already voted in an election
     */
    function hasVoted(uint electionId, address voter) external view returns (bool) {
        return electionVotes[electionId].hasVoted[voter];
    }

    /**
     * @dev Get total votes cast in an election
     */
    function getTotalVotes(uint electionId) external view returns (uint) {
        return electionVotes[electionId].totalVotes;
    }

    /**
     * @dev Get list of candidate names for an election
     */
    function getCandidates(uint electionId) external view returns (string[] memory) {
        return candidatesByElection[electionId];
    }

    /**
     * @dev Get total number of candidates in an election
     */
    function getCandidateCount(uint electionId) external view returns (uint) {
        return electionVotes[electionId].candidateCount;
    }
}