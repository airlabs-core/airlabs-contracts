// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin-contracts/access/AccessControl.sol";

/// @title ExperiencePoint
/// @author Carlo Miguel Dy
contract ExperiencePoint is ERC20, AccessControl {
    /* ---------------------------------------- */
    /*                PROPERTIES                */
    /* ---------------------------------------- */
    bytes32 public constant QUEST_REWARD_ROLE = keccak256("QUEST_REWARD_ROLE");

    bytes32 public constant LAND_PARCEL_ROLE = keccak256("LAND_PARCEL_ROLE");

    address public questReward;

    address public landParcel;
    /* -----------------*****------------------ */

    /* ---------------------------------------- */
    /*                  EVENTS                  */
    /* ---------------------------------------- */
    event SetQuestReward(address indexed questReward);

    /* -----------------*****------------------ */

    constructor() ERC20("Experience Point", "EXP") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /* ---------------------------------------- */
    /*             PUBLIC FUNCTIONS             */
    /* ---------------------------------------- */
    function setLandParcel(
        address _landParcel
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // landParcel can't be set to immutable
        require(landParcel == address(0), "landParcel already set");
        require(_landParcel != address(0), "_landParcel empty addr");

        landParcel = _landParcel;
        _setupRole(LAND_PARCEL_ROLE, _landParcel);

        emit SetQuestReward(_landParcel);
    }

    function setQuestReward(
        address _questReward
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // questReward can't be set to immutable
        require(questReward == address(0), "questReward already set");
        require(_questReward != address(0), "_questReward empty addr");

        questReward = _questReward;
        _setupRole(QUEST_REWARD_ROLE, _questReward);

        emit SetQuestReward(_questReward);
    }

    function mintTo(
        address _to,
        uint256 _amount
    ) external onlyRole(QUEST_REWARD_ROLE) {
        require(_to != address(0), "to empty addr");

        _mint(_to, _amount);
    }

    function burn(address account, uint256 amount) external {
        require(
            hasRole(LAND_PARCEL_ROLE, _msgSender()) ||
                hasRole(QUEST_REWARD_ROLE, _msgSender()),
            "unauthorized"
        );
        _burn(account, amount);
    }
    /* -----------------*****------------------ */
}
