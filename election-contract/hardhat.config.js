require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_SEPOLIA_URL, 
      accounts: [process.env.PRIVATE_KEY], 
    },
   
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  sourcify: {
    enabled: true
  }
};



// 0xab386cbddf4198097b3b08e99ea3c815db6592841fd4b79a75cb8efb2f47e4e3