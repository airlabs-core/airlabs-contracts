// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/// @title CampfiresLandParcel
/// @author Carlo Miguel Dy
contract CampfiresLandParcel is ERC721A, AccessControl {
    constructor() ERC721A("Campfires Land Parcel", "CLP") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(AccessControl, ERC721A) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
