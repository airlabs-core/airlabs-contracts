// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/// @title CampfiresLandParcel
/// @author Carlo Miguel Dy
contract CampfiresLandParcel is ERC721A, AccessControl {
    bytes32 public constant CAMPFIRES_EXPERIENCE_POINT_ROLE =
        keccak256("CAMPFIRES_EXPERIENCE_POINT_ROLE");

    address public campfiresExperiencePoint;

    constructor(
        address _campfiresExperiencePoint
    ) ERC721A("Campfires Land Parcel", "CLP") {
        require(
            _campfiresExperiencePoint != address(0),
            "_campfiresExperiencePoint empty addr"
        );

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(CAMPFIRES_EXPERIENCE_POINT_ROLE, _campfiresExperiencePoint);

        campfiresExperiencePoint = _campfiresExperiencePoint;
    }

    function claimLandParcel(uint256 experiencePoints) external {
        // TODO: Need more information on claiming land parcels
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(AccessControl, ERC721A) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
