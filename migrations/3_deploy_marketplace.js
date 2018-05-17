'use strict';

const DeusMarketplace = artifacts.require("./DeusMarketplace.sol");
const DeusToken = artifacts.require("./DeusToken.sol");

module.exports = function(deployer, network, accounts) {
  let wallet = accounts[0];
  return deployer.deploy(DeusMarketplace, DeusToken.address, wallet);
};
