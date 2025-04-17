// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Example Solidity Code for SBT Minting
contract SoulBoundToken {
    mapping(address => bool) public hasSBT;
    event SBTMinted(address indexed student, uint256 tokenId);

    function mintSBT(address student, uint256 tokenId) external {
        require(!hasSBT[student], "Student already has an SBT");
        hasSBT[student] = true;
        emit SBTMinted(student, tokenId);
    }
}