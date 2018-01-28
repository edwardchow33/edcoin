pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

interface ERC20 { function transfer(address _to, uint256 _value) public returns (bool); function balanceOf(address _owner) public view returns (uint256 balance);}

contract PowerFactory is Ownable{
	address public edcoin;
	address public edpower;
	
	function setedcoin(address _contract) onlyOwner external{
		edcoin = _contract;
	}
	function setedpower(address _contract) onlyOwner external{
		edpower = _contract;
	}
	function powerlevel() public view returns (uint256){
		ERC20 power = ERC20(edpower);
		return power.balanceOf(this);
	}
	function tokenFallback(address _sender,
                       uint256 _value,
                       bytes _extraData) public returns (bool) {
		ERC20 power = ERC20(edpower);
		ERC20 coin = ERC20(edcoin);
		require(msg.sender == edcoin || msg.sender == edpower);
		if(msg.sender == edcoin){
			if(power.balanceOf(this) < _value){
				coin.transfer(_sender,_value);
				return false;
			}
			power.transfer(_sender,_value);
			return true;
		}
		if(msg.sender == edpower){
			if(coin.balanceOf(this) < _value){
				power.transfer(_sender,_value);
				return false;
			}
			coin.transfer(_sender,_value);
			return true;
		}
		return false;
	}
}