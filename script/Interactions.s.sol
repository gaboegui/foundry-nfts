// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {
    // pinata.cloud/ipfs
    string public constant URI_TIGER = "ipfs://bafkreifuoygrqqrxrds4i5fpbo44xr7n4gocefdlbylu32ojeo6xs56ybi";

    function run() external {
        // Obtain the address from the /broadcast/ directory
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNftOnContract(mostRecentDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(URI_TIGER);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script {
    function run() external {
        // Obtain the address from the /broadcast/ directory
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        mintNftOnContract(mostRecentDeployed);
    }
    
    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();
        vm.stopBroadcast();
    }
}
