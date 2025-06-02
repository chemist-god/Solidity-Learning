// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DrugBatchNFT is ERC721URIStorage, Ownable {
    struct DrugBatch {
        string expiryDate;
        string manufacturer;
        bytes32 manufacturerSecretHash; // Hashed secret for verification
    }

    mapping(uint256 => DrugBatch) public drugBatches;
    uint256 public nextTokenId;

    constructor() ERC721("DrugBatchNFT", "DBNFT") {}

   
}
