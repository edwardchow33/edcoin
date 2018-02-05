var finchain = artifacts.require("Finchain");
var Power = artifacts.require("Power");

contract('Finchain',function(accounts){
	var power;
	var fin;
	it("powerUp",function(){
		Power.deployed().then(function(instance){
				power = instance
		})
		return finchain.deployed().then(function(instance){
			fin = instance;
			fin.enableTransfer();
			power.setcoin(instance.address)
			return instance.transferAndCall(power.address,4e18,1000)
		}).then(function(result){
			power.powerUp(accounts[0]);
			return power.balanceOfPower(accounts[0])
		}).then(function(balance){
			assert.equal(balance.valueOf(), 4e18, "Power up failed");
		})
	})
	it("powerDown",function(){
		power.balanceOfPower(accounts[0]).then(function(balance){
			power.powerDown(2e18);
			return power.balanceOfPower(accounts[0])
		}).then(function(balance){
			assert.equal(balance.valueOf(), 2e18, "Power down failed");
			return fin.balanceOf(accounts[0]);
		}).then(function(balance){
			assert.equal(balance, 10000000000e18-2e18, "Power down failed");
			return fin.balanceOf(power.address);
		}).then(function(balance){
			assert.equal(balance, 2e18, "Power down failed");
		})
	})
});