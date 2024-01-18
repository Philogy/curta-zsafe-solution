// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IReinitFactory} from "./IReinitFactory.sol";
import {FakeUpgrade} from "./FakeUpgrade.sol";
import {FakeProxy} from "./FakeProxy.sol";
import {SafeProxy} from "../SafeProxy.sol";
import {SafeUpgradeable} from "../SafeUpgradeable.sol";

/// @author philogy <https://github.com/philogy>
contract ReinitFactory is IReinitFactory {
    bool private _copy;
    address private _target;

    event DeployFailed();

    address internal immutable ___self = address(this);

    bytes32 internal constant SALT = bytes32(0);

    function fakeDeploy(address target, address victim) external returns (address upgrade) {
        _copy = true;
        _target = target;
        upgrade = address(new FakeUpgrade{salt: SALT}());

        bytes32[] memory whitelisted = new bytes32[](1);
        whitelisted[0] = address(this).codehash;
        SafeProxy(upgrade).initialize(address(1), whitelisted);

        SafeUpgradeable(victim).upgradeToAndCall(address(upgrade), "");

        SafeUpgradeable(upgrade).upgradeToAndCall(address(this), abi.encodeCall(this.destroy, ()));
    }

    function deployActual(address real, address victim) external {
        _copy = false;
        _target = real;

        new FakeUpgrade{salt: SALT}();

        FakeProxy(victim).set();
    }

    function destroy() external {
        require(address(this) != ___self);
        selfdestruct(payable(tx.origin));
    }

    function mode() external view override returns (bool, address) {
        return (_copy, _target);
    }
}
