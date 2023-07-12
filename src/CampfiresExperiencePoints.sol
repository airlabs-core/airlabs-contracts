// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CampfiresExperiencePoints is ERC20, AccessControl {
    bytes32 public constant CAMPFIRES_QUEST_REWARDS_ROLE =
        keccak256("CAMPFIRES_QUEST_REWARDS_ROLE");
    address public campfiresQuestRewards;

    event SetCampfiresQuestRewards(address indexed campfiresQuestRewards);

    constructor() ERC20("Campfires Experience Points", "CEP") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function setCampfiresQuestRewards(
        address _campfiresQuestRewards
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // campfiresQuestRewards can't be set to immutable
        require(
            campfiresQuestRewards == address(0),
            "campfiresQuestRewards already set"
        );
        require(
            _campfiresQuestRewards != address(0),
            "_campfiresQuestRewards empty addr"
        );

        campfiresQuestRewards = _campfiresQuestRewards;
        _setupRole(CAMPFIRES_QUEST_REWARDS_ROLE, _campfiresQuestRewards);

        emit SetCampfiresQuestRewards(_campfiresQuestRewards);
    }

    function mintTo(
        address _to,
        uint256 _amount
    ) external onlyRole(CAMPFIRES_QUEST_REWARDS_ROLE) {
        require(_to != address(0), "to empty addr");

        _mint(_to, _amount);
    }

    function burn(
        address account,
        uint256 amount
    ) external onlyRole(CAMPFIRES_QUEST_REWARDS_ROLE) {
        _burn(account, amount);
    }
}
