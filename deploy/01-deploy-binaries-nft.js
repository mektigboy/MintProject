const { network } = require("hardhat");
const { verify } = require("../utils/verify");

module.exports = async function ({ deployments, getNamedAccounts }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId = network.config.chainId;

    log("--------------------------------------------------");

    const binariesNFT = await deploy("BinariesNFT", {
        args: [],
        from: deployer,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    });

    if (!chainId == 31337 && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...");
        await verify(binariesNFT.address, arguments);
    }
};

module.exports.tags = ["all", "binaries-nft"];
