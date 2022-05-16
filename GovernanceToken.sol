// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";

contract GovernanceToken is ERC20 {
    address private _daoAddr;
    constructor() ERC20("Residential DAO Governance Token","RGT") {
        _daoAddr = msg.sender;
    }

    modifier isDaoAddress {
        require(msg.sender == _daoAddr, "Acces denied");
        _;
    }

    function transfer(address to, uint256 amount) public pure override returns (bool) {
        revert("function disabled");
    }

    function approve(address spender, uint256 amount) public pure override returns (bool) {
        revert("function disabled");
    }

    function transferFrom(address from, address to, uint256 amount) public pure override returns (bool) {
        revert("function disabled");
    }

    function decimals() public pure override returns (uint8){
        return 0;
    }

    function transfer(address from, address to, uint256 amount) external isDaoAddress {
        super._transfer(from, to, amount);
    }

    function mint(address account, uint256 amount) external isDaoAddress {
        super._mint(account, amount);
    }

    function burn(address account, uint256 amount) external isDaoAddress {
        super._burn(account, amount);
    }

    
}