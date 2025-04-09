// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SoulboundNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    event Minted(address indexed to, uint256 tokenId, string uri);
    event Burned(uint256 tokenId);

    constructor() ERC721("SoulboundNFT", "SLB-NFT") Ownable() {}

    function safeMint(address to, string memory uri) public onlyOwner {
        require(to != address(0), "Invalid address: cannot mint to the zero address");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        emit Minted(to, tokenId, uri);
    }

    function unequip(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");
        _burn(tokenId);
        emit Burned(tokenId);
    }

    function revoke(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
        emit Burned(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual override {
        require(from == address(0) || to == address(0), "You are not allowed to transfer this NFT.");
    }
}