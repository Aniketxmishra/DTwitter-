// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DataAccessToken is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct DataAccess {
        string dataUri;
        uint256 validUntil;
        bool isActive;
    }

    mapping(uint256 => DataAccess) public tokenData;

    constructor() ERC721("DataAccessToken", "DAT") {}

    function mintDataAccessToken(
        address recipient,
        string memory dataUri,
        uint256 validityPeriod
    ) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(recipient, newTokenId);
        
        tokenData[newTokenId] = DataAccess({
            dataUri: dataUri,
            validUntil: block.timestamp + validityPeriod,
            isActive: true
        });

        return newTokenId;
    }

    // ✅ Wrapper function to safely check token existence
    function tokenExists(uint256 tokenId) public view returns (bool) {
        return super._exists(tokenId); // ✅ Correct way to access _exists()
    }

    function hasValidAccess(uint256 tokenId) public view returns (bool) {
        require(tokenExists(tokenId), "Token does not exist");
        DataAccess memory access = tokenData[tokenId];
        return access.isActive && block.timestamp <= access.validUntil;
    }

    function revokeAccess(uint256 tokenId) public onlyOwner {
        require(tokenExists(tokenId), "Token does not exist");
        tokenData[tokenId].isActive = false;
    }

    function getDataUri(uint256 tokenId) public view returns (string memory) {
        require(hasValidAccess(tokenId), "No valid access");
        return tokenData[tokenId].dataUri;
    }
}
