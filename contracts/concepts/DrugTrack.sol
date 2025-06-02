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

    function mintDrugBatch(
        string memory expiryDate,
        string memory manufacturer,
        string memory manufacturerSecret,
        string memory tokenURI
    ) external onlyOwner {
        uint256 tokenId = nextTokenId;
        drugBatches[tokenId] = DrugBatch(expiryDate, manufacturer, keccak256(abi.encodePacked(manufacturerSecret)));
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        nextTokenId++;
    }

    function verifyDrug(uint256 tokenId, string memory manufacturerSecret) external view returns (bool) {
        require(_exists(tokenId), "Drug batch does not exist");
        return drugBatches[tokenId].manufacturerSecretHash == keccak256(abi.encodePacked(manufacturerSecret));
    }
}
