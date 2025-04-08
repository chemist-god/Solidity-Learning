// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SoulboundNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("SoulboundNFT", "SLB-NFT") {}

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCOunter.current();
        _tokenIdCOunter.increment();
        _safeMint(to, tokenId);
    }


    function unequip(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "You are not thr ownerr of this NFT");
        _burn(tokenId);
    }

    function revoke(uint256) external onlyOwner {
        _burn(tokenId);
    }

    function_beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId;
        uint256 batchSize
    ) internal virtual override {
        
    }
}
