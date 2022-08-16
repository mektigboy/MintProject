const { assert } = require("chai");
const { developmentChains } = require("../helper-hardhat-config");
const { network, deployments, ethers } = require("hardhat");

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Binaries NFT Unit Tests:", function () {
          let binariesNFT, deployer;

          beforeEach(async function () {
              accounts = await ethers.getSigners();
              deployer = accounts[0];
              await deployments.fixture(["binaries-nft"]);
              binariesNFT = await ethers.getContract("BinariesNFT");
          });

          it("Allows users to mint an NFT, and updates appropriately.", async function () {
              await binariesNFT.setIsPublicMintEnabled(true);
              const transactionResponse = await binariesNFT.mintNFT(1, {
                  value: ethers.utils.parseEther("0.01"),
              });
              await transactionResponse.wait(1);
              const tokenURI = await binariesNFT.tokenURI(0);
              const tokenCounter = await binariesNFT.s_tokenCounter();
              assert.equal(tokenCounter.toString(), "1");
              assert.equal(tokenURI, await binariesNFT.TOKEN_URI());
          });
      });
