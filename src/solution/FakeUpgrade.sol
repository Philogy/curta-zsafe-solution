// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC1967Utils} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {IReinitFactory} from "./IReinitFactory.sol";
import {FakeProxy} from "./FakeProxy.sol";
import {console2 as console} from "forge-std/console2.sol";

contract FakeUpgrade {
    error SetFailed();

    constructor() {
        (bool copy, address target) = IReinitFactory(msg.sender).mode();

        if (copy) {
            ERC1967Utils.upgradeToAndCall(target, "");
            assembly {
                let size := extcodesize(target)
                extcodecopy(target, 0, 0, size)
                return(0, size)
            }
        } else {
            (bool success,) = target.delegatecall(abi.encodeCall(FakeProxy.set, ()));
            if (!success) revert SetFailed();

            bytes memory code =
                abi.encodePacked(hex"3d3d3d3d363d3d37363d73", address(target), hex"5af43d3d93803e602a57fd5bf3");

            assembly {
                return(add(code, 0x20), mload(code))
            }
        }
    }
}
