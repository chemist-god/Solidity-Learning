

// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// this defines the FoodDelivery contract
contract FoodDelivery {
    // Enum to represent the status of an order
    enum OrderStatus { Pending, Accepted, Delivered, Canceled }

    // Struct to represent an order
    struct Order {
        uint256 id;                // Unique identifier for the order
        address customer;          // Address of the customer who placed the order
        string foodItem;          // Description of the food item ordered
        uint256 price;            // Price of the order in wei (smallest unit of Ether)
        OrderStatus status;       // Current status of the order
        uint256 timestamp;        // Time when the order was placed
    }

    // State variable to keep track of the total number of orders
    uint256 public orderCount;

    // Mapping to store orders by their unique ID
    mapping(uint256 => Order) public orders;

    // Events to log important actions
    event OrderPlaced(uint256 indexed orderId, address indexed customer, string foodItem, uint256 price);
    event OrderAccepted(uint256 indexed orderId);
    event OrderDelivered(uint256 indexed orderId);
    event OrderCanceled(uint256 indexed orderId);

    // Modifier to ensure that only the customer can call certain functions
    modifier onlyCustomer(uint256 orderId) {
        require(msg.sender == orders[orderId].customer, "Not the customer");
        _; // Continue execution of the function
    }

    // Modifier to ensure that the order is still pending
    modifier onlyPending(uint256 orderId) {
        require(orders[orderId].status == OrderStatus.Pending, "Order not pending");
        _; // Continue execution of the function
    }

    // Function to place a new order
    function placeOrder(string memory foodItem) external payable {
        // Ensure that the order has a price (must send Ether)
        require(msg.value > 0, "Order must have a price");
    
    // Increment the order count to get a new order ID
        orderCount++;

    // Create a new order and store it in the mapping
        orders[orderCount] = Order({
            id: orderCount,
            customer: msg.sender,    // Set the customer to the address that called the function
            foodItem: foodItem,      // Set the food item
            price: msg.value,        // Set the price to the amount of Ether sent
            status: OrderStatus.Pending, // Set the initial status to Pending
            timestamp: block.timestamp // Record the time of order placement
        });

     //Emit an event to log the order placement
        emit OrderPlaced(orderCount, msg.sender, foodItem, msg.value);
    }
    // Function to accept a pending order
    function acceptOrder(uint256 orderId) external onlyPending(orderId) {
        // Change the order status to Accepted
        orders[orderId].status = OrderStatus.Accepted;
        // Emit an event to log the order acceptance
        emit OrderAccepted(orderId);
    }

    // Function to mark an order as delivered
    function deliverOrder(uint256 orderId) external onlyPending(orderId) {
        // Change the order status to Delivered
        orders[orderId].status = OrderStatus.Delivered;
        // Emit an event to log the order delivery
        emit OrderDelivered(orderId);
    }

    // Function to cancel an order
    function cancelOrder(uint256 orderId) external onlyCustomer(orderId) onlyPending(orderId) {
        // Change the order status to Canceled
        orders[orderId].status = OrderStatus.Canceled;
        // Refund the customer by sending back the Ether they paid
        payable(msg.sender).transfer(orders[orderId].price);
        // Emit an event to log the order cancellation
        emit OrderCanceled(orderId);
    }

}

