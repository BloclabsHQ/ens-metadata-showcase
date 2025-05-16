// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {ENSMetadata} from "ENSMetadataStandard/ENSMetadata.sol";

contract MyToken is ERC1155, Ownable, ENSMetadata {
    constructor(address initialOwner, address _ensRegistry) 
        ERC1155("https://example.com") 
        Ownable(initialOwner)
        ENSMetadata(
            "ENS Metadata ERC1155",
            "An example ERC1155 contract showcasing ENS metadata integration",
            "ensmetadata1155.eth",
            _ensRegistry,
            new string[](0), // Empty array for social media links
            ""  // Empty string for external data URI
        )
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }
}
