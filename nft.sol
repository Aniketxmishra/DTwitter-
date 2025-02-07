// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BadgeToken is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("BadgeToken", "BADGE") {}

    function mintTo(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _mint(to, tokenId);
        _tokenIdCounter.increment();
    }
}