// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { ByteHasher } from 'worldcoin/world-id/libraries/ByteHasher.sol';
import { ISemaphore } from 'worldcoin/world-id/interfaces/ISemaphore.sol';

contract HumanCheck {
    using ByteHasher for bytes;

    error InvalidNullifier();

    event ProfileVerified(uint256 indexed profileId);
    event ProfileUnverified(uint256 indexed profileId);

    uint256 internal immutable groupId;
    ISemaphore internal immutable semaphore;

    mapping(uint256 => bool) public isVerified;
    mapping(uint256 => uint256) internal nullifierHashes;

    constructor(ISemaphore _semaphore, uint256 _groupId) payable {
        semaphore = _semaphore;
        groupId = _groupId;
    }

    function verify(
        uint256 profileId,
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) public payable {
        semaphore.verifyProof(
            root,
            groupId,
            abi.encodePacked(profileId).hashToField(),
            nullifierHash,
            abi.encodePacked(address(this)).hashToField(),
            proof
        );

        ///@TODO: Check if saving `nullifierHashes[nullifierHash]` to memory saves gas
        if (nullifierHashes[nullifierHash] != 0) {
            isVerified[nullifierHashes[nullifierHash]] = false;
            emit ProfileUnverified(nullifierHashes[nullifierHash]);
        }

        isVerified[profileId] = true;
        nullifierHashes[nullifierHash] = profileId;

        emit ProfileVerified(profileId);
    }
}
