// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SafeProxy} from "./SafeProxy.sol";

contract SafeSecret is SafeProxy {
    function p1() external view virtual override returns (uint256) {
        return p1_secret;
    }

    function p2() external view virtual override returns (uint256) {
        return p2_secret;
    }
}
