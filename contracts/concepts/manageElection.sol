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

}