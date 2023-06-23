//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ballot{

    struct Voter {
        uint weight;
        bool voted; //if true person has already voted
        address delegate; //the person they voted for
        uint vote; //index of the vote
    }

    struct Proposal{
        bytes32 name; //short name for the proposal
        uint voteCount;
    }

    address public chairperson;

    //This creates a mapping. It stores a 'Voter' struct
    //for every possible address.
    mapping(address => Voter) voters;

    //an array of 'Proposal'
    Proposal[] public proposals; 


    //'memory' won't store any info on the blockchain
    //the argument will be used only for the constructor call
    constructor (bytes32[] memory proposalNames){
        chairperson = msg.sender; // The one that initializes the contract
        voters[chairperson].weight = 1; //Select the voter with the address of the chairperson

        for (uint i=0; i < proposalNames.length ; i++ ){
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }

    }

    function giveRightToVote(address voter) external{
        require(
            msg.sender == chairperson, //Check if the person that called the function is the chairperson
            "Only the chairperson can decide for voting rights." //Error message
        );

        require(
            !voters[voter].voted,
            "The voter has already voted"
        );

        require(voters[voter].weight==0);
        voters[voter].weight = 1;
    }

    function delegate (address voteFor) external{
        Voter storage sender = voters[msg.sender]; //We use storage to keep a log of the votes?
        require(sender.weight != 0, "No voting right.");
        require(!sender.voted, "You have already voted.");

        require( voteFor != msg.sender ,"You can delegate yourself.");

        while ( voters[voteFor].delegate != address(0) ){

            voteFor = voters[voteFor].delegate; //Who has the delegate voted for?
            require(voteFor != msg.sender, "Found loop in delegation."); //if they have voted for the current voter we get an error.

        }

        Voter storage delegate_ = voters[voteFor]; //voteFor ends up to the person that hasn't voted someone
        require(delegate_.weight >=1 ); //Ensure delegate has right to vote

        sender.voted=true;
        sender.delegate = voteFor;

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight; //directly add vote to the proposal
        }
        else{
            delegate_.weight += sender.weight; //give to the delegate the sender's voting power
        }
    }

    function vote(uint proposal) external{
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "No right to vote!");
        require(!sender.voted,"Already voted..");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view
        returns (uint winningProposal_){ //returns the value after the function has completed exectuion.
            uint winningVoteCount = 0;

            for (uint p = 0; p < proposals.length ; p++){
                if (proposals[p].voteCount > winningVoteCount){
                    winningVoteCount = proposals[p].voteCount;
                    winningProposal_ = p;
                }
            }

    }

    function winnerName() external view
        returns (bytes32 winnerName_){
            winnerName_ = proposals[winningProposal()].name;
        }



}