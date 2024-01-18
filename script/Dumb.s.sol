// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {console2 as console} from "forge-std/console2.sol";
import {Dumb} from "../test/Dumb.sol";

/// @author philogy <https://github.com/philogy>
contract DumbScript is Test, Script {
    function run() public {
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        new Dumb();

        vm.stopBroadcast();
    }
}
