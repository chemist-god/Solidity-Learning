// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./voterRegistration.sol";

contract Voting is VoterRegistration {
    mapping(uint => uint) public votes;
    uint public totalVotes;

    function castVote(uint _candidate) public {
        require(voters[msg.sender].isRegistered, "You are not registered to vote.");
        require(!voters[msg.sender].hasVoted, "You have already voted.");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].vote = _candidate;
        votes[_candidate]++;
        totalVotes++;
    }

    function getVotes(uint _candidate) public view returns (uint) {
        return votes[_candidate];
    }
}
