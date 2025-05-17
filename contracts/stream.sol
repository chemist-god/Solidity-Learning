// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract StreamChain is ERC721 {
    uint256 public nextVideoId;
    address public usdc;
    mapping(uint256 => string) private _videoIPFSHashes;
    mapping(uint256 => uint256) public videoPrice;

    event VideoMinted(uint256 indexed videoId, address creator, string ipfsHash);
    event VideoPurchased(uint256 indexed videoId, address buyer);

    constructor(address _usdc) ERC721("StreamChain", "STRM") {
        usdc = _usdc;
    }

    function mintVideo(string memory ipfsHash, uint256 price) external {
        uint256 videoId = nextVideoId++;
        _mint(msg.sender, videoId);
        _videoIPFSHashes[videoId] = ipfsHash;
        videoPrice[videoId] = price;
        emit VideoMinted(videoId, msg.sender, ipfsHash);
    }

    function purchaseVideo(uint256 videoId) external {
        require(_exists(videoId), "Video does not exist");
        IUSDC(usdc).transferFrom(msg.sender, ownerOf(videoId), videoPrice[videoId]);
        _transfer(ownerOf(videoId), msg.sender, videoId); // Transfer NFT access
        emit VideoPurchased(videoId, msg.sender);
    }
}