// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleSoulBoundToken {
    address public admin;
    mapping(address => uint256) public sbt;

    event Minted(address indexed to, uint256 tokenId);
    event Burned(address indexed from, uint256 tokenId);
}