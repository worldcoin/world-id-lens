// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC721 } from 'solmate/tokens/ERC721.sol';

contract LensProfile is ERC721('Lens Profile', 'LENS') {
    uint256 internal nextTokenId = 1;

    function tokenURI(uint256) public pure override returns (string memory) {
        return 'test';
    }

    function issue(address to) public returns (uint256) {
        _mint(to, nextTokenId);

        return nextTokenId++;
    }
}
