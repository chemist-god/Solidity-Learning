// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreatorToken is ERC20, Ownable {
    address public artNFTContract;
    uint256 public constant REWARD_PER_MINT = 100 * 10 ** 18;

    modifier onlyArtNFT() {
        require(msg.sender == artNFTContract, "Caller is not authorized NFT contract");
        _;
    }

    constructor() ERC20("CreatorToken", "CRT") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    function setArtNFT(address _artNFT) external onlyOwner {
        require(_artNFT != address(0), "Invalid NFT contract address");
        artNFTContract = _artNFT;
    }

    function rewardCreator(address creator) external onlyArtNFT {
        require(creator != address(0), "Invalid creator address");
        _mint(creator, REWARD_PER_MINT);
    }
}

