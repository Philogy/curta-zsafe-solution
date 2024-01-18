// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC1967Utils} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol";

abstract contract SafeUpgradeable {
    mapping(bytes32 => bool) internal whitelist;

    address private immutable __self = address(this);

    modifier onlyProxy() {
        _checkProxy();
        _;
    }

    function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallSafe(newImplementation, data);
    }

    function _checkProxy() internal view virtual {
        if (address(this) == __self || ERC1967Utils.getImplementation() != __self) {
            revert("No hacc");
        }
    }

    function _authorizeUpgrade(address newImplementation) internal {
        require(whitelist[newImplementation.codehash], "wtf no whitelisted no hacc pls");
    }

    function _upgradeToAndCallSafe(address newImplementation, bytes memory data) private {
        ERC1967Utils.upgradeToAndCall(newImplementation, data);
    }
}
