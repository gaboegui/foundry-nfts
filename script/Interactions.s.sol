// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

/**
 * @author Gabriel Egguiguren P.
 * @title MintBasicNft
 * @notice This script mints a new BasicNft.
 */
contract MintBasicNft is Script {
    // pinata.cloud/ipfs
    string public constant URI_TIGER = "ipfs://bafkreifuoygrqqrxrds4i5fpbo44xr7n4gocefdlbylu32ojeo6xs56ybi";

    /**
     * @notice Mints a new BasicNft.
     * @dev This function gets the most recently deployed BasicNft contract and calls the mintNftOnContract function.
     */
    function run() external {
        // Obtain the address from the /broadcast/ directory
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNftOnContract(mostRecentDeployed);
    }

    /**
     * @notice Mints a new NFT on the provided contract address.
     * @param contractAddress The address of the BasicNft contract.
     */
    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(URI_TIGER);
        vm.stopBroadcast();
    }
}

/**
 * @author Gabriel Egguiguren P.
 * @title MintMoodNft
 * @notice This script mints a new MoodNft.
 */
contract MintMoodNft is Script {
    /**
     * @notice Mints a new MoodNft.
     * @dev This function gets the most recently deployed MoodNft contract and calls the mintNftOnContract function.
     */
    function run() external {
        // Obtain the address from the /broadcast/ directory
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        mintNftOnContract(mostRecentDeployed);
    }

    /**
     * @notice Mints a new NFT on the provided contract address.
     * @param contractAddress The address of the MoodNft contract.
     */
    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();
        vm.stopBroadcast();
    }
}
