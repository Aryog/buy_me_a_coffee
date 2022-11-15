// for own mock price feed contract
// for network that doesn't have any price feed contracts address
const { network } = require("hardhat");
const {
  developmentChains,
  DECIMALS,
  INITIAL_ANSWER,
} = require("../helper-hardhat-config");
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  // all above data from hre (Hardhat Runtime Environment)
  if (developmentChains.includes(network.name)) {
    log("Local netork detected! Deploying mocks...");
    await deploy("MockV3Aggregator", {
      contract: "MockV3Aggregator",
      from: deployer,
      log: true,
      args: [DECIMALS, INITIAL_ANSWER],
    });
    log("Mocks deployed!");
    log("---------------------------------------------------");
  }
};

module.exports.tags = ["all", "mocks"];
