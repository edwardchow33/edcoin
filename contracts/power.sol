pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';


contract Power is StandardToken, BurnableToken, Ownable{
	
	string public name = "Ed Power";
	string public symbol = "EDP";
	uint8 public constant decimals = 18;
	bool public transfer_enabled = false;
	uint256 public constant INITIAL_SUPPLY = 0;
	StandardToken public coin;

	
	event PendingToPowerUp(address indexed addr, uint256 value);
	event PowerDown(address indexed addr, uint256 value);
	
	mapping (address => pending[]) public pendings;
	mapping (address => uint256) public power;
    struct pending {
		uint64 sinceTime;
		uint256 amount;
    }
	
	function Power() public{
		totalSupply_  = INITIAL_SUPPLY;
		balances[msg.sender] = totalSupply_ ;
	}
	
	
	
	function setcoin(address _addr) external onlyOwner{

		coin = StandardToken(_addr);
	}
	
	function transfer(address _to, uint256 _value) public returns (bool) {
        return false;
    }
	
	function powerDown(uint256 _value) public returns (bool) {
		uint256 amount = balanceOfPower(msg.sender);
		require(amount > 0);   							//user has power
		require(amount >= _value);  					//don't let it underflow
		require(totalSupply_ >= _value);				//don't let it underflow
		require(coin.balanceOf(address(this)) >= _value);  		//contract need to have enough coin to power down
		
		power[msg.sender] = amount.sub(_value);
		totalSupply_ = totalSupply_.sub(_value);
		coin.transfer(msg.sender,_value);
		PowerDown(msg.sender,_value);
		return true;
		
	}
	
	
	function tokenFallback(address _sender,
                       uint256 _value,
                       bytes _extraData) public returns (bool) {
		require(msg.sender == address(coin));
		pendings[_sender].push(pending(uint64(now),_value));
		//balances[_sender] = balances[_sender].add(_value);
		totalSupply_ = totalSupply_.add(_value);
		
		PendingToPowerUp(msg.sender,_value);
		return true;
		
	}
	
	function powerUp(address _address) external returns(bool){
		if(pendings[_address].length > 0){
			for(uint i = 0; i < pendings[_address].length;i++){
				if(pendings[_address][i].sinceTime + 1 minutes <= now){
					power[_address] = power[_address].add(pendings[_address][i].amount);
					delete pendings[_address][i];
				}
			}
			
		}
		return true;
	}
	
	function balanceOfPending(address _address) public view returns(uint amount) {
		//amounts = new uint[](pendings[_address].length);
		//deltas =  new uint[](pendings[_address].length);
		for(uint i = 0; i < pendings[_address].length;i++){
			if(pendings[_address][i].amount > 0){
				amount = amount.add(pendings[_address][i].amount);
			}
		}
	}
	
	function balanceOfPower(address _address) public view returns(uint256 balance) {
		return power[_address];
	}
}