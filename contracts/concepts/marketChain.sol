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

    
}
