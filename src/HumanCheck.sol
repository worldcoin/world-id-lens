// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { ByteHasher } from 'world-id-contracts/libraries/ByteHasher.sol';
import { IWorldID } from 'world-id-contracts/interfaces/IWorldID.sol';

contract HumanCheck {
    using ByteHasher for bytes;

    error InvalidNullifier();

    event ProfileVerified(uint256 indexed profileId);
    event ProfileUnverified(uint256 indexed profileId);

    uint256 internal immutable groupId;
    IWorldID internal immutable worldID;

    mapping(uint256 => bool) public isVerified;
    mapping(uint256 => uint256) internal nullifierHashes;

    constructor(IWorldID _worldID, uint256 _groupId) payable {
        worldID = _worldID;
        groupId = _groupId;
    }

    function verify(
        uint256 profileId,
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) public payable {
        worldID.verifyProof(
            root,
            groupId,
            abi.encodePacked(profileId).hashToField(),
            nullifierHash,
            abi.encodePacked(address(this)).hashToField(),
            proof
        );

        if (nullifierHashes[nullifierHash] != 0) {
            uint256 prevProfileId = nullifierHashes[nullifierHash];

            isVerified[prevProfileId] = false;
            emit ProfileUnverified(prevProfileId);
        }

        isVerified[profileId] = true;
        nullifierHashes[nullifierHash] = profileId;

        emit ProfileVerified(profileId);
    }
}
