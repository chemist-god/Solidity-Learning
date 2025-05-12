// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract SelfDestructSender {
    address payable public vault = payable(0x5B9AFe590174Cddd1C99374DEC490A87f4D04776);

    constructor() payable {
        require(msg.value == 0.0005 ether, "Must send exactly 0.0005 ether");
        selfdestruct(vault);
    }
    
}
