var finchain = artifacts.require("Finchain");
var Power = artifacts.require("Power");

contract('Finchain',function(accounts){
	var power;
	var fin;
	it("pending",function(){
		Power.deployed().then(function(instance){
				power = instance
		})
		return finchain.deployed().then(function(instance){
			fin = instance;
			fin.enableTransfer();
			power.setcoin(instance.address)
			return instance.transferAndCall(power.address,4e18,1000)
		}).then(function(result){
			return power.balanceOfPending(accounts[0])
		}).then(function(balance){
			console.log(balance)
			//assert.equal(balance.valueOf(), 4e18, "Power up failed");
		})
	})
});