// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract EcoMarket {
   // we are setting role based management
    // Role management
    enum Role { User, Admin }
    mapping(address => Role) public roles;

    // Product management
    struct Product {
        uint256 id;
        string name;
        uint256 price;
        Status status;
    }
    enum Status { Available, Sold }
    mapping(uint256 => Product) public products;
    uint256 public productId;
}