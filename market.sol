// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketplace is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemCounter;

    struct MarketItem {
        uint256 id;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable buyer;
        uint256 price;
    }

    mapping(uint256 => MarketItem) private marketItems;

    function createMarketItem(address nftContract, uint256 tokenId, uint256 price) public payable nonReentrant {
        require(price > 0, "Price must be at least 1 wei");
        require(msg.value == 0.025 ether, "Fee must be equal to listing fee");

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
        _itemCounter.increment();
        uint256 itemId = _itemCounter.current();

        marketItems[itemId] = MarketItem(itemId, nftContract, tokenId, payable(msg.sender), payable(address(0)), price);
    }

    function createMarketSale(uint256 itemId) public payable nonReentrant {
        MarketItem storage item = marketItems[itemId];
        require(msg.value == item.price, "Please submit the asking price");

        item.seller.transfer(msg.value);
        IERC721(item.nftContract).transferFrom(address(this), msg.sender, item.tokenId);
        item.buyer = payable(msg.sender);
    }
}