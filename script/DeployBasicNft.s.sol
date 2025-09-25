// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";

/**
 * @author Gabriel Egguiguren P.
 * @title DeployBasicNft
 * @notice This script deploys the BasicNft contract.
 */
contract DeployBasicNft is Script {
    /**
     * @notice Deploys the BasicNft contract.
     * @return The deployed BasicNft contract.
     */
    function run() external returns (BasicNft) {
        vm.startBroadcast();
        BasicNft basicNft = new BasicNft();
        vm.stopBroadcast();
        return basicNft;
    }
}
