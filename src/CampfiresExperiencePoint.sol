// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CampfiresExperiencePoint is ERC20, AccessControl {
    bytes32 public constant CAMPFIRES_QUEST_REWARD_ROLE =
        keccak256("CAMPFIRES_QUEST_REWARD_ROLE");
    address public campfiresQuestReward;

    event SetCampfiresQuestReward(address indexed campfiresQuestReward);

    constructor() ERC20("Campfires Experience Point", "CEP") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function setCampfiresQuestReward(
        address _campfiresQuestReward
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // campfiresQuestReward can't be set to immutable
        require(
            campfiresQuestReward == address(0),
            "campfiresQuestReward already set"
        );
        require(
            _campfiresQuestReward != address(0),
            "_campfiresQuestReward empty addr"
        );

        campfiresQuestReward = _campfiresQuestReward;
        _setupRole(CAMPFIRES_QUEST_REWARD_ROLE, _campfiresQuestReward);

        emit SetCampfiresQuestReward(_campfiresQuestReward);
    }

    function mintTo(
        address _to,
        uint256 _amount
    ) external onlyRole(CAMPFIRES_QUEST_REWARD_ROLE) {
        require(_to != address(0), "to empty addr");

        _mint(_to, _amount);
    }

    function burn(
        address account,
        uint256 amount
    ) external onlyRole(CAMPFIRES_QUEST_REWARD_ROLE) {
        _burn(account, amount);
    }
}
