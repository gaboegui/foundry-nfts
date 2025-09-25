// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    string public constant NFT_COLLECTION_NAME = "Funny Tigers";
    string public constant NFT_COLLECTION_SYMBOL = "FTIG";
    string public constant URI_TIGER = "ipfs://bafkreifuoygrqqrxrds4i5fpbo44xr7n4gocefdlbylu32ojeo6xs56ybi";
    address public USER = makeAddr("user");

    DeployBasicNft public deployer;
    BasicNft public basicNft;

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNftNameIsCorrect() public {
        // strings cannot be directly compared
        // so we encode first and the obtain the hash to compare
        require(keccak256(abi.encodePacked(NFT_COLLECTION_NAME)) == keccak256(abi.encodePacked(basicNft.name())));
    }

    function testNftSymbolIsCorrect() public {
        require(keccak256(abi.encodePacked(NFT_COLLECTION_SYMBOL)) == keccak256(abi.encodePacked(basicNft.symbol())));
    }

    function testMintNftAndHaveBalance() public {
        // Arrange / Act
        vm.prank(USER);
        basicNft.mintNft(URI_TIGER);
        // Assert
        require(basicNft.balanceOf(USER) == 1);
        require(keccak256(abi.encodePacked(URI_TIGER)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
