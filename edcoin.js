module.exports = function(callback) {
	var account0 = '0x627306090abab3a6e1400e9345bc60c78a8bef57'
	var account1 = '0xebd57b7119a4ffaf0d7c6395a89c8a3f934fc4b5'
	const artifacts = require('./build/contracts/edcoin.json')
	const artifacts2 = require('./build/contracts/PowerFactory.json')
	const artifacts3 = require('./build/contracts/EdPower.json')
	const contract = require('truffle-contract')
	
	
	const Factory = contract(artifacts2)
	Factory.setProvider(web3.currentProvider);
	Factory.defaults({
		from: account0
	})
	
	var factory;
	var power;
	var coin;
	
	Factory.deployed()
	.then(function(instance) {
		factory = instance
	})
	.catch(function(error) {
	  console.error(error);
	})
	
	const EdPower = contract(artifacts3);
	EdPower.setProvider(web3.currentProvider);
	EdPower.defaults({
		from: account0
	})

	EdPower.deployed()
	.then(function(instance) {
		power = instance
		factory.setedpower(power.address)
		power.setPowerFactoryContract(factory.address)
		return factory.powerlevel()
	}).then(function(result){
		console.log(result);
	})
	.catch(function(error) {
	  console.error(error);
	})
	
	
	const EdCoin = contract(artifacts);
	EdCoin.setProvider(web3.currentProvider);
	EdCoin.defaults({
		from: account0
	})
	EdCoin.deployed()
	.then(function(instance) {
		coin = instance
		factory.setedcoin(coin.address)
		return coin.transferAndCall(factory.address,8000,100)
		
	}).then(function(result){
		console.log(result);
	})
	.catch(function(error) {
	  console.error(error);
	})
	
	
}
