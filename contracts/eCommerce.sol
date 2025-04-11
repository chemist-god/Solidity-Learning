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

            //DECLARING ALL MY EVENTS
            // Event to emit when a product is added
            //Event to emit when a product is purchased
             /// Event to emit when a product is refunded

    event ProductAdded(uint256 id, string name, uint256 price, address seller);

    event ProductPurchased(uint256 id, address buyer);

    event ProductRefunded(uint256 id, address buyer);

    // Modifier to check if the caller is the seller of the product
    modifier onlySeller(uint256 _productId) {
        require(msg.sender == products[_productId].seller, "Not the seller");
        _;
    }

}