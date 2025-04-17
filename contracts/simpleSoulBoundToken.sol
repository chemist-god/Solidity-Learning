// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleSoulBoundToken {
    address public admin;
    mapping(address => uint256) public sbt;

    event Minted(address indexed to, uint256 tokenId);
    event Burned(address indexed from, uint256 tokenId);

    // Set deployer as admin
    constructor() {
        admin = msg.sender;
    }

    // Mint new SBT to an address (admin only)
    function mint(address to, uint256 tokenId) external {
        require(msg.sender == admin, "Only admin");
        require(to != address(0), "Zero address");
        require(sbt[to] == 0, "Already has SBT");
        
        sbt[to] = tokenId;
        emit Minted(to, tokenId);
    }


}