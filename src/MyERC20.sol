// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ENSMetadata} from "ENSMetadataStandard/ENSMetadata.sol";

contract MyToken is ERC20, ERC20Permit, ENSMetadata {
    constructor()
        ERC20("MyToken", "MTK")
        ERC20Permit("MyToken")
        ENSMetadata(
            "The World Token Project",
            "This token is for the world token project",
            "worldtokenproject.eth"
        )
    {}
    // Function to trigger ENS verification
    function triggerENSVerification() public onlyOwner returns (bool) {
        return verifyENS();
    }
}
