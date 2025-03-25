// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Vote {
    struct Nominee {
        uint256 id;
        string name;
        string group;
        uint256 voteCount;
    }    

    mapping (uint256 => Nominee) public nominees;
    mapping(address => bool) public voters;
     
    uint256 public countNominees;
    uint256 public votingClose;
    uint256 public votingBegin;

    event NomineeAdded(uint256 id, string name, string group);
    event VoteCast(address indexed voter, uint256 nomineeId);
    event DatesSet(uint256 startDate, uint256 endDate);

    // Function to set the voting period
    function setVotingPeriod(uint256 _votingBegin, uint256 _votingClose) public {
        votingBegin = _votingBegin;
        votingClose = _votingClose;
    }

    function addNominee(string memory _name, string memory _group) 
        public returns (uint256) 
    {
        countNominees++;
        nominees[countNominees] = Nominee({
            id: countNominees,
            name: _name, 
            group: _group,
            voteCount: 0 
        });

        emit NomineeAdded(countNominees, _name, _group);
        return countNominees;
    }

    function vote(uint256 nomineeId) public {
        require(block.timestamp >= votingBegin, "Voting has not started yet");
        require(block.timestamp <= votingClose, "Vote Closed");
        require(nomineeId > 0 && nomineeId <= countNominees, "Invalid nominee ID");
        require(!voters[msg.sender], "You have already voted");

        // Mark the voter as having voted
        voters[msg.sender] = true;

        // Increment the vote count for the nominee
        nominees[nomineeId].voteCount++;

        // Emit an event for the vote
        emit VoteCast(msg.sender, nomineeId);
    }

    function checkVote() public view returns (bool) {  
        return voters[msg.sender];
    }

    function getCountNominee() public view returns(uint256) {
        return countNominees;
    }

    function getNominee(uint256 nomineeId) public view returns 
    (uint256, string memory, string memory, uint256) {
        return (nominees[nomineeId].id, nominees[nomineeId].name, nominees[nomineeId].group, nominees[nomineeId].voteCount);
    }

    function setDates(uint256 _startDate, uint256 _endDate) public {
        require(votingClose == 0 && votingBegin == 0, "Voting dates already set");
        require(_startDate > block.timestamp, "Start date must be in the future");
        require(_endDate > _startDate, "End date must be after start date");

        votingBegin = _startDate;
        votingClose = _endDate;

        emit DatesSet(_startDate, _endDate);
    }
    function getDates() public view returns (uint256) {
        return block.timestamp; // Get the current time
    }
}