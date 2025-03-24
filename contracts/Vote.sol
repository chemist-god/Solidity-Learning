// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

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

    // Function to set the voting period
    function setVotingPeriod(uint256 _votingBegin, uint256 _votingClose) public {
        // Consider adding access control here
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
    function checkVote() public view returns (bool)
    {  
        return voters[msg.sender];
    }
}