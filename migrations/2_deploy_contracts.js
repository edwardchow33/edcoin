const Finchain = artifacts.require("./finchain.sol")
const Power = artifacts.require("./power.sol")

module.exports = function(deployer) {
  //deployer.deploy(Finchain,10000000000,"Finchain","FIN",18);
  deployer.deploy(Power);
};