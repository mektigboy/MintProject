require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL;

module.exports = {
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
    networks: {
        rinkeby: {
            accounts: [PRIVATE_KEY],
            url: RINKEBY_RPC_URL,
        },
    },
    solidity: "0.8.15",
};
