// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./CreatorToken.sol";

contract ArtNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    CreatorToken public creatorToken;
    mapping(uint256 => address) private tokenCreators;

    event NFTMinted(address indexed creator, uint256 indexed tokenId, string tokenURI);

    constructor(address tokenAddress) ERC721("ArtNFT", "ART") Ownable(msg.sender) {
        require(tokenAddress != address(0), "Invalid CreatorToken address");
        creatorToken = CreatorToken(tokenAddress);
    }

    function mintNFT(string calldata _tokenURI) external {
        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        tokenCreators[newTokenId] = msg.sender;

        creatorToken.rewardCreator(msg.sender);

        emit NFTMinted(msg.sender, newTokenId, _tokenURI);
    }

    function getCreator(uint256 tokenId) external view returns (address) {
    return tokenCreators[tokenId];
    }
}
