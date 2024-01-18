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
        vm.startBroadcast(pk);
        Addrs memory addrs;
        addrs.load();

        bytes32[3] memory r;
        r[0] = 0x097e67cbff321c26e794f1a2494dc91411e94951ef674d188f6c58ea8fdfb42c;
        r[1] = 0x19ed412f4a70acf17b6da0943fe8ffc0f9648a5a28e02f37bda3fe6d749aa8a5;
        r[2] = 0xb97d3285ef2d69e9a56bfd91d4b0f5657ec88cfe840025fc15c4130665841237;
        bytes32[3] memory s;

        addrs.lock.unlock(r, s);

        addrs.save();
        vm.stopBroadcast();
    }
}
