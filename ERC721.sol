//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IERC721.sol";

// S'utilitza per cridar aquesta funció en altres contractes.
interface IERC721Receiver {
    function onERC721Received(
        address _operator,
        address _from,
        uint _tokenId,
        bytes calldata _data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    using Address for address;

    // Mapping from token ID to owner address.
    mapping(uint => address) private _owners;

    // Mapping owner address to token count.
    mapping(address => uint) private _balances;

    // Mapping from token ID to approved address.
    mapping(uint => address) private _tokenApprovals;

    // Mapping from owner to operator approvals.
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    function supportsInterface(bytes4 _interfaceId) external pure override returns (bool) {
        return
            _interfaceId == type(IERC721).interfaceId ||
            _interfaceId == type(IERC165).interfaceId;
    }

    function balanceOf(address _owner) external view override returns (uint256) {
        require(_owner != address(0), "owner is zero address.");
        return _balances[_owner];
    }

    function ownerOf(uint _tokenId) public view override returns (address owner) {
        owner = _owners[_tokenId];
        require(owner != address(0), "token doesn't exist.");
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint _tokenId,
        bytes memory _data
    ) public virtual override canTransferToken(msg.sender, _tokenId) {
        require(_checkOnERC721Received(_from, _to, _tokenId, _data), "not ERC721Receiver.");
        _transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint _tokenId) external virtual override {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    // La diferència és que ara no comprova `_checkOnERC721Received()`, per tant
    // el `caller` és el responsable de saber que `_to` és una `address` valida.
    function transferFrom(
        address _from,
        address _to,
        uint _tokenId
    ) external virtual override canTransferToken(msg.sender, _tokenId) {
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint _tokenId) external virtual override {
        address _owner = ownerOf(_tokenId);
        require(
            msg.sender == _owner || _operatorApprovals[_owner][msg.sender],
            "not owner nor approved for all."
        );
        _approve(_approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external virtual override {
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    // Per obtenir quina és la `approved address` d'un NFT.
    function getApproved(uint _tokenId) external view virtual override returns (address) {
        require(_owners[_tokenId] != address(0), "token doesn't exist.");
        return _tokenApprovals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view virtual override returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function mint(address _to, uint _tokenId) public virtual {
        require(_to != address(0), "mint to zero address.");
        require(_owners[_tokenId] == address(0), "token already minted.");

        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(address(0), _to, _tokenId);
    }

    // S'ha de posar una condició perquè no tothom pugui fer `burn`.
    /*function burn(uint _tokenId) external {
        address _owner = ownerOf(_tokenId);

        _approve(_owner, address(0), _tokenId);

        _balances[_owner] -= 1;
        delete _owners[_tokenId];

        emit Transfer(_owner, address(0), _tokenId);
    }*/

    function _transfer(address _from, address _to, uint _tokenId) internal {
        require(_from == ownerOf(_tokenId), "not owner.");
        require(_to != address(0), "transfer to the zero address.");

        _approve(address(0), _tokenId);

        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function _approve(address _to, uint _tokenId) private{
        _tokenApprovals[_tokenId] = _to;
        emit Approval(ownerOf(_tokenId), _to, _tokenId);
    }

    function _checkOnERC721Received(
        address _from,
        address _to,
        uint _tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (_to.isContract()) {
            return
                IERC721Receiver(_to).onERC721Received(
                    msg.sender,
                    _from,
                    _tokenId,
                    _data
                ) == IERC721Receiver.onERC721Received.selector;
        } else {
            return true;
        }
    }

    modifier canTransferToken(address _spender, uint _tokenId) {
        address _owner = ownerOf(_tokenId);
        require(_spender == _owner ||
         _spender == _tokenApprovals[_tokenId] ||
         _operatorApprovals[_owner][_spender],
         "not owner nor approved");
        _;
    }
}

// Llibreria per detectar si una adresa és un SC.
library Address {
    function isContract(address account) internal view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}