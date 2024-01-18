// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {console2 as console} from "forge-std/console2.sol";
import {ReinitFactory} from "../../src/solution/ReinitFactory.sol";
import {SafeCurta, SafeChallenge} from "../../src/Challenge.sol";
import {FakeProxy} from "../../src/solution/FakeProxy.sol";
import {Addrs} from "./Addrs.sol";

interface ICurta {
    function solve(uint32 puzzleId, uint256 solution) external;
}

/// @author philogy <https://github.com/philogy>
contract Step is Test, Script {
    uint32 internal constant PUZZLE_ID = 5;

    function run() public {
        uint256 pk = vm.envUint("PRIV_KEY");
        vm.startBroadcast(pk);
        Addrs memory addrs;
        addrs.load();

        ICurta(0x00000000D1329c5cd5386091066d49112e590969).solve(PUZZLE_ID, 0);

        addrs.save();
        vm.stopBroadcast();
    }
}
