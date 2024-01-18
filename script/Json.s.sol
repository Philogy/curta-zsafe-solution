// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/stdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

/// @author philogy <https://github.com/philogy>
contract JsonScript is Test, Script {
    function run() public {
        string memory id = "obj";
        stdJson.serialize(id, "wow", makeAddr("wow"));
        stdJson.serialize(id, "bob", makeAddr("bob"));
        string memory obj = stdJson.serialize(id, "nice", uint256(3));

        vm.writeJson(obj, "./addrs.json");
    }
}
