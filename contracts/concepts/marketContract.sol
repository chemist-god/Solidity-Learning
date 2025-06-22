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

    // --- State Variables ---
    uint private nextProductId; // Next product's ID number
    uint private nextSaleId;    // Next sale's ID number

    // Store all products and sales by their IDs
    mapping(uint => Product) public products;
    mapping(uint => Sale) public sales;

    // Track which products each seller listed
    mapping(address => uint[]) public sellerProducts;
    // Track which sales each buyer made
    mapping(address => uint[]) public buyerSales;

    // --- Events ---
    // Let outside apps know when something happens
    event ProductAdded(uint id, address seller, string name, uint price);
    event ProductPurchased(uint saleId, uint productId, address buyer, uint pricePaid, string purpose);

    // --- Modifiers ---
    // Only let the seller of a product do certain things
    modifier onlySeller(uint _productId) {
        require(products[_productId].seller == msg.sender, "You are not the seller.");
        _;
    }

    // Set up the contract: whoever deploys it is the owner, and start IDs at 1
    constructor() {
        owner = msg.sender;
        nextProductId = 1;
        nextSaleId = 1;
    }

    
}
