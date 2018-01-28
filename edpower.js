module.exports = function(callback) {
	var account0 = '0x627306090abab3a6e1400e9345bc60c78a8bef57'
	var account1 = '0xebd57b7119a4ffaf0d7c6395a89c8a3f934fc4b5'
	
	const artifacts1 = require('./build/contracts/EdPower.json')
	const artifacts2 = require('./build/contracts/PowerFactory.json')
	const contract = require('truffle-contract')
	
	const Factory = contract(artifacts2)
	Factory.setProvider(web3.currentProvider);
	Factory.defaults({
		from: account0
	})
	
	var factory;
	Factory.deployed()
	.then(function(instance) {
		factory = instance
	}).then(function(result){
		console.log(result);
	})
	.catch(function(error) {
	  console.error(error);
	})
	
	const EdPower = contract(artifacts1);
	EdPower.setProvider(web3.currentProvider);
	EdPower.defaults({
		from: account0
	})
	var power;
	EdPower.deployed()
	.then(function(instance) {
		power = instance
		balance = power.balanceOf(account0)
		factory.setedpower(power.address)
		return balance
	}).then(function(result){
		power.transfer(factory.address,result)
		return power.balanceOf(factory.address)
	}).then(function(result){
		console.log(result)
	})
	.catch(function(error) {
	  console.error(error);
	})
}
