// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @author Gabriel Egguiguren P.
 * @title DeployMoodNft
 * @notice This script deploys the MoodNft contract.
 */
contract DeployMoodNft is Script {
    /**
     * @notice Deploys the MoodNft contract.
     * @return The deployed MoodNft contract.
     * @dev This function reads the SVG files for the happy and sad moods, converts them to image URIs, and then deploys the MoodNft contract with these URIs.
     */
    function run() external returns (MoodNft) {
        string memory happySvg = vm.readFile("./img/mood/happy.svg");
        string memory sadSvg = vm.readFile("./img/mood/sad.svg");

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(svgToImageURI(happySvg), svgToImageURI(sadSvg));
        vm.stopBroadcast();
        return moodNft;
    }

    /**
     * @notice Converts an SVG string to a data URI.
     * @param svg The SVG string to convert.
     * @return The data URI for the SVG.
     */
    function svgToImageURI(string memory svg) public pure returns (string memory) {
        // example: '<svg width="500" height="500" viewBox="0 0 285 350" ..... </path></svg>'
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg))) // Removing unnecessary type castings, this line can be resumed as follows : 'abi.encodePacked(svg)'
        );
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}
