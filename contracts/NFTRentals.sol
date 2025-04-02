// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTRental is Ownable {
    struct Rental {
        address renter;
        uint256 rentalPrice;
        uint256 rentalStart;
        uint256 rentalEnd;
        bool isActive;
    }

    mapping(uint256 => Rental) public rentals; // tokenId => Rental

    // Constructor that initializes the Ownable contract
    constructor() Ownable() {}

    function rentNFT(
        uint256 tokenId,
        address nftContract,
        uint256 rentalPrice,
        uint256 rentalDuration
    ) external payable {
        require(msg.value == rentalPrice, "Incorrect rental price");
        require(rentals[tokenId].isActive == false, "NFT is already rented");

        IERC721(nftContract).transferFrom(owner(), msg.sender, tokenId);

        rentals[tokenId] = Rental({
            renter: msg.sender,
            rentalPrice: rentalPrice,
            rentalStart: block.timestamp,
            rentalEnd: block.timestamp + rentalDuration,
            isActive: true
        });
    }

    function returnNFT(uint256 tokenId, address nftContract) external {
        Rental storage rental = rentals[tokenId];
        require(rental.isActive, "NFT is not rented");
        require(rental.renter == msg.sender, "You are not the renter");
        require(block.timestamp >= rental.rentalEnd, "Rental period not over");

        rental.isActive = false;
        IERC721(nftContract).transferFrom(msg.sender, owner(), tokenId);
        payable(msg.sender).transfer(rental.rentalPrice); // Refund the rental price
    }
}