// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract MarketChain {
    address public admin;

    enum Role { Importer, Reseller }
    enum Status { Listed, Sold, Disputed }

    struct Participant {
        Role role;
        bool isRegistered;
        uint reputation;
    }

    struct Item {
        string name;
        uint basePrice;
        address currentOwner;
        Status status;
    }

    mapping(address => Participant) public participants;
    mapping(uint => Item) public items;
    uint public itemCount;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    modifier onlyRegistered() {
        require(participants[msg.sender].isRegistered, "Not registered");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function register(Role _role) external {
        participants[msg.sender] = Participant(_role, true, 0);
    }

    function listItem(string memory _name, uint _basePrice) external onlyRegistered {
        require(participants[msg.sender].role == Role.Importer, "Only importers can list");
        items[itemCount] = Item(_name, _basePrice, msg.sender, Status.Listed);
        itemCount++;
    }

    function buyItem(uint _itemId) external payable onlyRegistered {
        Item storage item = items[_itemId];
        require(item.status == Status.Listed, "Item not available");
        require(msg.value >= item.basePrice, "Insufficient payment");

        address seller = item.currentOwner;
        item.currentOwner = msg.sender;
        item.status = Status.Sold;
        participants[msg.sender].reputation++;
        payable(seller).transfer(msg.value);
    }

    function flagDispute(uint _itemId) external onlyRegistered {
        require(items[_itemId].currentOwner == msg.sender, "Not item owner");
        items[_itemId].status = Status.Disputed;
    }
}
