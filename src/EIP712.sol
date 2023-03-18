//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EIP712 {
    string private _name;
    string public version_;

    bytes32 private constant SALT_IN_DOMAIN_SEPARATOR = keccak256("-");
    bytes32 private constant DOMAIN_SEPARATOR = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)");
    bytes32 private constant PERMIT_HASH_STRUCT = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    
    constructor(string memory name, string memory version) {
        _name = name;
        version_ = version;
    }

    function _domainSeparator() public view returns (bytes32) {
        return keccak256(abi.encode(DOMAIN_SEPARATOR, keccak256(bytes(_name)), _version(), address(this), salt_domainSeparator()));
    }
    
    function salt_domainSeparator() public view returns (bytes32) {
        return SALT_IN_DOMAIN_SEPARATOR;
    }

    function _toTypedDataHash(bytes32 structHash) public view returns (bytes32) {
        return keccak256(abi.encode("\x19\x01", _domainSeparator(), structHash));
    }

    function _version() public view returns (string memory){
        return version_;
    }


    function _toStructHash(address owner, address spender, uint256 value, uint256 nonce, uint256 deadline) public returns (bytes32) {
        return keccak256(abi.encode(PERMIT_HASH_STRUCT, owner, spender, value, nonce, deadline));
    }
}