const hre = require("hardhat");

async function main() {
    const BinariesNFT = await hre.ethers.getContractFactory("BinariesNFT");
    const binariesNFT = await BinariesNFT.deploy();

    await binariesNFT.deployed();

    console.log("BinariesNFT deployed to: ", binariesNFT.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });
