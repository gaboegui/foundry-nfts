// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    string private constant NAME = "Mood NFT";
    string private constant SYMBOL = "MOOD";
    string private constant DESCRIPTION = "An NFT that reflects the mood of the owner";

    uint256 private s_tokenCounter;
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(string memory happySvgImgUri, string memory sadSvgImgUri) ERC721("Mood NFT", "MOOD") {
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgImgUri;
        s_sadSvgImageUri = sadSvgImgUri;
    }

    function mintNft() public {
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        s_tokenIdToMood[tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
        emit CreatedNFT(tokenCounter);
    }

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

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

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
