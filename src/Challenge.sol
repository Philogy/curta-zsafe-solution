pragma solidity 0.8.20;

import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {SafeSecret} from "./SafeSecret.sol";
import {SafeSecretAdmin} from "./SafeSecretAdmin.sol";
import {SafeProxy} from "./SafeProxy.sol";

contract SafeCurta {
    mapping(uint256 => SafeChallenge) public factories;

    function name() external pure returns (string memory) {
        return "ZSafe";
    }

    function generate(address _seed) public pure returns (uint256) {
        return uint256(keccak256(abi.encode("Can you unlock the safe?", _seed)));
    }

    function verify(uint256 _start, uint256) external view returns (bool) {
        return factories[_start].isUnlocked();
    }

    function deploy(uint256 _start, address owner) external returns (address) {
        bytes32 rng_seed = keccak256(abi.encodePacked(_start));
        factories[_start] = new SafeChallenge(owner, rng_seed);
        return address(factories[_start]);
    }
}

contract SafeChallenge {
    bytes32 public seed;

    SafeProxy public proxy;

    bool public isUnlocked;

    constructor(address owner, bytes32 _seed) {
        //init both
        SafeProxy impl1 = new SafeSecret();
        SafeProxy impl2 = new SafeSecretAdmin();

        bytes32[] memory whitelist = new bytes32[](2);

        whitelist[0] = address(impl1).codehash;
        whitelist[1] = address(impl2).codehash;

        bytes memory init_data = abi.encodeCall(impl1.initialize, (owner, whitelist));

        address proxy_impl = address(new ERC1967Proxy(address(impl1), init_data));

        proxy = SafeProxy(proxy_impl);

        seed = _seed;

        isUnlocked = false;
    }

    function unlock(bytes32[3] calldata r, bytes32[3] calldata s) external {
        for (uint256 i = 0; i < 2; ++i) {
            require(uint256(r[i]) < uint256(r[i + 1]));
        }

        for (uint256 i = 0; i < 3; ++i) {
            check(r[i], s[i]);
        }

        isUnlocked = true;
    }

    function check(bytes32 _r, bytes32 _s) internal {
        uint8 v = 27;

        address owner = proxy.owner();

        //--------

        bytes32 message1_hash = keccak256(abi.encodePacked(seed, address(0xdead)));
        bytes32 r1 = transform_r1(_r);
        bytes32 s1 = transform_s1(_s);
        address signer = ecrecover(message1_hash, v, r1, s1);

        require(signer != address(0), "no sig match :<");
        require(signer == owner, "no owner match :<");

        //---------

        bytes32 message2_hash = keccak256(abi.encodePacked(seed, address(0xbeef)));
        bytes32 r2 = transform_r2(_r);
        bytes32 s2 = transform_s2(_s);
        address signer2 = ecrecover(message2_hash, v, r2, s2);

        require(signer2 != address(0), "no sig match :<");
        require(signer2 == owner, "no owner match :<");

        //--------
    }

    function transform_r1(bytes32 r) internal pure returns (bytes32) {
        return r;
    }

    function transform_s1(bytes32 s) internal view returns (bytes32) {
        return bytes32(uint256(s) ^ proxy.p2());
    }

    function transform_r2(bytes32 r) internal view returns (bytes32) {
        unchecked {
            return bytes32(uint256(r) + proxy.p1());
        }
    }

    function transform_s2(bytes32 s) internal view returns (bytes32) {
        return keccak256(abi.encodePacked(uint256(s) ^ proxy.p2(), seed));
    }
}
