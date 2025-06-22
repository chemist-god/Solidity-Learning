// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// This contract lets people list products for sale and buy them, keeping track of who bought what and why.
contract CommunityMarket {
    // The person who deployed the contract (the admin)
    address public owner;

    // Information about a product for sale
    struct Product {
        uint id;            // Product's unique number
        address seller;     // Who is selling this product
        string name;        // What is the product called
        uint price;         // How much does it cost (in Wei)
        bool isAvailable;   // Is it still for sale?
    }

    // Information about a completed sale
    struct Sale {
        uint saleId;        // Unique number for this sale
        uint productId;     // Which product was sold
        address seller;     // Who sold it
        address buyer;      // Who bought it
        uint pricePaid;     // How much was paid
        uint timestamp;     // When did the sale happen
        string purpose;     // Why did the buyer buy it (e.g. personal use, resale)
    }

    
}
