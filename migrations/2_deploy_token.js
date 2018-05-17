'use strict';

const DeusToken = artifacts.require("./DeusToken.sol");

module.exports = function(deployer) {
  return deployer.deploy(DeusToken);
};
