// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SongNFT is ERC721URIStorage, Ownable {
    using SafeMath for uint256;

    uint256 private _currentTokenId;
    uint256 public nftPrice;
    address public artist;
    string public audioURI;
    uint256 public royaltyBalance;
    string public coverURI;

    struct NFTInfo {
        uint256 nftPrice;
        address artist;
        string audioURI;
        string coverURI;
        uint256 royaltyBalance;
        uint256 currentTokenId;
    } 

    uint256 public constant ROYALTY_PERCENTAGE = 30;

    event NFTMinted(uint256 indexed tokenId, address indexed buyer, uint256 price);
    event RoyaltyCollected(uint256 indexed tokenId, uint256 amount);
    event RoyaltyPaid(address indexed artist, uint256 amount);

    modifier onlyMintedUser(address user) {
        require(balanceOf(user) > 0, "Don't own the NFT");
        _;
    }

    
}