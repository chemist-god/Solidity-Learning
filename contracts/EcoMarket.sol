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

    //here we are defining a struct  for purchase tracking
    struct Purchase {
        address buyer;
        uint256 pricePaid;
        uint256 timestamp;
    }
    mapping(uint256 => mapping(address => Purchase)) public purchases;
    mapping(uint256 => mapping(address => bool)) public refunded;

    //now we defining our events
    event ProductAdded(uint256 id, string name, uint256 price);
    event ProductPurchased(uint256 id, address buyer);
    event RefundProcessed(uint256 id, address buyer);
}