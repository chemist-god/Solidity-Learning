// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract BasicCalculator {
    uint256 public result;
    function add(uint256 a, uint256 b) internal  {
        result = a + b;
    }
    function subtract (uint256 a, uint256 b) internal {
        result = a -b;
    }
}

contract AdvanceCalculator is BasicCalculator {
    function multiply(uint256 a, uint256 b) internal {
        result = a*b;
    }
    function divide(uint256 a, uint256 b) internal {
        result = a /b;
    }

    function performOperations(uint256 a, uint256 b, uint8 operation) external{
        if (operation == 0) add(a, b);
        else if (operation == 1) subtract(a, b);
        else if (operation == 2) multiply(a, b);
        else if (operation == 3) divide(a, b);
        else revert("Invalid operation");
    }

}