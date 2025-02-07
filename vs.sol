// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    address public owner;
    string public electionName;

    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    constructor(string memory _name) {
        owner = msg.sender;
        electionName = _name;
    }

    function addCandidate(string memory _name) ownerOnly public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function authorize(address _voter) ownerOnly public {
        voters[_voter].authorized = true;
    }

    function vote(uint _candidateId) public {
        require(voters[msg.sender].authorized, "Not authorized to vote");
        require(!voters[msg.sender].voted, "Already voted");

        voters[msg.sender].vote = _candidateId;
        voters[msg.sender].voted = true;

        candidates[_candidateId].voteCount++;
    }

   
}
