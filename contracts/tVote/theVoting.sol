// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface ISoulboundToken {
    function balanceOf(address account) external view returns (uint256);
}

contract TheVoter {
    address public electionManager;
    address public soulboundTokenContract;

    struct VoteRecord {
        bool hasVoted;
        address candidateAddress;
    }

    mapping(address => VoteRecord) public voters;

    address[] public candidates;
    mapping(address => uint256) public voteCounts;

    event VoteCasted(address indexed voter, address indexed candidate);
    event VoterNotEligible(address indexed voter);

    modifier onlyElectionManager() {
        require(msg.sender == electionManager, "Only election manager can call this");
        _;
    }

    constructor(address _soulboundTokenAddress) {
        electionManager = msg.sender;
        soulboundTokenContract = _soulboundTokenAddress;
    }

    // here add a registered candidate to the list of votable candidates

    function addCandidate(address _candidateAddress) public onlyElectionManager {
        require(_candidateAddress != address(0), "Invalid address");
        candidates.push(_candidateAddress);
        voteCounts[_candidateAddress] = 0;
    }

}