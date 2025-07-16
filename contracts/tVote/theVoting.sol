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

    //Cast a vote for a candidate 
    function vote(address _candidateAddress) public {
        ISoulboundToken sbt = ISoulboundToken(soulboundTokenContract);

        // Check if the voter has the soulbound token
        require(sbt.balanceOf(msg.sender) == 1, "Voter not eligible: no soulbound token");

        // Check if the voter has already voted
        require(!voters[msg.sender].hasVoted, "Already voted");

        // Check if the candidate is valid
        bool isValidCandidate = false;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i] == _candidateAddress) {
                isValidCandidate = true;
                break;
            }
        }
        require(isValidCandidate, "Invalid candidate");

        // Record the vote
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].candidateAddress = _candidateAddress;
        voteCounts[_candidateAddress] += 1;

        emit VoteCasted(msg.sender, _candidateAddress);
    }


    //Get total number of candidates
    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }

    //candidate at index
    function getCandidate(uint256 index) public view returns (address) {
        return candidates[index];
    }

    //Get total votes for a candidate
    function getVoteCount(address candidate) public view returns (uint256) {
        return voteCounts[candidate];
    }

    //Check if a voter has already voted
    function hasVoted(address voter) public view returns (bool) {
        return voters[voter].hasVoted;
    }

    // Get who the voter voted for
    function getVote(address voter) public view returns (address) {
        return voters[voter].candidateAddress;
    }
}