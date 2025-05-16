// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library StorageSlot {
    // Set address in specific storage slot
    function setAddress(bytes32 slot, address _address) internal {
        assembly {
            sstore(slot, _address)
        }
    }

    // Get address from specific storage slot
    function getAddress(bytes32 slot) internal view returns (address) {
        address addr;
        assembly {
            addr := sload(slot)
        }
        return addr;
    }
}
