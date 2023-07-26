// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../CampfiresQuestReward.sol";

contract CampfiresQuestRewardMock is CampfiresQuestReward {
    constructor(
        address verifier,
        address experiencePoint
    ) CampfiresQuestReward(verifier, experiencePoint) {}

    function mint(address to, uint256 id, uint256 amount) external {
        _mint(to, id, amount, "");
    }
}
