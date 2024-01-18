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
    function run() public {
        uint256 pk = vm.envUint("PRIV_KEY");
        address me = vm.addr(pk);
        vm.startBroadcast(pk);
        Addrs memory addrs;
        addrs.load();

        SafeCurta curta = SafeCurta(0xb24Ab66B4C6f52F6686FFD348b1cFf47c5E84FB5);
        uint256 genSeed = curta.generate(me);

        addrs.lock = SafeChallenge(curta.deploy(genSeed, address(1)));

        addrs.save();
        vm.stopBroadcast();
    }
}
