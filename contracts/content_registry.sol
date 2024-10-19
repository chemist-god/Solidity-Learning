
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ContentRegistry {
    struct Content {
        uint id;
        address creator;
        string ipfsCID;
        uint price;
        bool isActive;
    }

    uint public contentCount = 0;
    mapping(uint => Content) public contents;

    event ContentAdded(uint id, address creator, string ipfsCID, uint price);
    event ContentDeactivated(uint id);

    function addContent(string memory _ipfsCID, uint _price) public {
        contentCount++;
        contents[contentCount] = Content(contentCount, msg.sender, _ipfsCID, _price,)


    }
}
