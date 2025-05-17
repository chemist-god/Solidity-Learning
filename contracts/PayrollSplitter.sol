// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MultiRolePaymentSplitter {
    // Define user roles using an Enum
    enum UserRole { User, Admin, Merchant }

    // Struct to store user details
    struct User {
        address userAddress;
        UserRole role;
        uint256 balance;
    }

    // Mapping to store registered users
    mapping(address => User) public users;

    // Modifier to ensure only Admins can execute certain functions
    modifier onlyAdmin() {
        require(users[msg.sender].role == UserRole.Admin, "Not an Admin");
        _;
    }

    // Modifier to check user registration
    modifier onlyRegistered() {
        require(users[msg.sender].userAddress != address(0), "Not registered");
        _;
    }

    
}
