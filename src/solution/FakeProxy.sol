// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract FakeProxy {
    address[3] internal owners;
    uint256[3] internal p1s;
    uint256[6] internal p2s;

    function set() external {
        owners[0] = 0x998F85Bc7b4ba9C292B3260a8A38a34159B4B6fA;
        owners[1] = 0xE4dEcFeE1914A362741511a03087Cbc89f1e408F;
        owners[2] = 0xfd894c00f15483328D33b8b63F6091C69ad9E28E;
        p1s[0] = 0x6481f7548bc67dc6c703b34ec273cb8bc28269cc5fc12950b9e3bd6d004038dd;
        p1s[1] = 0x029cc13906046059f12700d96b75c153ce5b101e3e827d69c00b2660a624f29d;
        p1s[2] = 0xe85305c0aaacb4f02489bdb2861c40d5b0f1fad29e9e1b4004866f25846471ad;
        p2s[0] = 0x97ca399f33688258c2b57d7240a88421b2c6701b85a2fecdc690ee52eb06d5b7;
        // s2: 0xac18d7cd67de0325cc1d4eab3ec648e0b3cf6a6e2d4a63afeabb49bf54de95e5
        p2s[1] = 0xb0ce69e2c7ee3ce6bd82494589255fe2f64d6b828f7807395e948f714902b01f;
        p2s[2] = 0xbdc03ec5e80d5407ca49e00dc1f4db17f98dae40724ff0ac5dda4f0a46f83e9c;
        // s2: 0x508f5ce4cfa2fb9791049ac6cfa06b047b8af0f3e752702e959c95d400fb8685
        p2s[3] = 0x80a0195d23d8ecfd96cda7f1cf36071522d8642d2ff7e0d02926f2127d5a4e3b;
        p2s[4] = 0x4ce9c0dcf3397dc60fc6a9bdec708d5005dc673d9ef6bcec9174ccbc27d6ef1d;
        // s2: 0xdfd556a9816a190ffca9a4dcde05653093e934a55294ac64b335510e2468d18a
        p2s[5] = 0xe65f267cdfff46f6e615ae9e6250e6ca09b75201b2a0e45bc8e98acfb1953b28;
    }

    function owner() external view returns (address) {
        uint256 i = 0;
        unchecked {
            while (true) {
                uint256 preGas = gasleft();
                address addr = owners[i];
                uint256 afterGas = gasleft();

                if (preGas - afterGas > 2100) return addr;

                i++;
            }
        }
        revert();
    }

    function p1() external view returns (uint256) {
        uint256 i = 0;
        unchecked {
            while (true) {
                uint256 preGas = gasleft();
                uint256 p = p1s[i];
                uint256 afterGas = gasleft();

                if (preGas - afterGas > 2100) return p;

                i++;
            }
        }
        revert();
    }

    function p2() external view returns (uint256) {
        uint256 i = 0;
        unchecked {
            while (true) {
                uint256 preGas = gasleft();
                uint256 p = p2s[i];
                uint256 afterGas = gasleft();

                if (preGas - afterGas > 2100) return p;

                i++;
            }
        }
        revert();
    }
}
