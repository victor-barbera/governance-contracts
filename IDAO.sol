//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IPolling.sol";

interface DAO is IPolling {
    enum Role {ADMIN, TOKENMANAGER}
    struct TokenBlocked {
        address addr;
        uint qty;
    }

    // SECTION  -  Polling functions
    function voteWithDeposit(
        uint _pollId,
        Options _value,
        address _from,
        address _to,
        uint256 _qty,
        uint256 _validAfter,
        uint256 _validBefore,
        bytes32 _nonce,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
        ) external;
    // SECTION  -  Governance Token and Role NFT functions
    function mintProperty(address to, uint amount) external;
    function burnTokens(address from, uint amount) external;
    function transferProperty(address from, address to, uint amount) external;
    function transferRole(address to, Role role) external;
}