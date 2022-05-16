//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC721.sol";

contract RoleNFT is ERC721 {
    address private _daoAddr;
    constructor() {
        _daoAddr = msg.sender;
    }
    
    modifier isDaoAddress {
        require(msg.sender == _daoAddr, "Acces denied");
        _;
    }

    function mint(address to, uint tokenId) public override isDaoAddress {
        super.mint(to, tokenId);
    }

    function transfer(address from, address to, uint tokenId) external isDaoAddress {
        super._transfer(from, to, tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint _tokenId) external override {
        revert("function disabled");
    }
    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes calldata _data) public override {
        revert("function disabled");
    }
    function transferFrom(address _from, address _to, uint _tokenId) external override {
        revert("function disabled");
    }
    function approve(address _to, uint _tokenId) external override {
        revert("function disabled");
    }
    function getApproved(uint _tokenId) external view override returns (address operator) {
        revert("function disabled");
    }
    function setApprovalForAll(address _operator, bool _approved) external override {
        revert("function disabled");
    }
    function isApprovedForAll(address _owner, address _operator) external view override returns (bool) {
        revert("function disabled");
    }
}