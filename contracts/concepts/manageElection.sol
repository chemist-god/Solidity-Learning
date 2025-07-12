// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ElectionManage is Ownable {
    uint public electionCount;
    bytes32 public immutable contractVersion = keccak256("TRUSTVOTE_V2");
    address public immutable deployer;

    event ElectionCreated(
        uint indexed id,
        string name,
        string description,
        uint startDate,
        uint endDate,
        string bannerUrl,
        address indexed createdBy,
        uint chainId
    );

    event ContractDeployed(bytes32 indexed version, address indexed deployer);

    constructor() Ownable(msg.sender) {
        deployer = msg.sender;
        emit ContractDeployed(contractVersion, deployer);
    }

    function createElection(
        string memory _name,
        string memory _description,
        uint _startDate,
        uint _endDate,
        string memory _bannerUrl
    ) public onlyOwner {
        require(bytes(_name).length > 0, "Name required");
        require(_startDate > block.timestamp, "Start date must be future");
        require(_startDate < _endDate, "Start must be before end");

        electionCount++;
        emit ElectionCreated(
            electionCount,
            _name,
            _description,
            _startDate,
            _endDate,
            _bannerUrl,
            msg.sender,
            block.chainid  // Critical for multi-chain support
        );
    }

    // V2+: Removed storage-heavy functions (getAllElectionIds etc)
    // Frontend should query events instead
}