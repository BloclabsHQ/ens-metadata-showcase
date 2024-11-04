// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ENSMetadata} from "ENSMetadataStandard/ENSMetadata.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyToken is ERC20, ERC20Permit, Pausable, Ownable, ENSMetadata {
    constructor(
        address _ensRegistry
    )
        ERC20("MyToken", "MTK")
        ERC20Permit("MyToken")
        ENSMetadata(
            "The World Token Project",
            "This token is for the world token project",
            "worldtokenproject.eth",
            _ensRegistry
        )
    {}

    // Minting function to create new tokens
    // Allows the owner to mint additional tokens, increasing the total supply
    function mint(
        address to,
        uint256 amount
    ) public onlyOwner withContext("Minting new tokens by the owner") {
        _mint(to, amount);
    }

    // Burning function to reduce the total supply
    // Allows a token holder to burn their tokens, decreasing the total supply
    function burn(
        uint256 amount
    ) public withContext("Burning tokens by the holder") {
        _burn(msg.sender, amount);
    }

    // Pausable function to stop all transfers temporarily
    // Allows the owner to pause token transfers in case of an emergency
    function pause()
        public
        onlyOwner
        withContext("Pausing token transfers by the owner")
    {
        _pause();
    }

    // Unpause function to resume transfers
    // Allows the owner to resume token transfers once the emergency is resolved
    function unpause()
        public
        onlyOwner
        withContext("Unpausing token transfers by the owner")
    {
        _unpause();
    }

    // Function to renounce ownership
    // Allows the owner to renounce ownership, making the contract ownerless and removing centralized control
    function renounceOwnership()
        public
        override
        onlyOwner
        withContext("Renouncing ownership by the owner")
    {
        super.renounceOwnership();
    }
}
