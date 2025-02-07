// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FrequencyCounter {
    mapping(uint256 => uint256) public frequency;
    
    function countFrequencies(uint256[] memory arr) public {
     
        for (uint256 i = 0; i < arr.length; i++) {
            frequency[arr[i]]++;
        }
    }

    function getFrequency(uint256 num) public view returns (uint256) {
        return frequency[num];
    }
}
