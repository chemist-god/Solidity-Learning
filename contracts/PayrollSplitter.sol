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

    
}
