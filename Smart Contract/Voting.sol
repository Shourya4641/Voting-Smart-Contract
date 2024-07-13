// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Voting {
    //address of contract owner
    address admin;

    //enum for state of election
    enum ElectionState {OFF, ON}

    //variable to store the current state of the election
    ElectionState status;

    //constructor
    constructor() {
        admin = msg.sender;
    }

    //modifier - only for admin
    modifier onlyAdmin {
        require(admin == msg.sender, "can only be accessed by Admin.data");
        _;
    }

    //modifier - election is going ON
    modifier onlyElectionOn {
        require(status == ElectionState.ON, "current election state doesn't support the execution.");
        _;
    }

    //modifier - election is Off
    modifier onlyElectionOff {
        require(status == ElectionState.OFF, "current election state doesn't support the execution.");
        _;
    }

    //candidate structure
    struct Candidate {
        uint id;
        string name;
        string proposal;
    }

    //voter structure
    struct Voter {
        string name;
        address voterAddress;
        address delegateAddress;
        bool ifVoted;
        bool ifVoteDelegated;
    }

    //candidate count, it will be used to assign the candidates their unique id
    uint candidateCount = 0;

    //number of voters
    uint voterCount = 0;

    //mapping candidates with their unique id
    mapping (uint => Candidate) candidates;

    //mapping of voter address to candidates
    mapping (address => string) candidateVotedFor;

    //mapping voters with their addresses
    mapping (address => Voter) voters;

    //mapping to store the vote count
    mapping (uint => Voter[]) voteCasted;

    //function to add a new candidate
    function addCandidate (string memory _name, string memory _proposal, address _admin) onlyElectionOff public {
        require(msg.sender == _admin, "candidate can only be added by the admin of the contract");
        candidates[candidateCount] = Candidate(++candidateCount, _name, _proposal);
    }

    //function to add new voter
    function addVoter (string memory _name, address _voter, address _admin) onlyElectionOff public {
        require(msg.sender == _admin, "voters can only be added by the admin of the contract");
        if (voters[_voter].ifVoted != true) voters[_voter] = Voter(_name, _voter, address(0), false, false);
        voterCount++;
    }

    //function to delegate vote to another voter
    function delegateVote(address _voter, address _delegateVoter) onlyElectionOn public {
        require(_voter == msg.sender, "only the individual voter can delgate his/her voting rights.");
        require(voters[_voter].ifVoted == false, "you already casted vote, so you cannot delegate your vote.");
        require(voters[_delegateVoter].ifVoted == true, "delegate voter didn't cast vote yet, hence vote cannot be delegated.");
        voters[_delegateVoter].ifVoted = false;
        voters[_voter].ifVoteDelegated = true;
        voters[_voter].delegateAddress = _delegateVoter;
    }

    //function to end election
    function endElection (address _admin) public {
        require(msg.sender == _admin, "election can be ended only by the admin.");
        status = ElectionState.OFF;
    }

    //function to start the election
    function startElection (address _admin) public {
        require(msg.sender == _admin, "election can be started only by the admin.");
        status = ElectionState.ON;
    }

    //function to cast vote
    function vote (uint _id, address _voter) onlyElectionOn public {
        require(_voter == msg.sender, "you are replacing the legal voter.");
        require(voters[_voter].ifVoted == false, "you already casted vote.");
        require(_id <= candidateCount, "give a valid candidate Id.");
        voters[_voter].ifVoted = true;
        Voter memory newVoter = Voter({
            name : voters[_voter].name,
            voterAddress : _voter,
            delegateAddress : voters[_voter].delegateAddress,
            ifVoted : voters[_voter].ifVoted,
            ifVoteDelegated : voters[_voter].ifVoteDelegated
        });
        voteCasted[_id].push(newVoter);
        candidateVotedFor[_voter] = candidates[_id].name;
    }

    //function to get candidate count
    function candidate_count() public view returns (uint) {
        return candidateCount;
    }

    //function to get the election status
    function checkState() public view returns(string memory _electionStatus) {
        if (status == ElectionState.OFF) return "Election OFF";
        else if (status == ElectionState.ON) return "Election ON";
    }

    //funtion to get candidate details based on id
    function displayCandidate (uint _id) public view  returns (uint _candidateId, string memory _candidateName, string memory _proposal) {
        return (candidates[_id].id, candidates[_id].name, candidates[_id].proposal);
    }

    //function to show vote count candidate wise
    function showResult(uint _id) onlyElectionOff public  view returns (uint _candidateId, string memory _candidateName, uint _candidateVoteCount) {
        require(_id <= candidateCount, "give a valid candidate Id.");
        return (_id, candidates[_id].name, voteCasted[_id].length);
    }

    //function to get the winner candidate
    function showWinner() onlyElectionOff view public returns (string memory _candidateName, uint _candidateId, uint _candidateVoteCount) {
        uint highestVoteCount = 0;
        uint winnerCandidateId = 0;
        uint currentCandidateVoteCount = 0;
        uint currentCandidateId = 0;
        for (uint i = 1; i<=candidateCount; i++) {
            currentCandidateId = i;
            currentCandidateVoteCount = voteCasted[currentCandidateId].length;
            if (currentCandidateVoteCount > highestVoteCount) {
                highestVoteCount = currentCandidateVoteCount;
                winnerCandidateId = currentCandidateId;
            } 
        }
        return (candidates[winnerCandidateId].name, winnerCandidateId, highestVoteCount);
    }

    //function to get the voter count
    function voter_count() public view returns (uint _voterCount) {
        return voterCount;
    }

    //function to get voters details
    function voterProfile (address _voter) public view returns (string memory _voterName, string memory _votedCandidateName, bool ifVoteDelegated, address _delegateVoterAddress) {
        return (voters[_voter].name, candidateVotedFor[_voter], voters[_voter].ifVoteDelegated, voters[_voter].delegateAddress);
    }
}