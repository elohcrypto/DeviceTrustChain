require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.19",
  networks: {
    // For local Geth node
    geth: {
      url: "http://localhost:8545",
      chainId: 1337,
      accounts: [
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" // Default Hardhat account #0
      ]
    },
    // For testing
    hardhat: {
      chainId: 31337,
    }
  }
};