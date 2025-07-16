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

}