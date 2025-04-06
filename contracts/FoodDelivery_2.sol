// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract FoodDelivery {
    //structs
    struct Restaurant {
        string name;
        string location;
        uint256 registrationTime;
        bool isRegistered;
    }

    // Restaurant menu items
    struct MenuItem{
        string name;
        uint256 price;
        bool isAvailable;
    }

    //Order
    struct Order {
        uint256 OrderId;
        address customer;
        uint256 totalAmount;
        uint256[] itemsIds;
        OrderStatus status;
        address restaurant;
        uint256 timestamp; 
    }
    enum OrderStatus {
        Placed,
        Preparing,
        OutForDelivery,
        Delivered
    }

    // state variables  to keep track of order
    uint256 public  nextOrder = 1;
    mapping(address => Restaurant) public restaurants;
    mapping(address => mapping(uint256 => MenuItem)) public menus;
    mapping(uint256 => Order) public orders;
    mapping(address => uint256[]) public customerOrders;
    
    //Events
    event RestaurantRegistered(address indexed restaurant, string name);
    event MenuItemAdded(address indexed restaurant, uint256 itemId, string itemName, uint256 price);
    event OrderPlaced(uint256 indexed orderId, address indexed customer, address indexed restaurant, uint256 totalAmount);
    event OrderStatusUpdated(uint256 indexed orderId, OrderStatus newStatus);

    // Modifiers
    modifier onlyRegisteredRestaurant() {
        require(restaurants[msg.sender].isRegistered, "Only registered restaurants can perform this action.");
        _;
    }

    modifier onlyCustomer() {
        require(!restaurants[msg.sender].isRegistered, "Restaurants cannot place orders.");
        _;
    }

    // Restaurant Registration
    function registerRestaurant(string memory _name, string memory _location) external {
        require(!restaurants[msg.sender].isRegistered, "Restaurant is already registered.");
        restaurants[msg.sender] = Restaurant({
            name: _name,
            location: _location,
            registrationTime: block.timestamp,
            isRegistered: true
        });
        emit RestaurantRegistered(msg.sender, _name);
    }

    // Menu Management
    function addMenuItem(uint256 _itemId, string memory _itemName, uint256 _price) external onlyRegisteredRestaurant {
        require(_price > 0, "Price must be greater than zero.");
        menus[msg.sender][_itemId] = MenuItem({
            name: _itemName,
            price: _price,
            isAvailable: true
        });
        emit MenuItemAdded(msg.sender, _itemId, _itemName, _price);
    }
    function updateMenuItemAvailability(uint256 _itemId, bool _isAvailable) external onlyRegisteredRestaurant {
        require(menus[msg.sender][_itemId].price > 0, "Item does not exist.");
        menus[msg.sender][_itemId].isAvailable = _isAvailable;
    }
}