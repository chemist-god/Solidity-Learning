// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract EcoMarket {
   // we are setting role based management
    // Role management
    enum Role { User, Admin }
    mapping(address => Role) public roles;
}