// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract EcoMarket {
    // Struct for product details
    struct Product {
        uint256 id;
        string name;
        uint256 price;
        Status status;
    }

    // Enum for product status
    enum Status { Available, Sold }
}