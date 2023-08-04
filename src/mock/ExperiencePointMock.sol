// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../ExperiencePoint.sol";

contract ExperiencePointMock is ExperiencePoint {
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
