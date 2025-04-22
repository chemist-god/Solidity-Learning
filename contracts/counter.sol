// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Counter {
    uint256 public count; // Public variable to store the count

    // Function to increment the count by 1
    function increment() public {
        count += 1;
    }

    // (Optional) Function to reset the count to 0
    function reset() public {
        count = 0;
    }
}