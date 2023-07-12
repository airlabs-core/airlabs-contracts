// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "erc721a/contracts/ERC721A.sol";

contract CampfiresLandParcel is ERC721A {
    constructor() ERC721A("Campfires Land Parcel", "CLP") {}
}
