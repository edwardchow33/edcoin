module.exports = function(callback) {
	var account0 = '0x627306090abab3a6e1400e9345bc60c78a8bef57'
	var account1 = '0xebd57b7119a4ffaf0d7c6395a89c8a3f934fc4b5'
	
	const artifacts1 = require('./build/contracts/Finchain.json')
	const artifacts2 = require('./build/contracts/Power.json')
	const contract = require('truffle-contract')
	
	const Factory = contract(artifacts2)
	Factory.setProvider(web3.currentProvider);
	Factory.defaults({
		from: account0
	})
	
	var power;
	Factory.deployed()
	.then(function(instance) {
		power = instance
	}).then(function(result){
		console.log(result);
	})
	.catch(function(error) {
	  console.error(error);
	})
	
	const Finchain = contract(artifacts1);
	Finchain.setProvider(web3.currentProvider);
	Finchain.defaults({
		from: account0
	})
	var finchain;
	Finchain.deployed()
	.then(function(instance) {
		finchain = instance
		balance = finchain.balanceOf(account0)
		power.setcoin(finchain.address)
		return balance
	}).then(function(result){
		finchain.transferAndCall(power.address,4e18,1000)
		return finchain.balanceOf(power.address)
	}).then(function(result){
		console.log(result)
	})
	.catch(function(error) {
	  console.error(error);
	})
}
