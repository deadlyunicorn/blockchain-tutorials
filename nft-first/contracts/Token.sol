// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ModifiedAccessContol is AccessControl{
    function revokeRole(bytes32,address) public 
        pure override{
        revert ("ModifiedAccessControl: cannot revoke role");
    }
}

contract MyToken is ERC20, AccessControl{

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE"); //custom roles
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor(
        // address minter, address burner
    ) ERC20("CoolToken","CTK"){

        // _grantRole(MINTER_ROLE, minter);
        // _grantRole(BURNER_ROLE, burner);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); 
        //predefined role
        //Admin role can grant-revoke roles.
    }   

    function mint(address to, uint256 amount) public 
        onlyRole(MINTER_ROLE){ //only the minter role
            _mint(to, amount); 
            // _commands are offered by zeppelin
        }
    function burn(address from, uint256 amount) public
        onlyRole(BURNER_ROLE){
            _burn(from,amount);
        }
}

//source https://docs.openzeppelin.com/contracts/4.x/access-control