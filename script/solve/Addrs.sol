// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SafeCurta, SafeChallenge} from "../../src/Challenge.sol";
import {ReinitFactory} from "../../src/solution/ReinitFactory.sol";
import {stdJson} from "forge-std/stdJson.sol";
import {VmSafe} from "forge-std/Vm.sol";

struct Addrs {
    ReinitFactory factory;
    address impostor;
    SafeChallenge lock;
    address targetImpl;
}

using AddrsLib for Addrs global;

library AddrsLib {
    using stdJson for string;

    VmSafe private constant vm = VmSafe(address(uint160(uint256(keccak256("hevm cheat code")))));

    function save(Addrs memory addrs) internal {
        string memory obj = "addrs";

        obj.serialize("factory", address(addrs.factory));
        obj.serialize("impostor", addrs.impostor);
        obj.serialize("lock", address(addrs.lock));
        string memory serialized = obj.serialize("targetImpl", addrs.targetImpl);

        serialized.write("./addrs.json");
    }

    function load(Addrs memory addrs) internal view {
        bytes memory raw = vm.readFile("./addrs.json").parseRaw(".");
        Addrs memory decoded = abi.decode(raw, (Addrs));
        addrs.factory = decoded.factory;
        addrs.impostor = decoded.impostor;
        addrs.lock = decoded.lock;
        addrs.targetImpl = decoded.targetImpl;
    }
}
