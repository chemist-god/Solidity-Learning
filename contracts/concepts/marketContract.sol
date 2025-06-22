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

    // Anyone can add a product for sale
    function addProduct(string memory _name, uint _price) public {
        uint productId = nextProductId++;
        products[productId] = Product(productId, msg.sender, _name, _price, true);
        sellerProducts[msg.sender].push(productId);
        emit ProductAdded(productId, msg.sender, _name, _price);
    }

    // Anyone can buy a product by sending enough Ether and stating why they are buying
    function purchaseProduct(uint _productId, string memory _purpose) public payable {
        Product storage product = products[_productId];
        require(product.seller != address(0), "Product does not exist.");
        require(product.isAvailable, "Product is not for sale.");
        require(msg.value >= product.price, "Not enough payment.");

        // Pay the seller
        payable(product.seller).transfer(msg.value);

        // (If you want to make products unique, set isAvailable to false here)

        uint saleId = nextSaleId++;
        sales[saleId] = Sale(saleId, _productId, product.seller, msg.sender, msg.value, block.timestamp, _purpose);
        buyerSales[msg.sender].push(saleId);

        emit ProductPurchased(saleId, _productId, msg.sender, msg.value, _purpose);
    }

    // Get info about a product by its ID
    function getProduct(uint _productId) public view returns (uint id, address seller, string memory name, uint price, bool isAvailable) {
        Product storage product = products[_productId];
        return (product.id, product.seller, product.name, product.price, product.isAvailable);
    }

    // Get info about a sale by its ID
    function getSale(uint _saleId) public view returns (uint saleId, uint productId, address seller, address buyer, uint pricePaid, uint timestamp, string memory purpose) {
        Sale storage sale = sales[_saleId];
        return (sale.saleId, sale.productId, sale.seller, sale.buyer, sale.pricePaid, sale.timestamp, sale.purpose);
    }

    // Get all products a seller has listed
    function getProductsBySeller(address _sellerAddress) public view returns (uint[] memory) {
        return sellerProducts[_sellerAddress];
    }

    // Get all sales a buyer has made
    function getSalesByBuyer(address _buyerAddress) public view returns (uint[] memory) {
        return buyerSales[_buyerAddress];
    }
}
