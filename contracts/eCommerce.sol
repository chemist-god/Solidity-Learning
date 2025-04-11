// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Ecommerce {

    struct Product {
        uint256 id;
        string name;
        string description;
        uint256 price; // this price in wei
        address payable seller;
        bool isAvailable;
    }

    // in this i am mapping to store products by their ID
    mapping(uint256 => Product) public products;
    // a counter for product IDs
    uint256 public productCount;

}