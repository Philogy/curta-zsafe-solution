// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {console2 as console} from "forge-std/console2.sol";

/// @author philogy <https://github.com/philogy>
contract EcdsaScript is Test, Script {
    uint256 constant seed = 0x448929bc365512b28e88aec7b1fd95df9285e14ea2a142d10b2eca2b56e0b70f;
    bytes32 constant m2 = 0xadbae117f01e0a3579f0fea07c18b5305811c34020ea795071642263fc95041b;

    function run() public {
        uint8 v = 27;

        bytes32 p2 = keccak256("start_p2");
        address recovered;
        bytes32 s2;
        bytes32[] memory r2Table = table();

        uint256 i = 1;
        bytes32 r2;

        do {
            r2 = r2Table[i];
            s2 = keccak256(abi.encodePacked(p2, seed));
            recovered = ecrecover(m2, v, r2, s2);
            i++;
        } while (recovered == address(0));

        console.log("recovered: %s in %d iterations", recovered, i);
        console.log("v: %d", v);
        console.log("r2: %x", uint256(r2));
        console.log("s2: %x", uint256(s2));
    }

    function table() internal pure returns (bytes32[] memory r2Table) {
        r2Table = new bytes32[](20);
        // 0x4623f82604472e8d2c2826da87b2687e37fb8c6bfdef706839e09b1f76d02928 -> 0x25754bacf4bcda71a2ed7ea0aad66661cb39bc7018f3ffd2a5bb9bfe0552ad7d
        r2Table[0] = 0x25754bacf4bcda71a2ed7ea0aad66661cb39bc7018f3ffd2a5bb9bfe0552ad7d;
        // 0x648c8b10cf8a2d7f56409f7260f42154d15e3fd4bf8a9991f2542083f92ac75d -> 0x6da360f3ede7e6d327e539b3378888a3425c336a90d5c514a7f866af73ac362f
        r2Table[1] = 0x6da360f3ede7e6d327e539b3378888a3425c336a90d5c514a7f866af73ac362f;
        // 0x898e58d56ddc20f720afa1f6c18254d405bcbfe68655e870b2d137532e09f2c7 -> 0x10a6304203f4ee294c9ef106a3e71b47531b2b20653b0ebae360e85e8d47b88e
        r2Table[2] = 0x10a6304203f4ee294c9ef106a3e71b47531b2b20653b0ebae360e85e8d47b88e;
        // 0x672ea63897992aadb7dad0b3507c6b01e0f0f0fe3d4a02703ae145c8a02d1d01 -> 0x52062fefbdd5e2174386ffe96da888198aac3d4b61800f9bff2d07b8a2353496
        r2Table[3] = 0x52062fefbdd5e2174386ffe96da888198aac3d4b61800f9bff2d07b8a2353496;
        // 0x171c78a594a9c2310afb52696e1107952569951ade1dc79e33b2f735fec532b3 -> 0xf7f66ac85e1e14abfa139fdd017d87bcf86315fac5f503e3be98bef417475581
        r2Table[4] = 0xf7f66ac85e1e14abfa139fdd017d87bcf86315fac5f503e3be98bef417475581;
        // 0x88bad38feb3801931f8ac1b88df016549e104d8fb3ab6ed274f2fb5e536c34ee -> 0x1511bf55c43287b8000b0f3c4b9960ffa22ba05a7902b933f7142d806e74bded
        r2Table[5] = 0x1511bf55c43287b8000b0f3c4b9960ffa22ba05a7902b933f7142d806e74bded;
        // 0xefdce7bec5ecd4f33eef4eff2d490252ac13ccfa1e7a28f8275a47c6ea378f04 -> 0x0e338babd4485511b0abe68f39944b743b3aeab080d550e36d886dc2c4e3e2ae
        r2Table[6] = 0x0e338babd4485511b0abe68f39944b743b3aeab080d550e36d886dc2c4e3e2ae;
        // 0x14dc338aba494aca81cdc770ed557837c0c38a572d54b70f72d4513f00c4487c -> 0x46c38254d3ad8cc9ab47ffea2f67346a5694c601a852faeb342095c46f03fc04
        r2Table[7] = 0x46c38254d3ad8cc9ab47ffea2f67346a5694c601a852faeb342095c46f03fc04;
        // 0xc5b6be537124c37d293d007a0008ec28eb83f40225e2d52abac9dffdd6486c84 -> 0x390936617e58ef352f23a756d94b56394540ad4d75e2c92bceb06b9b73e32101
        r2Table[8] = 0x390936617e58ef352f23a756d94b56394540ad4d75e2c92bceb06b9b73e32101;
        // 0xabe4cfe98adf9fc329b802bc08da2eb69ff82d4ccc2ee5ab0fe870a5624f5f3f -> 0xb5662459cec88fe6380643525f0c53a3b0fa74b6d8d467adb0d45ff259755c18
        r2Table[9] = 0xb5662459cec88fe6380643525f0c53a3b0fa74b6d8d467adb0d45ff259755c18;
        // 0x7ddd27fac83afc518766b8e374921edff46933c5ea4bb56896fffdf34092daa3 -> 0x21daecc12b6d5043d23c08e38fd7a5927da5f2e1416f47938b54880572212d8d
        r2Table[10] = 0x21daecc12b6d5043d23c08e38fd7a5927da5f2e1416f47938b54880572212d8d;
        // 0x8511a9fa26971215ca8b835f1ff0acbb51dbfd350de4cfcc0d54242f9ae0c8ab -> 0x1d5a2f37829cc8436f8a9967843503bbe069b89983688a36201c9c6c8e35badc
        r2Table[11] = 0x1d5a2f37829cc8436f8a9967843503bbe069b89983688a36201c9c6c8e35badc;
        // 0xabba0f23582f2132e920e95e6ebd3064bf82ae6e8d4b4f8715f7d63d81544793 -> 0xd5006e50af9c5aeba337937f75119a394be0b7a4d20c67f553da86efe82c0ace
        r2Table[12] = 0xd5006e50af9c5aeba337937f75119a394be0b7a4d20c67f553da86efe82c0ace;
        // 0x66b1058540835c3a9f3e999c23c161db3fd2a383273a2f4c6cbc4ec97499db23 -> 0xbaafb1734cb8c43c45dd24112ca5eed85a3225db0efc1a31062d1157a88ef02e
        r2Table[13] = 0xbaafb1734cb8c43c45dd24112ca5eed85a3225db0efc1a31062d1157a88ef02e;
        // 0x90e4beae54a60baa1b0e282d63e22e711febb9dc11bf40e5d2e54fbd097cb783 -> 0x19d4cf1475c3e9608c18c786db5a220f8442b5920f5f5b3c4f795e689499045d
        r2Table[14] = 0x19d4cf1475c3e9608c18c786db5a220f8442b5920f5f5b3c4f795e689499045d;
        // 0x8bfce197e5c2c77b970f04999ac1a2a49ae0cab418fbf117a1d703f687c7f65c -> 0x7594ce39c7ffdda3e361ad58907f84be5a0c19c91af8fb8c9db76cd0e73ce4c5
        r2Table[15] = 0x7594ce39c7ffdda3e361ad58907f84be5a0c19c91af8fb8c9db76cd0e73ce4c5;
        // 0x1c3e5295a621b7c9135be3304a8bcd33640c92bda85a1228238f3f9f9249ff63 -> 0x7f09343b87c0a7f167a45807df1abd94dabf9a9fd386a179a78855b946905673
        r2Table[16] = 0x7f09343b87c0a7f167a45807df1abd94dabf9a9fd386a179a78855b946905673;
        // 0x9cec99d2bbaef71dae6a57014f779bf50ff39d1b004f792d3135b8824040cc28 -> 0x4180ec0558acefbb3ea871f5080c6ab8d83193902716313b3eabb49d4b4d35c5
        r2Table[17] = 0x4180ec0558acefbb3ea871f5080c6ab8d83193902716313b3eabb49d4b4d35c5;
        // 0x5efc1683fd3a68612e5a9be92d1c984e5ad453c80c28e161179f82fd4bd34085 -> 0x85705d5ad31fcadf230a245baeedfdf531ca39970b57f43b27d8f0af8c237c82
        r2Table[18] = 0x85705d5ad31fcadf230a245baeedfdf531ca39970b57f43b27d8f0af8c237c82;
        // 0xfcbcd04c9d34872bb64affb7fa99dcba218497a5ded814d286ef328b45e39bc2 -> 0xd4121949bb63f9f63e54bb1315516c67cfa70b4573de5a3442a01780a43870b8
        r2Table[19] = 0xd4121949bb63f9f63e54bb1315516c67cfa70b4573de5a3442a01780a43870b8;
    }
}
