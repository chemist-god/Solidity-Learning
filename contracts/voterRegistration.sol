// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoterRegistration {
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint vote;
    }

    mapping(address => Voter) public voters;

    function registerVoter(address _voter) public {
        require(!voters[_voter].isRegistered, "Voter is already registered.");
        voters[_voter].isRegistered = true;
    }
}
