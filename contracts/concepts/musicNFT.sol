// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SongNFT is ERC721, Ownable {
    using SafeMath for uint256;

    struct Song {
        string title;
        string artist;
        uint256 royaltyPercentage;
    }

    mapping(uint256 => Song) public songs;
    mapping(uint256 => address) public songOwners;
    uint256 private nextTokenId = 1;

    event SongMinted(uint256 indexed tokenId, string title, string artist, uint256 royaltyPercentage, address owner);
    event RoyaltiesDistributed(uint256 indexed tokenId, uint256 amount, address recipient);

    constructor() ERC721("SongNFT", "SNFT") {}

    function mintSong(string memory _title, string memory _artist, uint256 _royalty) public {
        require(_royalty <= 100, "Royalty percentage cannot exceed 100");
        uint256 tokenId = nextTokenId;
        songs[tokenId] = Song(_title, _artist, _royalty);
        songOwners[tokenId] = msg.sender;
        _safeMint(msg.sender, tokenId);
        nextTokenId++;

        emit SongMinted(tokenId, _title, _artist, _royalty, msg.sender);
    }

    
}
