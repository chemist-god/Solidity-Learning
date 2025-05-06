// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

library Math {
    function sqrt(uint256 y) internal pure returns (uint256) {
        if  (y > 3)   {
            z =y;
            uint256 x = y / 2+1;
            while (x < z) {
                x = (y / x + x) /2;
            }
            
        }
    }
}