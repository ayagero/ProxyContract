// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./StorageSlot.sol";

contract Proxy {
    // EIP-1967 storage slots
    bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 private constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    // Event emitted when implementation is upgraded
    event Upgraded(address indexed implementation);

    // Constructor sets initial admin and implementation
    constructor(address _implementation) {
        StorageSlot.setAddress(ADMIN_SLOT, msg.sender);
        StorageSlot.setAddress(IMPLEMENTATION_SLOT, _implementation);
    }

    // Modifier to restrict access to admin
    modifier onlyAdmin() {
        require(msg.sender == StorageSlot.getAddress(ADMIN_SLOT), "Not admin");
        _;
    }

    // Fallback function delegates calls to implementation
    fallback() external payable {
        // Check if caller is admin; if so, handle in proxy
        if (msg.sender == StorageSlot.getAddress(ADMIN_SLOT)) {
            revert("Admin cannot call implementation");
        }

        address implementation = StorageSlot.getAddress(IMPLEMENTATION_SLOT);
        require(implementation != address(0), "Implementation not set");

        // Delegatecall to implementation
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
        require(success, "Delegatecall failed");

        // Return data from implementation
        assembly {
            return(add(data, 0x20), mload(data))
        }
    }

    // Receive function for ETH
    receive() external payable {}

    // Upgrade implementation (admin only)
    function upgradeTo(address _newImplementation) external onlyAdmin {
        require(_newImplementation != address(0), "Invalid implementation");
        StorageSlot.setAddress(IMPLEMENTATION_SLOT, _newImplementation);
        emit Upgraded(_newImplementation);
    }

    // Get current implementation address
    function getImplementation() external view returns (address) {
        return StorageSlot.getAddress(IMPLEMENTATION_SLOT);
    }

    // Get admin address
    function getAdmin() external view returns (address) {
        return StorageSlot.getAddress(ADMIN_SLOT);
    }
}
