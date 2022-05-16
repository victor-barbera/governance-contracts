//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


interface IERC165 {
    function supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address _owner) external view returns (uint balance);
    function ownerOf(uint _tokenId) external view returns (address owner);
    function safeTransferFrom(address _from, address _to, uint _tokenId) external;
    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes calldata _data) external;
    function transferFrom(address _from, address _to, uint _tokenId) external;
    function approve(address _to, uint _tokenId) external;
    function getApproved(uint _tokenId) external view returns (address operator);
    function setApprovalForAll(address _operator, bool _approved) external;
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

    event Transfer(address indexed _from, address indexed _to, uint indexed _tokenId);
    event Approval(address indexed _owner,address indexed _approved,uint indexed _tokenId);
    event ApprovalForAll(address indexed _owner,address indexed _operator,bool _approved);
}