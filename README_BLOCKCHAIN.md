# Secure Commit--Reveal E-Tendering System for Corruption-Free Bidding

## Objective

The objective of this project is to develop a secure and transparent
e-tendering system that ensures fairness and prevents corruption. Using
a commit--reveal mechanism, bidders can submit their bids
confidentially, preventing any possibility of altering the bid after
submission. The contract automatically determines the lowest bid and
announces the winner, ensuring that the authority cannot manipulate the
outcome. After the winner is declared, all bids are revealed publicly to
maintain transparency, fostering trust and accountability among all
participants in the tendering process.

## Software Used

-   Remix IDE (Integrated Development Environment)
-   Etherscan
-   MetaMask Wallet
-   ChatGPT

## Theory

An e-tendering system is a digital platform that allows organizations to
invite bids from vendors electronically. The main challenges in
traditional tendering processes include lack of transparency, potential
manipulation by authorities, and the possibility of bidders altering
their offers after seeing competitors' bids. A commit--reveal mechanism
addresses these concerns by providing confidentiality and integrity for
bids.

### Commit--Reveal Mechanism

1.  **Commit Phase:** Each bidder submits a hash of their bid combined
    with a secret key (salt). The hash hides the actual bid value while
    binding the bidder to it.
2.  **Reveal Phase:** After the commit phase ends, bidders reveal their
    actual bid and secret key. The contract recomputes the hash and
    verifies it against the stored commitment. Only valid reveals are
    considered.
3.  **Winner Selection:** The system identifies the lowest valid bid and
    declares the winner.
4.  **Transparency:** After the winner is announced, all bids are
    revealed publicly for verification.

### Advantages

-   **Security:** Bids are hidden during the commit phase, preventing
    unfair competition.
-   **Integrity:** Bidders cannot modify their bids once submitted.
-   **Transparency:** Final bids are revealed after the winner is
    announced.
-   **Corruption-Free:** Automatic winner selection is intended to
    eliminate authority bias.

## Process Workflow

The workflow diagram in the source document (page 2) shows multiple
`commitBid()` calls followed by `revealBid()` calls, then `finalize()`,
and finally `announceAllBids()`.

``` text
Commit phase:
  commitBid() → commitBid() → commitBid()

Reveal phase:
  revealBid() → revealBid() → revealBid()

Finalization:
  finalize()
      ↓
  announceAllBids()
```

## Functions Used

### 1. `commitBid(uint256 bidAmount, string memory secretKey)`

**Purpose:** Allows bidders to submit bids secretly without revealing
the actual amount.

**How it works:** - The contract takes `bidAmount` and a bidder-provided
`secretKey` (salt). - It computes a hash using
`keccak256(abi.encodePacked(bidAmount, secretKey))`. - The hash is
stored as a commitment, binding the bidder to the bid while hiding its
value.

**Execution time:** Only before the `commitDeadline`.

**Effect:** Ensures the bid is hidden and cannot be altered after
submission.

### 2. `revealBid(uint256 bidAmount, string memory secretKey)`

**Purpose:** Reveals the actual bid and verifies it against the
previously submitted commitment.

**How it works:** - The bidder sends the same `bidAmount` and
`secretKey` used during commit. - The contract recomputes the hash and
checks it against the stored commitment. - If the hash matches, the bid
is stored in `revealedBids[msg.sender]`.

**Execution time:** After the `commitDeadline` and before the
`revealDeadline`.

**Effect:** Confirms the bid's authenticity and prepares it for winner
selection.

### 3. `finalize()`

**Purpose:** Automatically selects the winner of the tender.

**How it works:** - The contract iterates through all revealed bids. -
It finds the lowest valid bid and stores the bidder's address as
`winner` and the bid as `winningBid`. - After finalization, the tender
results cannot be changed.

**Execution time:** Only after the `revealDeadline`.

**Effect:** Determines the winner and locks the outcome.

### 4. `announceAllBids()`

**Purpose:** Displays all revealed bids for transparency.

**How it works:** - Returns two arrays: bidder addresses and their
corresponding revealed bid amounts. - Anyone can call this function to
see all bids after the tender is finalized.

**Execution time:** Only after the tender has been finalized.

**Effect:** Allows participants to verify the announced bids.

## Conclusion

The commit--reveal e-tendering system is designed to provide a secure
and transparent method for awarding contracts. Bidders submit
confidential commitments, valid bids are checked during reveal, the
lowest valid bid is selected automatically, and all revealed bids are
made public after finalization. This approach is intended to improve
fairness, trust, and accountability in blockchain-based e-tendering.
