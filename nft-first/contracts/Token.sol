// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ModifiedAccessContol is AccessControl{
    function revokeRole(bytes32 role,address account) public 
        override{
            
            // revert ("ModifiedAccessControl: cannot revoke role");
            require(
                role != DEFAULT_ADMIN_ROLE,
                "ModifiedAccessContol: cannot revoke default admin role"
            );
            //If the above doesn't fail then:

            super.revokeRole(role,account);
            //do what the default revoke role would do
    
    }
}

contract ERC20WithSafeTransfer is ERC20{
    
    //Provided hook, that help us code more efficiently
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        
        ///whenever overriding hooks we need to use virtual
        
        internal virtual override{
            
            //always use super here!
            super._beforeTokenTransfer(from,to,amount);

            require(_validRecipient(to),"ERC20WithSafeTransfer: Invalid recipient");
        }
    //Hooks are simply functions that are called before or after some action takes place.
    
    function _validRecipient(address to)
        private view returns (bool){
            return to != address(0);
        }

    constructor() ERC20("MyToken","MTK") {}
    
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


//in case we have upgradeability in mind
//please refer to https://docs.openzeppelin.com/contracts/4.x/upgradeable
//https://docs.openzeppelin.com/upgrades-plugins/1.x/
//https://forum.openzeppelin.com/t/openzeppelin-upgrades-step-by-step-tutorial-for-truffle/3579