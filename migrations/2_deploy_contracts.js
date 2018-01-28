const Edcoin = artifacts.require("./edcoin.sol")
const Edpower = artifacts.require("./edpower.sol")
const powerfactory = artifacts.require("./powerfactory.sol")
const power = artifacts.require("./power.sol")

module.exports = function(deployer) {
  deployer.deploy(Edcoin);
  deployer.deploy(Edpower);
  deployer.deploy(powerfactory);
  deployer.deploy(power);
};