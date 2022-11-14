const { network } = require("hardhat");
const { networkConfig } = require("../helper-hardhat-config");
// using synctactic sugar
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;

  //   if chainId is X use address Y
  // Here the aave comes for the problem
  // const address = "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e";
  const ethUsdPriceFeed = networkConfig[chainId]["ethUsdPriceFeed"];

  // what do we do for the chain that doesn't even have a price feed address on it

  // if the contract doesn't exist, we deploy a minimal version for our local testing
  // Mock is technically a deploy script

  // well what happens when we want to change chains?
  // when working on localhost or hardhat network we want to use a mock
  const fundMe = await deploy("FundMe", {
    from: deployer,
    args: [ethUsdPriceFeed], //put price feed address
    log: true,
  });
};
