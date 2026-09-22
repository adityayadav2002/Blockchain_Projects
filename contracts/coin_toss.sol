// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SecureCoinToss {
    address payable public alice;
    address payable public bob;

    uint256 public constant BET = 0.0002 ether;

    bytes32 public commitment; // Alice's commit = keccak256(x, r)
    uint8 public bobGuess;
    bool public committed;
    bool public bobJoined;
    bool public revealed;

    constructor() {
        alice = payable(msg.sender); // Alice = deployer
    }

    // Step 1: Alice commits to secret x (0/1) with random r
    function commit(bytes32 _commitment) external payable {
        require(msg.sender == alice, "Only Alice can commit");
        require(!committed, "Already committed");
        require(msg.value == BET, "Must fund 0.0002 ETH");

        commitment = _commitment;
        committed = true;
    }

    // Step 2: Bob joins and makes a guess (0 or 1)
    function join(uint8 _guess) external payable {
        require(committed, "Alice must commit first");
        require(!bobJoined, "Bob already joined");
        require(msg.value == BET, "Must send 0.0002 ETH");
        require(_guess == 0 || _guess == 1, "Guess must be 0 or 1");

        bob = payable(msg.sender);
        bobGuess = _guess;
        bobJoined = true;
    }

    // Step 3: Alice reveals secret x and r
    function reveal(uint8 _x, bytes32 _r) external {
        require(msg.sender == alice, "Only Alice can reveal");
        require(bobJoined, "Bob not joined yet");
        require(!revealed, "Already revealed");
        require(_x == 0 || _x == 1, "x must be 0 or 1");

        // Verify commitment
        require(keccak256(abi.encodePacked(_x, _r)) == commitment, "Commitment mismatch");

        revealed = true;

        // Decide winner
        address payable winner = (_x == bobGuess) ? bob : alice;

        // Payout pot
        winner.transfer(address(this).balance);
    }
}