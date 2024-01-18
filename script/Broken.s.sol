// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {console2 as console} from "forge-std/console2.sol";

contract Counter {
    uint256 public count;

    constructor(uint256 startCount) {
        count = startCount;
    }

    function inc() external {
        uint256 preGas = gasleft();
        count++;
        uint256 afterGas = gasleft();
        require(preGas - afterGas > 5000, "count warm");
    }
}

/// @author philogy <https://github.com/philogy>
contract BrokenScript is Test, Script {
    function run() public {
        vm.startBroadcast();

        Counter c = new Counter(1);

        c.inc();

        vm.stopBroadcast();
    }
}
