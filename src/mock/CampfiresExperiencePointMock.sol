// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../CampfiresExperiencePoint.sol";

contract CampfiresExperiencePointMock is CampfiresExperiencePoint {
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
