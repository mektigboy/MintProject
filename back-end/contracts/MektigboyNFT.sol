// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MektigboyNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maximumSupply;
    uint256 public maximumPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenURI;
    address payable public withdrawAddress;

    mapping(address => uint256) public tracker;

    constructor() payable ERC721("MektigboyNFT", "MNFT") {
        mintPrice = 0.01 ether;
        totalSupply = 0;
        maximumSupply = 1000;
        maximumPerWallet = 5;
        withdrawAddress = payable(0xa7a0275220A00ae3B360F7cB080069063e886271);
    }

    function setIsPublicMintEnabled(bool isPublicMintEnabled_)
        external
        onlyOwner
    {
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    function setBaseTokenURI(string calldata baseTokenURI_) external onlyOwner {
        baseTokenURI = baseTokenURI_;
    }

    function tokenURI(uint256 tokenId_)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId_), "Token does not exist!"); // Change to if.
        return
            string(
                abi.encodePacked(
                    baseTokenURI,
                    Strings.toString(tokenId_),
                    ".json"
                )
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawAddress.call{value: address(this).balance}(
            ""
        );
        require(success, "Withdraw failed."); // Change to if.
    }

    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, "Minting is not enabled."); // Change to if.
        require(msg.value == quantity_ * mintPrice, "Wrong mint value."); // Change to if.
        require((totalSupply + quantity_) <= maximumSupply, "Sold out."); // Change to if.
        require(
            (tracker[msg.sender] + quantity_) <= maximumPerWallet,
            "Exceeded maximum per wallet."
        );
        for (uint256 i = 0; i < quantity_; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }
}
