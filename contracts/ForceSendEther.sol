// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract ForceSendEther {
    address payable public vault = payable(0x5B9AFe590174Cddd1C99374DEC490A87f4D04776);

    constructor() payable {
        require(msg.value == 0.0005 ether, "Must send exactly 0.0005 ether");
        (bool success, ) = vault.call{value: msg.value}("");
        require(success, "Failed to send Ether");
    }
}