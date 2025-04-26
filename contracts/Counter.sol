// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Counter {
    uint256 public count;

    // Function to get the current count
    function get() public view returns (uint256) {
        return count;
    }

    // Function to increment count by 1
    function inc() public {
        count += 1;
    }

    // Function to decrement count by 1
    function dec() public {
        // Prevent underflow
        require(count > 0, "Counter: cannot decrement below zero");
        count -= 1;
    }

    // Function to reset count to zero
    function reset() public {
        count = 0;
    }
}