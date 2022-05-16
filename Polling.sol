//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IPolling.sol";

/**
 * @title Polling Contract
 * @author Víctor Barberà
 * @notice Generic and simple Polling SC, it's intended to be inherited and extended. It doesn't
 *  provide any Acces Control by default.
 * @dev Poll duration is fixed by default.De moment hagafarem una duració fixe (10 minuts per test o 1 setmana per prod),
 * si mes tard s'ha de fer variable caldra afegir una variable de duracció al Ballot.
 * Falta mirar el tamany de les dades, els modificadors d'accés i memory allocation.
 */
 // TODO: Mirar si es fa fixe la durada de cada Poll, si inicialitzem aquest valor amb constructor.
 //       Ademés falta settejar el tamany de les dades.
abstract contract Polling is IPolling {
    Poll[] internal polls;
    uint internal constant duration = 1 hours; // El temps és aproximat amb una variacio de menys d'un minut.


    modifier pollExists(uint _pollId) {
        require(_pollId < polls.length,"This poll doesn't exist");
        _;
    }

    modifier validAddress(address _addr) {
        require (_addr != address(0), "Not a valid address.");
        _;
    }

    function getDuration() external pure returns (uint) {
        return duration;
    }

    function createPoll(string memory _title, string memory _description, address _destAddr, uint _qty) public virtual override validAddress(_destAddr) returns (uint256 _id) {
        require(_qty > 0, "Quantity must be greater than 0");
        _id = polls.length;
        polls.push();
        Poll storage p = polls[_id];
        p.title = _title;
        p.description = _description;
        p.createdAt = block.timestamp;
        p.destAddr = _destAddr;
        p.qty = _qty;
        emit PollCreated(_id, _title, _description, polls[_id].createdAt, _destAddr, _qty);
    }

    function vote(uint _pollId, Options _value, uint weight) public virtual override pollExists(_pollId) {
        require((polls[_pollId].createdAt + duration) > block.timestamp,"This poll has already ended");
        require(!polls[_pollId].voters[msg.sender], "You've already voted");
        polls[_pollId].votes[_value] += weight;
        polls[_pollId].voters[msg.sender] = true;
        emit Vote(_pollId, msg.sender, _value, weight);
    }

    function evaluatePoll(uint _pollId) public virtual override pollExists(_pollId) returns(Options _result) {
        require((polls[_pollId].createdAt + duration) < block.timestamp,"This poll hasn't ended yet");
        Poll storage p = polls[_pollId];
        if(p.votes[Options.YES] > p.votes[Options.NO]) _result = Options.YES;
        else _result = Options.NO;
        p.result = _result;
        emit Result(_pollId, _result);
    }

    function getResult(uint _pollId) external view virtual override pollExists(_pollId) returns (Options _result) {
        _result = polls[_pollId].result;
        require(_result != Options.BLANK, "This poll hasn't been validated yet");
    }
}