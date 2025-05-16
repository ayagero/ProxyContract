// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Implementation {
    uint256 public value;

    // Initializer instead of constructor
    function initialize(uint256 _value) external {
        require(value == 0, "Already initialized");
        value = _value;
    }

    // Sample function to set value
    function setValue(uint256 _value) external {
        value = _value;
    }

    // Sample function to get value
    function getValue() external view returns (uint256) {
        return value;
    }
}
