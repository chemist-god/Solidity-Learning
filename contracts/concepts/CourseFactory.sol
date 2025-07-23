// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ==================== Certificate NFT (ERC-721) ====================
contract CertificateNFT is ERC721, Ownable {
    uint256 private _tokenIdCounter;
    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("CourseCertificate", "CERT") {}

    function mintCertificate(address to, string memory tokenURI) external onlyOwner returns (uint256) {
        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;
        _mint(to, newTokenId);
        _tokenURIs[newTokenId] = tokenURI;
        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Non-existent token");
        return _tokenURIs[tokenId];
    }
}

// ==================== Reward Token (ERC-20) ====================
contract RewardToken is ERC20, Ownable {
    constructor() ERC20("CourseRewardToken", "CRT") {
        _mint(msg.sender, 1_000_000 * 10**18); // Mint initial supply to deployer
    }

    function rewardUser(address user, uint256 amount) external onlyOwner {
        _transfer(owner(), user, amount);
    }
}

