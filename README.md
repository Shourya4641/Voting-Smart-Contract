Voting Smart Contract

This repository contains a Solidity smart contract for a decentralized voting system. The contract allows an admin to manage an election, add candidates and voters, and enables voters to cast their votes or delegate them to other voters.

Features

- Election management (start/end)
- Candidate registration
- Voter registration
- Vote casting
- Vote delegation
- Result viewing
- Winner determination

Contract Details

- Solidity Version: 0.8.24
- License: MIT

Key Functions

1. `addCandidate`: Add a new candidate to the election
2. `addVoter`: Register a new voter
3. `delegateVote`: Allow a voter to delegate their vote to another voter
4. `startElection`: Begin the voting process
5. `endElection`: Conclude the voting process
6. `vote`: Cast a vote for a candidate
7. `showResult`: Display the vote count for a specific candidate
8. `showWinner`: Determine and display the winning candidate

Structs

- `Candidate`: Stores candidate information (id, name, proposal)
- `Voter`: Stores voter information (name, address, delegate, voting status)

Modifiers

- `onlyAdmin`: Restricts function access to the contract admin
- `onlyElectionOn`: Allows execution only when the election is active
- `onlyElectionOff`: Allows execution only when the election is inactive

Usage

To use this contract:

1. Deploy the contract to an Ethereum-compatible blockchain
2. The deploying address becomes the admin
3. Add candidates and voters using the admin account
4. Start the election
5. Voters can cast votes or delegate their votes
6. End the election
7. View results and determine the winner

Security Considerations

- Only the admin can add candidates and voters, and control the election state
- Voters can only vote once and only for themselves
- Vote delegation is only possible if the delegate has already voted

Note

This is a basic implementation and may need additional features and security measures for production use. Always audit smart contracts thoroughly before deployment.
