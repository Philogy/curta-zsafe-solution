// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SafeProxy} from "./SafeProxy.sol";

contract SafeSecretAdmin is SafeProxy {
    uint256 private offsetp1;
    uint256 private offsetp2;

    function p1() external view virtual override returns (uint256) {
        unchecked {
            return p1_secret + offsetp1;
        }
    }

    function p2() external view virtual override returns (uint256) {
        unchecked {
            return p2_secret + offsetp2;
        }
    }

    function set_offset(uint256 _p1, uint256 _p2) external {
        offsetp1 = _p1;
        offsetp2 = _p2;
    }
}
