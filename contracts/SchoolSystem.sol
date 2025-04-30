// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Parent {
    function sayHello() public  pure returns (string memory) {
        return "Hello from Parent";
    }
}