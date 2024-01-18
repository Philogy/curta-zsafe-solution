// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IReinitFactory {
    function mode() external view returns (bool copy, address target);

    function destroy() external;
}
