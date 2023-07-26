// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../CampfiresLandParcel.sol";

contract CampfiresLandParcelMock is CampfiresLandParcel {
    constructor(
        address _experiencePoint,
        address _erc6551Implementation,
        address _erc6551Registry
    )
        CampfiresLandParcel(
            _experiencePoint,
            _erc6551Implementation,
            _erc6551Registry
        )
    {}

    function mint(address to, uint256 quantity) external {
        _mint(to, quantity);
    }
}
