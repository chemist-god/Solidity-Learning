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

   
}