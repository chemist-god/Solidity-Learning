// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TithePayment {
    address public church;
    mapping(address => uint256) public tithes;
    
    event TithePaid(address indexed payer, uint256 amount);
    
    constructor(address _church) {
        church = _church;
    }

    modifier onlyFirstSunday() {
        require(
            block.timestamp % 2592000 < 86400, // Approximate check for first Sunday (2592000 seconds in a month)
            "Payments only allowed on the first Sunday"
        );
        _;
    }

    
}
