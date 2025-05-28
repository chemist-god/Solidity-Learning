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

    function distributeRoyalties(uint256 tokenId) public payable {
        require(_exists(tokenId), "Token does not exist");
        require(msg.value > 0, "Payment amount must be greater than zero");
        
        address owner = ownerOf(tokenId);
        uint256 royaltyAmount = msg.value.mul(songs[tokenId].royaltyPercentage).div(100);
        payable(owner).transfer(royaltyAmount);

        emit RoyaltiesDistributed(tokenId, royaltyAmount, owner);
    }

    function transferSong(address _to, uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        _transfer(msg.sender, _to, tokenId);
    }

    function getSongDetails(uint256 tokenId) public view returns (string memory, string memory, uint256) {
        require(_exists(tokenId), "Token does not exist");
        Song memory song = songs[tokenId];
        return (song.title, song.artist, song.royaltyPercentage);
    }
}
