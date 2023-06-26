// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "./Auth.sol";

contract Box{
    uint256 private _value;
    Auth private _auth; //Auth is a contract object.

    event ValueChanged(uint256 value);

    constructor(){
        _auth = new Auth(msg.sender); //the deployer gets auth
    }

    function store(uint256 value) public{
        
        //Only admin can store values.
        require(_auth.isAdministrator((msg.sender)),"Unautorized");
        
        _value=value;
        emit ValueChanged(value);
    }

    function retrieve() public view returns (uint256){
        return _value;
    }
}