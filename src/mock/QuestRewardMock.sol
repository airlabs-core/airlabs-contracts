// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../QuestReward.sol";

contract QuestRewardMock is QuestReward {
    constructor(
        address verifier,
        address experiencePoint
    ) QuestReward(verifier, experiencePoint) {}

    function mint(address to, uint256 id, uint256 amount) external {
        _mint(to, id, amount, "");
    }
}
