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

}