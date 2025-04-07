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
    uint256 public  nextOrderId = 1;
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

    // Order Placement
    function placeOrder(address _restaurant, uint256[] memory _itemIds) external payable onlyCustomer {
        require(restaurants[_restaurant].isRegistered, "Invalid restaurant.");
        uint256 totalAmount = 0;

        for (uint256 i = 0; i < _itemIds.length; i++) {
            MenuItem memory item = menus[_restaurant][_itemIds[i]];
            require(item.isAvailable, "One or more items are unavailable.");
            totalAmount += item.price;
        }

        require(msg.value == totalAmount, "Incorrect payment amount.");

        uint256 orderId = nextOrderId++;
        //used a positional argument
        orders[orderId] = Order(
            orderId,
            msg.sender,
             totalAmount,
             _itemIds,
             OrderStatus.Placed,
             _restaurant,
            block.timestamp
        );

        customerOrders[msg.sender].push(orderId);
        emit OrderPlaced(orderId, msg.sender, _restaurant, totalAmount);
    }
    //order status 
    function updateOrderStatus(uint256 _orderId, OrderStatus _newStatus) external onlyRegisteredRestaurant {
        Order storage order = orders[_orderId];
        require(order.restaurant == msg.sender, "Only restaurant can update order status");
        order.status = _newStatus;
        emit OrderStatusUpdated(_orderId, _newStatus);
    }

    //withdraw Funds
    function withdrawFunds() external onlyRegisteredRestaurant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(msg.sender).transfer(balance);
    }

    //read data without changing data on blockchain
    function getRestaurantDetails(address _restaurant) external view returns (string memory, string memory, uint256, bool) {
        Restaurant memory restaurant = restaurants[_restaurant];
        return ( restaurant.name, restaurant.location, restaurant.registrationTime, restaurant.isRegistered);
    }
    
}