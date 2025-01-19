// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CharityDonation {
    address public admin; // Admin who controls the contract

    // Charity structure to manage donations
    struct Charity {
        uint256 id;          // Charity ID
        address receiver;    // Receiver of the charity funds
        uint256 maxAmount;   // Maximum amount requested
        uint256 collected;   // Amount collected so far
        uint256 balance;     // Current balance available for withdrawal
        bool status;         // Status of the charity request (active/inactive)
    }

    mapping(uint256 => Charity) public charityRequests;      // Store charity requests by ID
    mapping(uint256 => Donation[]) public charityDonations;  // Store donations by charity ID
    uint256 public charityCount;                             // Track the number of charity requests

    struct Donation {
        address donor;
        uint256 amount;
        uint256 timestamp;
    }

    event CharityCreated(uint256 indexed charityId, address indexed receiver, uint256 maxAmount);
    event DonationReceived(uint256 indexed charityId, address indexed donor, uint256 amount);
    event FundsWithdrawn(uint256 indexed charityId, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action.");
        _;
    }

    modifier onlyAdminOrReceiver(uint256 _charityId) {
        require(
            msg.sender == admin || msg.sender == charityRequests[_charityId].receiver,
            "Only the admin or the assigned receiver can perform this action."
        );
        _;
    }

    modifier onlyReceiver(uint256 _charityId) {
        require(msg.sender == charityRequests[_charityId].receiver, "Only the assigned receiver can perform this action.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Function to create a new charity request
    function createCharityRequest(
        uint256 _charityId,
        address _receiver,
        uint256 _maxAmount
    ) public onlyAdmin {
        require(_receiver != address(0), "Receiver address cannot be zero.");
        require(_maxAmount > 0, "Maximum amount must be greater than zero.");
        require(charityRequests[_charityId].id == 0, "Charity ID already exists."); // Ensure unique charity ID

        // Increment the charity count
        charityCount++;

        // Create and store the charity
        charityRequests[_charityId] = Charity({
            id: _charityId,
            receiver: _receiver,
            maxAmount: _maxAmount,
            collected: 0,
            balance: 0,
            status: true
        });

        emit CharityCreated(_charityId, _receiver, _maxAmount);
    }

    // Function to allow donations to a specific charity request
    // Function to allow donations to a specific charity request
function donate(uint256 _charityId, uint256 _amount) public payable {
    require(_charityId > 0 && charityRequests[_charityId].id != 0, "Invalid charity ID.");
    Charity storage charity = charityRequests[_charityId];
    require(charity.status, "Charity request is not active.");
    require(_amount > 0, "Donation amount must be greater than zero.");
    require(charity.collected + _amount <= charity.maxAmount, "Donation exceeds required amount.");

    charity.collected += _amount;
    charity.balance += _amount;

    // Log the donation
    charityDonations[_charityId].push(Donation({
        donor: msg.sender,
        amount: _amount,
        timestamp: block.timestamp
    }));

    emit DonationReceived(_charityId, msg.sender, _amount);
}


    // Function to allow the admin or receiver to withdraw funds from a specific charity request
    function withdraw(uint256 _charityId, uint256 _amount) public onlyReceiver(_charityId) payable {
    require(_charityId > 0 && charityRequests[_charityId].id != 0, "Invalid charity ID.");
    Charity storage charity = charityRequests[_charityId];
    require(_amount > 0, "Withdrawal amount must be greater than zero.");
    require(_amount <= charity.balance, "Insufficient balance.");

    charity.balance -= _amount;

    // Send funds to the charity's receiver
    (bool success, ) = charity.receiver.call{value: _amount}("");
    require(success, "Withdrawal failed.");

    emit FundsWithdrawn(_charityId, _amount);
}


    // Function to check the contract balance for a specific charity (Admin or Receiver only)
    function getContractBalance(uint256 _charityId) public view onlyAdminOrReceiver(_charityId) returns (uint256) {
        require(_charityId > 0 && charityRequests[_charityId].id != 0, "Invalid charity ID.");
        return charityRequests[_charityId].balance;
    }

    // Function to get all donations for a specific charity (Admin only)
    function getDonations(uint256 _charityId) public view onlyAdmin returns (Donation[] memory) {
        require(_charityId > 0 && charityRequests[_charityId].id != 0, "Invalid charity ID.");
        return charityDonations[_charityId];
    }
}