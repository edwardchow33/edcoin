const Edcoin = artifacts.require("./edcoin.sol")
const Edpower = artifacts.require("./edpower.sol")
const powerfactory = artifacts.require("./powerfactory.sol")

module.exports = function(deployer) {
  deployer.deploy(Edcoin);
  deployer.deploy(Edpower);
  deployer.deploy(powerfactory);
};