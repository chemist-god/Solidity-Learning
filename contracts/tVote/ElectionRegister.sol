// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract ElectionRegistration {
    struct Candidate {
        string name;
        uint256 age;
        string idDocumentHash; // IPFS or File hash of the document
        string additionalInfo;
        bool isRegistered;
        bool approved;
        bool exists;
    }

    address public electionManager;
    mapping(address => Candidate) public candidates;
    address[] public candidateAddresses;

    event CandidateRegistered(address indexed candidateAddress, string name);
    event CandidateApproved(address indexed candidateAddress, string message);
    event CandidateRejected(address indexed candidateAddress, string reason);

    modifier onlyElectionManager() {
        require(msg.sender == electionManager, "Only Election Manager can perform this action");
        _;
    }

    constructor() {
        electionManager = msg.sender;
    }

                //here the user will 
    // Register as a candidate.
     // _name Name of the candidate
     // _age Age of the candidate
     // _idDocumentHash Hash of the uploaded ID document (e.g., from IPFS)
     // _additionalInfo Any extra info
     
    function registerCandidate(
        string memory _name,
        uint256 _age,
        string memory _idDocumentHash,
        string memory _additionalInfo
    ) public {
        require(!candidates[msg.sender].exists, "Already registered");

        candidates[msg.sender] = Candidate({
            name: _name,
            age: _age,
            idDocumentHash: _idDocumentHash,
            additionalInfo: _additionalInfo,
            isRegistered: false,
            approved: false,
            exists: true
        });

        candidateAddresses.push(msg.sender);

        emit CandidateRegistered(msg.sender, _name);
    }

                 // here we approve
    //  a candidate
     //  _candidateAddress Address of the candidate
     //  _message Optional message to send with approval
    
    function approveCandidate(address _candidateAddress, string memory _message)
        public
        onlyElectionManager
    {
        require(candidates[_candidateAddress].exists, "Candidate does not exist");
        require(!candidates[_candidateAddress].approved, "Already approved");

        candidates[_candidateAddress].approved = true;
        candidates[_candidateAddress].isRegistered = true;

        emit CandidateApproved(_candidateAddress, _message);
    }

                          //this function here a candiate is rejected 
    // Reject a candidate
     //  _candidateAddress Address of the candidate
     //  _reason Reason for rejection
     
    function rejectCandidate(address _candidateAddress, string memory _reason)
        public
        onlyElectionManager
    {
        require(candidates[_candidateAddress].exists, "Candidate does not exist");
        require(!candidates[_candidateAddress].approved, "Already approved");

        candidates[_candidateAddress].approved = false;
        candidates[_candidateAddress].isRegistered = false;

        emit CandidateRejected(_candidateAddress, _reason);
    }

}