// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {SafeUpgradeable} from "./SafeUpgradeable.sol";

abstract contract SafeProxy is OwnableUpgradeable, SafeUpgradeable {
    uint256 internal p1_secret;
    uint256 internal p2_secret;

    function initialize(address owner, bytes32[] calldata whitelisted_hashes) public initializer {
        for (uint256 i = 0; i < whitelisted_hashes.length; ++i) {
            whitelist[whitelisted_hashes[i]] = true;
        }

        p1_secret = 0x510e4e770828ddbf7f7b00ab00a9f6adaf81c0dc9cc85f1f8249c256942d61d9;
        p2_secret = 0xb903bd7696740696b2b18bd1096a2873bb8ad0c2e7f25b00a0431014edb3f539;

        __Ownable_init(owner);
    }

    function p1() external view virtual returns (uint256);
    function p2() external view virtual returns (uint256);
}
