// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auth{
    address private _admin;

    event ValueChanged(uint256 value);

    constructor(address deployer){
        _admin=deployer;
    }

    function isAdministrator(address user) public view 
        returns (bool){
            return user == _admin;
        }
}