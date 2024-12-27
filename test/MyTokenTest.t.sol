// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyERC20.sol";
import "ens-metadata-standard/test/utils/mockEnsRegistry.t.sol"; // Import the mock
import "ens-metadata-standard/test/utils/mockENSResolver.t.sol";
import "ens-metadata-standard/src/ENSVerificationLib.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    MockENSRegistry public mockENSRegistry;
    MockENSResolver public mockENSResolver;

    address public constant OWNER = address(0x123);
    address public constant USER = address(0x456);

    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 1e18;
    uint256 public constant MINT_AMOUNT = 500 * 1e18;
    uint256 public constant BURN_AMOUNT = 200 * 1e18;

    string public constant METADATA_TITLE = "The World Token Project";
    string public constant METADATA_DESCRIPTION =
        "This token is for the world token project";
    string public constant METADATA_ENS_NAME = "worldtokenproject.eth";

    function setUp() public {
        // Deploy the mock ENS registry
        mockENSRegistry = new MockENSRegistry();
        mockENSResolver = new MockENSResolver();

        // Set up mock ENS ownership and resolver
        bytes32 node = ENSVerificationLib.namehash(METADATA_ENS_NAME);
        mockENSRegistry.setOwner(node, OWNER);
        mockENSRegistry.setResolver(node, address(mockENSResolver)); // Simplified resolver

        // Deploy the MyToken contract
        vm.prank(OWNER); // Simulate OWNER deploying the contract
        myToken = new MyToken(address(mockENSRegistry));
        mockENSResolver.setAddr(node, address(myToken));
    }

    function testMetadataInitialization() public view {
        // Fetch the metadata
        (
            string memory title,
            string memory description,
            string memory ENS_name,
            bool verification
        ) = myToken.getMetadata();

        // Assertions
        assertEq(title, METADATA_TITLE, "Metadata title mismatch");
        assertEq(
            description,
            METADATA_DESCRIPTION,
            "Metadata description mismatch"
        );
        assertEq(ENS_name, METADATA_ENS_NAME, "Metadata ENS name mismatch");
        assertFalse(verification, "Verification should initially be false");
    }

    function testVerifyENS() public {
        // Simulate OWNER verifying the ENS name
        vm.prank(OWNER);
        bool verification = myToken.verifyENS();

        // Assertions
        assertTrue(verification, "ENS verification failed");

        // Fetch updated metadata
        (, , , bool updatedVerification) = myToken.getMetadata();
        assertTrue(
            updatedVerification,
            "Verification status not updated in metadata"
        );
    }

    function test_RevertIf_UnauthorizedVerification() public {
        // Attempt verification from a non-owner
        vm.prank(USER);
        vm.expectRevert("Caller is not the owner of the ENS name");
        myToken.verifyENS();
    }

    function testMint() public {
        vm.prank(OWNER); // Only the owner can mint
        myToken.mint(USER, MINT_AMOUNT);

        // Assertions
        assertEq(
            myToken.balanceOf(USER),
            MINT_AMOUNT,
            "Minted amount mismatch"
        );
    }

    function testBurn() public {
        vm.prank(OWNER);
        myToken.mint(USER, MINT_AMOUNT);

        // Simulate USER burning tokens
        vm.prank(USER);
        myToken.burn(BURN_AMOUNT);

        // Assertions
        assertEq(
            myToken.balanceOf(USER),
            MINT_AMOUNT - BURN_AMOUNT,
            "Burned amount mismatch"
        );
    }
}
