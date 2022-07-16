// var token = artifacts.require("./Token.sol");
var dex = artifacts.require("./DEX.sol");

module.exports = async function (deployer) {
  const deployed = deployer.deploy(dex);
};
