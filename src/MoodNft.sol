// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @author Gabriel Egguiguren P.
 * @title MoodNft
 * @notice This contract implements an NFT that can change its mood.
 */
contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    // State variables
    string private constant NAME = "Mood NFT";
    string private constant SYMBOL = "MOOD";
    string private constant DESCRIPTION = "An NFT that reflects the mood of the owner";

    uint256 private s_tokenCounter;
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;

    /**
     * @notice Represents the two moods of the NFT.
     */
    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    // Events
    event CreatedNFT(uint256 indexed tokenId);

    /**
     * @notice Initializes the contract, setting the URIs for the happy and sad SVG images.
     * @param happySvgImgUri The URI for the happy mood SVG image.
     * @param sadSvgImgUri The URI for the sad mood SVG image.
     */
    constructor(string memory happySvgImgUri, string memory sadSvgImgUri) ERC721("Mood NFT", "MOOD") {
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgImgUri;
        s_sadSvgImageUri = sadSvgImgUri;
    }

    /**
     * @notice Mints a new NFT and assigns it to the caller.
     * The default mood is HAPPY.
     */
    function mintNft() public {
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        s_tokenIdToMood[tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
        emit CreatedNFT(tokenCounter);
    }

    /**
     * @notice Flips the mood of the NFT.
     * @param tokenId The ID of the token to flip.
     * @dev Only the owner of the NFT can flip its mood.
     */
    function flipTokenMood(uint256 tokenId) public {
        // _isApprovedOrOwner from ERC721
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    /**
     * @notice Returns the base URI for the token metadata.
     */
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    /**
     * @notice Returns the URI for the token's metadata.
     * @param tokenId The ID of the token.
     * @return A string containing the token's metadata URI.
     */
    function tokenUri(uint256 tokenId) public returns (string memory) {
        string memory imageUri;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happySvgImageUri;
        } else {
            imageUri = s_sadSvgImageUri;
        }

        return string(
            abi.encodePacked( // abi.encodePacked is for concat
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            NAME,
                            '", "description":"',
                            DESCRIPTION,
                            '", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
