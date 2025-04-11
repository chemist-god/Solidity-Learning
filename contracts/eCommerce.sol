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

    // Function to add a new product
    function addProduct(string memory _name, string memory _description, uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");

        productCount++;
        products[productCount] = Product(productCount, _name, _description, _price, payable(msg.sender), true);

        emit ProductAdded(productCount, _name, _price, msg.sender);
    }

    // Function to purchase a product
    function purchaseProduct(uint256 _productId) public payable {
        Product storage product = products[_productId];
        require(product.isAvailable, "Product not available");
        require(msg.value == product.price, "Incorrect price sent");

        // Transfer funds to the seller
        product.seller.transfer(msg.value);
        product.isAvailable = false; // Mark product as sold

        emit ProductPurchased(_productId, msg.sender);
    }

    // Function to refund a product (only the seller can refund)
    function refundProduct(uint256 _productId) public onlySeller(_productId) {
        Product storage product = products[_productId];
        require(!product.isAvailable, "Product is still available");

        // Refund logic 
        //(for simplicity, i assume the buyer is the seller)
        product.isAvailable = true; //  this marks product as available again

        emit ProductRefunded(_productId, msg.sender);
    }

}