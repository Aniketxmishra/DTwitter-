// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DataTokenization {
    mapping(address => string) private tokenizedData;  // Stores tokenized reference

    event DataStored(address indexed user, string tokenHash);

    function storeTokenizedData(string memory _tokenHash) external {
        tokenizedData[msg.sender] = _tokenHash;
        emit DataStored(msg.sender, _tokenHash);
    }

    function getTokenizedData(address _user) external view returns (string memory) {
        require(msg.sender == _user, "Unauthorized access");
        return tokenizedData[_user];
    }
}
