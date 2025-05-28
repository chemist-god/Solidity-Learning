// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreatorPlatform is ERC20, ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    // Token counters
    Counters.Counter private _tokenIdCounter;

    // Constants
    uint256 public constant MINT_REWARD = 100 * 10**18; // 100 CreatorTokens
    uint256 public constant MAX_SUPPLY = 100_000 * 10**18; // 100k max supply

    // Storage
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => address) private _creators;
    uint256 private _totalMintedTokens;

    // Events
    event NFTCreated(
        uint256 indexed tokenId,
        address indexed creator,
        string tokenURI,
        uint256 timestamp
    );
    event CreatorRewarded(
        address indexed creator,
        uint256 indexed tokenId,
        uint256 amount,
        uint256 timestamp
    );

    constructor() 
        ERC20("CreatorToken", "CRT")
        ERC721("ArtNFT", "ART")
    {
        // Mint initial supply to contract (optional)
        // _mint(address(this), MAX_SUPPLY / 2);
    }

    // Combined interface support
    function supportsInterface(bytes4 interfaceId) public view override(ERC20, ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // NFT Minting Function
    function mintNFT(string memory tokenURI) public returns (uint256) {
        require(bytes(tokenURI).length > 0, "Empty URI");

        uint256 newTokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        _safeMint(msg.sender, newTokenId);
        _tokenURIs[newTokenId] = tokenURI;
        _creators[newTokenId] = msg.sender;

        // Reward creator
        _rewardCreator(msg.sender, MINT_REWARD);

        emit NFTCreated(newTokenId, msg.sender, tokenURI, block.timestamp);
        return newTokenId;
    }

    // Internal reward function with supply check
    function _rewardCreator(address to, uint256 amount) internal {
        require(_totalMintedTokens + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
        _totalMintedTokens += amount;
        emit CreatorRewarded(to, _tokenIdCounter.current() - 1, amount, block.timestamp);
    }

    // Get creator of NFT
    function getCreator(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "Nonexistent token");
        return _creators[tokenId];
    }

    // Override tokenURI to include stored URIs
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Nonexistent token");
        return _tokenURIs[tokenId];
    }

    // Admin function to mint additional tokens (if needed)
    function adminMint(address to, uint256 amount) external onlyOwner {
        _rewardCreator(to, amount);
    }

    // Get total minted tokens
    function totalMinted() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    // Get total minted CreatorTokens
    function totalCreatorTokens() public view returns (uint256) {
        return _totalMintedTokens;
    }
}