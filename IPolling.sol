//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IPolling {
    enum Options {BLANK,YES,NO}
    struct Poll {
        string title;
        string description;
        uint createdAt;
        address destAddr;
        uint qty;
        mapping(Options => uint) votes;
        mapping(address => bool) voters;
        Options result;
    }

    event PollCreated(uint indexed pollId,
        string title,
        string description,
        uint createdAt,
        address destAddr,
        uint qty
    );
    event Vote(uint indexed pollId, address addr, Options value, uint weight);
    event Result(uint indexed pollId, Options result);

    function createPoll(string memory _title,
        string memory _description,
        address _destAddr,
        uint _qty
    ) external returns (uint256 _id);
    function vote(uint _pollId, Options _value, uint weight) external;
    function evaluatePoll(uint _pollId) external returns (Options _result);
    function getResult(uint _pollId) external view returns (Options);
}